class BookingsController < ApplicationController

  @@token = "ROvQPckMbDyyE3cBYKpZCmrHYpK"

  def show
    @booking = Booking.find(params[:id])
  end
  
  def new
    @flight = Flight.find(params[:flight_id])
    @booking = @flight.bookings.build
    @num_passengers = params[:num_passengers].to_i
  end

  def create
    @flight = Flight.find(params[:flight_id])
    @booking = @flight.bookings.create(booking_params)
    redirect_to [@flight, @booking]
  end

  private
    def booking_params
      params.require(:booking).permit(:num_passengers)
    end

end
