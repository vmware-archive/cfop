require "#{ENV["_CFOP_ROOT"]}/share/spec/spec_helper"
require "cfop/common"

describe CfOp::Common do
  describe ".find_prod_yaml_file" do
    it "defaults to the Pivotal workstation file structure but uses $CFOP_AWS_STUB" do
      ENV.should_receive(:fetch).with("CFOP_AWS_STUB", File.expand_path("~/workspace/prod-aws/cf-aws-stub.yml")).and_return("the_path")
      expect(described_class.find_prod_yaml_file).to eq("the_path")
    end
  end
end
