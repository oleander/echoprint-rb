describe Fingerprint::Inflate do
  it "should ingest fingerprint" do
    path = Rails.root.join("spec/fixtures/fingerprint.json")
    data = File.read(path)
    json = JSON.parse(data)

    puts Fingerprint::Inflate.new(json.first.fetch("code")).inflate
    pending "not propery tested"
  end
end