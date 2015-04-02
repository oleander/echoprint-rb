describe Code do
  it "should default to valid" do
    expect(build(:code)).to be_valid
  end

  it "must have a code > 0" do
    expect(build(:code, code: -1)).to_not be_valid
    expect(build(:code, code: nil)).to_not be_valid
  end

  it "must have a positive time" do
    expect(build(:code, time: -1)).to_not be_valid
    expect(build(:code, time: nil)).to_not be_valid
  end

  it "should only store unique values of code, time and track_id" do
    code = create(:code)
    expect(build(:code, {
      time: code.time, 
      code: code.code, 
      track: code.track
    })).to_not be_valid

    expect(build(:code, {
      time: code.time + 1, 
      code: code.code, 
      track: code.track
    })).to be_valid


    expect(build(:code, {
      time: code.time, 
      code: code.code + 1, 
      track: code.track
    })).to be_valid

    expect(build(:code, {
      time: code.time, 
      code: code.code, 
      track: create(:track)
    })).to be_valid
  end
end