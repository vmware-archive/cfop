require "yaml"

module CfOp
  class BoshState
    class << self
      def default_path
        "/var/vcap/bosh/state.yml"
      end

      def from_file(path)
        File.open(path) do |f|
          from_hash(YAML.load_file(f))
        end
      end

      def from_hash(hash)
        new(hash)
      end
    end

    def initialize(yaml)
      @yaml = yaml
    end

    def job_name
      @yaml.fetch("job").fetch("name")
    end

    def job_index
      @yaml.fetch("index")
    end

    def nats_uri
      nats_hash = @yaml.fetch("properties").fetch("nats")
      user = nats_hash.fetch("user")
      password = nats_hash.fetch("password")
      host = nats_hash.fetch("address")
      port = nats_hash.fetch("port")
      "nats://#{user}:#{password}@#{host}:#{port}"
    end

    def uaadb_command(conf_path)
      uaadb = @yaml.fetch('properties').fetch('uaadb')

      host = uaadb.fetch('address')
      port = uaadb.fetch('port')
      user = uaadb.fetch('roles').fetch(0).fetch('name')
      db_name = uaadb.fetch('databases').fetch(0).fetch('name')
      %W(mysql --defaults-extra-file=#{conf_path} -h #{host} -P #{port} -D #{db_name} -u #{user})
    end

    def uaadb_password
      uaadb = @yaml.fetch('properties').fetch('uaadb')
      uaadb.fetch('roles').fetch(0).fetch('password')
    end

    def ccdb_command(conf_path)
      ccdb = ccdb_properties

      host = ccdb.fetch('address')
      port = ccdb.fetch('port')
      user = ccdb.fetch('roles').fetch(0).fetch('name')
      db_name = ccdb.fetch('databases').fetch(0).fetch('name')
      %W(mysql --defaults-extra-file=#{conf_path} -h #{host} -P #{port} -D #{db_name} -u #{user})
    end

    def ccdb_password
      ccdb_properties.fetch('roles').fetch(0).fetch('password')
    end

    # Consumers should only call #from_file
    private_class_method :new

    private
    def ccdb_properties
      properties = @yaml.fetch("properties")
      properties.fetch("ccdb_ng") { properties.fetch("ccdb") }
    end
  end
end
