require "#{ENV["_CFOP_ROOT"]}/share/spec/spec_helper"
require "cfop/bosh_state"

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

  it "can build a CCDB command" do
    command = bosh_state.ccdb_command("/some/path")
    expect(command).to eq(%w(mysql --defaults-extra-file=/some/path -h ccdb.example.com -P 3306 -D ccdb -u ccdb_user))
  end

  its(:ccdb_password) { should eq("ccdb_password") }
end
