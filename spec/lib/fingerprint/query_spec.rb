describe Fingerprint::Query do
  it "should work" do
    output = json_fixture("finger-output.json")
    input = json_fixture("finger-input.json")
    track1 = Fingerprint::Ingest.new(output, 1).ingest
    track2 = Fingerprint::Query.new(input.first[:code]).query
    expect(track1).to eq(track2)
  end
end