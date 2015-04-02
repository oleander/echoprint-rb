describe Fingerprint::Inflate do
  it "should ingest fingerprint" do
    input = json_fixture("finger-input.json")
    output = json_fixture("finger-output.json")
    data = Fingerprint::Inflate.new(input.first[:code]).inflate
    expect(data[:times]).to eq(output[:times])
    expect(data[:codes]).to eq(output[:codes])
  end
end