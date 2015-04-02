describe Fingerprint::Query do
  it "work" do

    data = json_fixture("finger-output.json")
    data.symbolize_keys!

    track1 = Fingerprint::Ingest.new(data, 1).ingest

    data = json_fixture("finger-input.json")
    track2 = Fingerprint::Query.new(data.first.fetch("code")).query
    track1.id.should eq(track2.id)
  end
end