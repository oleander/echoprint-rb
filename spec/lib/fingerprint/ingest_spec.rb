describe Fingerprint::Ingest do
  it "create a new track" do
    data = json_fixture("finger-output.json")
    track = Fingerprint::Ingest.new(data, 1, 100).ingest
    expect(track.codes).not_to be_empty
  end
  
  it "should return the same track if ran twice" do
    data = json_fixture("finger-output.json")
    track1 = Fingerprint::Ingest.new(data, 1, 100).ingest
    track2 = Fingerprint::Ingest.new(data, 1, 100).ingest
    expect(track1).to eq(track2)
    expect(track1.external_id).to eq("1")
  end

  it "should not create a new track when code hasn't changed" do
    data = json_fixture("finger-output.json")
    track1 = Fingerprint::Ingest.new(data, 1, 100).ingest
    codes_count = Code.count
    track2 = Fingerprint::Ingest.new(data, 2, 100).ingest
    expect(track1).to eq(track2)
    expect(codes_count).to eq(Code.count)
  end
end