require "#{ENV["_CFOP_ROOT"]}/share/spec/spec_helper"
require "cfop/instance_snapshot"

describe CfOp::InstanceSnapshot do
  subject(:instance_snapshot) do
    described_class.from_file("#{fixtures_path}/instances.json")
  end

  it "does not allow calling new directly" do
    expect {
      described_class.new({})
    }.to raise_error(NoMethodError, /private method/)
  end

  it "supplies the right default path" do
    expect(described_class.default_path).to eq("/var/vcap/data/dea_next/db/instances.json")
  end

  describe "#warden_handles_by_app_name" do
    it "can find single warden handles by app name" do
      handles = instance_snapshot.warden_handles_by_app_name("awesome-app")
      expect(handles).to eq(%w(171sb2c1gjp))
    end

    it "can find multiple warden handles by app name" do
      handles = instance_snapshot.warden_handles_by_app_name("lame-app")
      expect(handles).to eq(%w(171sb2c1gji 171sb2c1gjj))
    end

    it "returns an empty array if there are no matches" do
      expect(instance_snapshot.warden_handles_by_app_name("missing-app")).to eq([])
    end
  end

  describe "#warden_handles_by_app_guid" do
    it "can find single warden handles by app guid" do
      handles = instance_snapshot.warden_handles_by_app_guid("9aa5a59b-489a-4fc3-9dd3-eb83d3e925a1")
      expect(handles).to eq(%w(171sb2c1gjp))
    end

    it "can find warden handles by app guid" do
      handles = instance_snapshot.warden_handles_by_app_guid("8dc0cdb3-45f7-45fb-a0ee-584182c2fb81")
      expect(handles).to match_array(%w(171sb2c1gji 171sb2c1gjj))
    end

    it "returns an empty array if there are no matches" do
      expect(instance_snapshot.warden_handles_by_app_guid("not-even-a-guid")).to eq([])
    end
  end
end
