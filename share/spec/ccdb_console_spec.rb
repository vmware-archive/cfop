require "#{ENV["_CFOP_ROOT"]}/share/spec/spec_helper"
require "cfop/ccdb_console"
require "yaml"

describe CfOp::CcdbConsole do
  describe ".build_command" do
    it "should build the correct mysql command" do
      yaml = YAML.load_file("#{fixtures_path}/cf-aws-stub.yml")
      command = described_class.build_command(yaml, "/some/path")
      expect(command).to eq(%w(mysql --defaults-extra-file=/some/path -h ccdb.example.com -P 3306 -D ccdb -u ccdb_user))
    end
  end

  describe ".ccdb_password" do
    it "extracts the correct password" do
      yaml = YAML.load_file("#{fixtures_path}/cf-aws-stub.yml")
      expect(described_class.ccdb_password(yaml)).to eq("ccdb_password")
    end
  end
end
