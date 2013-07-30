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

    # Consumers should only call #from_file
    private_class_method :new
  end
end
