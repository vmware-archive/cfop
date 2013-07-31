require "#{ENV["_CFOP_ROOT"]}/share/spec/spec_helper"
require "cfop/bosh_state"
require "yaml"

describe CfOp::BoshState do
  subject(:bosh_state) do
    described_class.from_file("#{fixtures_path}/state.yml")
  end

  it "has the right default_path" do
    expect(described_class.default_path).to eq("/var/vcap/bosh/state.yml")
  end

  it "does not allow calling new directly" do
    expect {
      described_class.new("/some/path")
    }.to raise_error(NoMethodError, /private method/)
  end

  its(:job_name) { should eq("job_name") }
  its(:job_index) { should eq(5) }

  its(:nats_uri) { should eq("nats://nats_user:nats_password@192.0.2.4:4222")}

  it "can build a UAADB command" do
    command = bosh_state.uaadb_command("/some/path")
    expect(command).to eq(%w(mysql --defaults-extra-file=/some/path -h uaadb.example.com -P 3306 -D uaadb -u uaadb_user))
  end

  its(:uaadb_password) { should eq("uaadb_password") }

  describe "ccdb" do
    context "when property key ccdb_ng is present" do
      it "can build a CCDB command" do
        command = bosh_state.ccdb_command("/some/path")
        expect(command).to eq(%w(mysql --defaults-extra-file=/some/path -h ccdb.example.com -P 3306 -D ccdb -u ccdb_user))
      end

      its(:ccdb_password) { should eq("ccdb_password") }
    end

    context "when property key ccdb_ng is missing but ccdb is present" do
      # as currently is the case with state.yml on UAA
      subject(:bosh_state) do
        yaml = YAML.load_file("#{fixtures_path}/state.yml")
        ccdb = yaml["properties"].delete("ccdb_ng")
        yaml["properties"]["ccdb"] = ccdb
        described_class.from_hash(yaml)
      end

      it "can build a CCDB command" do
        command = bosh_state.ccdb_command("/some/path")
        expect(command).to eq(%w(mysql --defaults-extra-file=/some/path -h ccdb.example.com -P 3306 -D ccdb -u ccdb_user))
      end

      its(:ccdb_password) { should eq("ccdb_password") }
    end
  end
end
