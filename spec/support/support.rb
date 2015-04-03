module Support
  def json_fixture(file)
    JSON.parse(File.read(Rails.root.join("spec/fixtures/#{file}")), symbolize_names: true)
  end

  def mbid
    SecureRandom.uuid
  end
end