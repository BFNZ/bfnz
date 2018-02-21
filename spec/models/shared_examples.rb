shared_examples_for 'date_range' do

  let!(:dec31) do
    Timecop.freeze(Time.new(2013,12,31,1,0,0)) { Order.make!(:shipped) }
  end
  let!(:jan1) do
    Timecop.freeze(Time.new(2014,1,1,11,0,0)) { Order.make!(:shipped) }
  end
  let!(:jan31) do
    Timecop.freeze(Time.new(2014,1,31,12,0,0)) { Order.make!(:shipped) }
  end
  let!(:feb1) do
    Timecop.freeze(Time.new(2014,2,1,1,0,0)) { Order.make!(:shipped) }
  end

  it "returns order that were shipped on or in between the dates specified" do
    expect(subject).to match_array [jan1, jan31]
  end

end