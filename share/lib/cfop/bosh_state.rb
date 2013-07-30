require "yaml"

module CfOp
  class BoshState
    class << self
      def default_path
        "/var/vcap/bosh/state.yml"
      end

      def from_file(path)
        File.open(path) do |f|
          new(YAML.load_file(f))
        end
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

    def ccdb_command(conf_path)
      ccdb = @yaml.fetch('properties').fetch('ccdb_ng')

      host = ccdb.fetch('address')
      port = ccdb.fetch('port')
      user = ccdb.fetch('roles').fetch(0).fetch('name')
      db_name = ccdb.fetch('databases').fetch(0).fetch('name')
      %W(mysql --defaults-extra-file=#{conf_path} -h #{host} -P #{port} -D #{db_name} -u #{user})
    end

    def ccdb_password
      @yaml.fetch('properties').fetch('ccdb_ng').fetch('roles').fetch(0).fetch('password')
    end

    # Consumers should only call #from_file
    private_class_method :new
  end
end
