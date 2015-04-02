describe Track do
  context "fp" do
    it "should work" do
      data = json_fixture("finger-input.json")
      fp = Fingerprint::Inflate.new(data.first[:code]).inflate
      expect(Track.fp(fp)).to_not be_nil
    end
  end

  it "should default to valid" do
    expect(build(:track)).to be_valid
  end

  it "should only allow certain versions" do
    expect(build(:track, version: "invalid")).to_not be_valid
    expect(build(:track, version: "")).to_not be_valid
    expect(build(:track, version: nil)).to_not be_valid
  end

  it "must have an external id" do
    expect(build(:track, external_id: nil)).to_not be_valid
    expect(build(:track, external_id: "")).to_not be_valid
  end

  it "should have a positive duration" do
    expect(build(:track, duration: nil)).to_not be_valid
    expect(build(:track, duration: -1)).to_not be_valid
    expect(build(:track, duration: 10)).to be_valid
  end
end