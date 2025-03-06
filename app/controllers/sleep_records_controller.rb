class SleepRecordsController < ApplicationController
  before_action :set_user

  def index
    pagy, records = pagy(@user.sleep_records.order(created_at: :desc))

    render json: { 
      data: ActiveModelSerializers::SerializableResource.new(records, each_serializer: SleepRecordSerializer),
      pagination: pagy_metadata(pagy)
    }
  end

  def clock_in
    if @user.sleep_records.where(clock_out: nil).exists?
      return render json: { message: "You've an active sleep session, please clock out first." }, status: :unprocessable_entity
    end

    record = @user.sleep_records.create!(clock_in: Time.current)

    render json: { message: "Success", data: SleepRecordSerializer.new(record) }, status: :ok
  end

  def clock_out
    record = @user.sleep_records.where(clock_out: nil).order(:clock_in).last
    if record.nil?
      return render json: { message: "No active sleep session" }, status: :unprocessable_entity
    end

    now = Time.current
    record.update!(clock_out: now, duration: (now - record.clock_in).to_i)

    render json: { message: "Success", data: SleepRecordSerializer.new(record) }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end