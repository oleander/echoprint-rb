describe Fingerprint::Inflate do
  it "should ingest fingerprint" do
    input = json_fixture("finger-input.json")
    output = json_fixture("finger-output.json")
    data = Fingerprint::Inflate.new(input.first[:code]).inflate
    expect(data[:times]).to eq(output[:times])
    expect(data[:codes]).to eq(output[:codes])
  end

  it "should handle invalid base64 data" do
    expect {
      Fingerprint::Inflate.new("invalid").inflate
    }.to raise_error(Fingerprint::InvalidCode)
  end

  it "should handle invalid zlib data" do
    data = Base64.urlsafe_encode64 "invalid"
    expect {
      Fingerprint::Inflate.new(data).inflate
    }.to raise_error(Fingerprint::InvalidCode)
  end

  it "should handle invalid data" do
    data = Zlib::Deflate.new.deflate("invalid")
    data = Base64.urlsafe_encode64(data)
    expect {
      Fingerprint::Inflate.new(data).inflate
    }.to raise_error(Fingerprint::InvalidCode)
  end
end