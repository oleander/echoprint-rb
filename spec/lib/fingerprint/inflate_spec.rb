describe Fingerprint::Inflate do
  it "should ingest fingerprint" do
    json = json_fixture("finger-input.json")
    data = Fingerprint::Inflate.new(json.first.fetch("code")).inflate
    json2 = json_fixture("finger-output.json")
    data[:times].should eq(json2["times"])
    data[:codes].should eq(json2["codes"])
  end
end