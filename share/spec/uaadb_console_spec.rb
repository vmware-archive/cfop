require "#{ENV["_CFOP_ROOT"]}/share/spec/spec_helper"
require "cfop/uaadb_console"
require "yaml"

describe CfOp::UaadbConsole do
  describe ".build_command" do
    it "should build the correct mysql command" do
      yaml = YAML.load_file("#{fixtures_path}/cf-aws-stub.yml")
      command = described_class.build_command(yaml, "/some/path")
      expect(command).to eq(%w(mysql --defaults-extra-file=/some/path -h uaadb.example.com -P 3306 -D uaadb -u uaadb_user))
    end
  end

  describe ".uaadb_password" do
    it "extracts the correct password" do
      yaml = YAML.load_file("#{fixtures_path}/cf-aws-stub.yml")
      expect(described_class.uaadb_password(yaml)).to eq("uaadb_password")
    end
  end
end
