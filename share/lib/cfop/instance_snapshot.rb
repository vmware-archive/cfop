require "json"

module CfOp
  class InstanceSnapshot
    class << self
      def default_path
        "/var/vcap/data/dea_next/db/instances.json"
      end

      def from_file(path)
        File.open(path) do |f|
          new(JSON.load(f))
        end
      end
    end

    def initialize(json)
      @json = json
    end

    def warden_handles_by_app_name(name)
      @json["instances"].select {|i| i["application_name"] == name}.map {|i| i["warden_handle"]}
    end

    def warden_handles_by_app_guid(guid)
      @json["instances"].select {|i| i["application_id"] == guid}.map {|i| i["warden_handle"]}
    end

    # Consumers should only call #from_file
    private_class_method :new
  end
end
