describe Track do
  context "fp" do
    it "should work" do
      data = json_fixture("finger-input.json")
      fp = Fingerprint::Inflate.new(data.first[:code]).inflate
      Track.fp(fp)
    end
  end
end
