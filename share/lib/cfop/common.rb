module CfOp
  module Common
    class << self
      def find_prod_yaml_file
        ENV.fetch("CFOP_AWS_STUB", File.expand_path("~/workspace/prod-aws/cf-aws-stub.yml"))
      end
    end
  end
end