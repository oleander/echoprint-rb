module Support
  def json_fixture(file)
    JSON.parse(File.read(Rails.root.join("spec/fixtures/#{file}")))
  end
end