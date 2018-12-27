class Api::V1::TripsController < ApplicationController

  before_action :find_trip, only: [:show,:update,:destroy]

  def index
    @trips = Trip.all
    render json: @trips
  end

  def show
    render json: @trip
  end

  def create
    @user = User.find_by_uid(request.headers["HTTP_UID"])
    @trip = @user.trips.new(trip_params)
    if @trip.save
      render json: {
        status: 'success',
        data: @trip,
        msg: "Congratulations your trip created successfully!"
      }
    else
      render json: {
        status: 'error',
        data: @trip.errors,
        msg: "Sorry! Your trip not created."
      }
    end
  end

  def update
    @trip.update(trip_params)
    render json: {
      status: 'success',
      data: @trip,
      msg: "Your trip updated successfully!"
    }
  end

  def destroy
    @trip.destroy
    render json: {
      status: 'deleted',
      data: @trip,
      msg: "Your trip deleted successfully!"
    }
  end

  private

  def find_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:start_date,:end_date,:duration,:user_id)
  end

end
