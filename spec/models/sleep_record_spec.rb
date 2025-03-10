require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  let(:user) { create(:user) }

  it 'creates a sleep record with clock_in' do
    sleep_record = SleepRecord.new(user: user, clock_in: Time.current)
    expect(sleep_record.save).to be_truthy
  end

  it 'does not create a sleep record without clock_in' do
    sleep_record = SleepRecord.new(user: user)
    expect(sleep_record.save).to be_falsey
    expect(sleep_record.errors[:clock_in]).to include("can't be blank")
  end

  it 'does not allow clock_out before clock_in' do
    sleep_record = SleepRecord.new(user: user, clock_in: Time.current, clock_out: 1.hour.ago)
    expect(sleep_record.save).to be_falsey
    expect(sleep_record.errors[:clock_out]).to include("must be after clock_in time")
  end

  it 'sets duration on save' do
    sleep_record = SleepRecord.create!(user: user, clock_in: 2.hours.ago, clock_out: 1.hour.ago)
    expect(sleep_record.duration).to eq(3600)
  end
end