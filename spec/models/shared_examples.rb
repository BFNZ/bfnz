shared_examples_for 'date_range' do

  let!(:dec31) do
    # 2013-12-31 01:00:00 NZ time
    Timecop.freeze(Time.zone.parse("2013-12-31 01:00:00")) { Order.make!(:shipped) }
  end
  let!(:jan1) do
    Timecop.freeze(Time.zone.parse("2014-01-01 11:00:00")) { Order.make!(:shipped) }
  end
  let!(:jan31) do
    Timecop.freeze(Time.zone.parse("2014-01-31 12:00:00")) { Order.make!(:shipped) }
  end
  let!(:feb1_start) do
    Timecop.freeze(Time.zone.parse("2014-02-01 00:00:00")) { Order.make!(:shipped) }
  end
  let!(:feb1) do
    Timecop.freeze(Time.zone.parse("2014-02-01 01:00:00")) { Order.make!(:shipped) }
  end

  it "returns order that were shipped on or in between the dates specified" do
    expect(subject).to match_array [jan1, jan31]
  end

end

shared_examples_for 'matching name' do |name|

  let!(:dennis) { Customer.make!(name => 'Dennis') }
  let!(:ayden)  { Customer.make!(name => 'Ayden') }
  let!(:dean)   { Customer.make!(name => 'Dean') }

  it "returns customers that match on #{name}" do
    expect(subject).to match_array [dennis, ayden]
  end
end
