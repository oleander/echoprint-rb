describe Fingerprint::Ingest do
  it "work" do
    data = json_fixture("finger-output.json")
    data.symbolize_keys!

    track = Fingerprint::Ingest.new(data, 1).ingest
    track.codes.should_not be_empty
  end

  it "should return the same thing if ran twice" do
    data = json_fixture("finger-output.json")
    data.symbolize_keys!

    track1 = Fingerprint::Ingest.new(data, 1).ingest
    track2 = Fingerprint::Ingest.new(data, 1).ingest
    track1.should eq(track2)
  end
end