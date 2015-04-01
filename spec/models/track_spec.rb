describe Track do
  context "fp" do
    it "should work" do
      path = Rails.root.join("spec/fixtures/fingerprint.json")
      data = File.read(path)
      json = JSON.parse(data)

      fp = Fingerprint::Inflate.new(json.first.fetch("code")).inflate

      Track.fp(fp)
    end
  end
end
