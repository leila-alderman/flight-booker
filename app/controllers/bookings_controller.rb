class BookingsController < ApplicationController

  @@gateway_token = "ROvQPckMbDyyE3cBYKpZCmrHYpK"

  def show
    @booking = Booking.find(params[:id])
  end
  
  def new
    @flight = Flight.find(params[:flight_id])
    @booking = @flight.bookings.build
    @num_passengers = params[:num_passengers].to_i
    @total = @flight.price * @num_passengers
  end

  def create
    @flight = Flight.find(params[:flight_id])
    @booking = @flight.bookings.create(booking_params)
    @purchase_response = %x(curl https://core.spreedly.com/v1/gateways/#{@@gateway_token}/purchase.json \
      -u '#{ENV["env_key"]}:#{ENV["access_secret"]}' \
      -H 'Content-Type: application/json' \
      -d "{
            \"transaction\": {
              \"payment_method_token\": \"#{}\",
              \"amount\": #{},
              \"currency_code\": "USD",
              \"retain_on_success\": #{}
            }
          }")
    redirect_to [@flight, @booking]
  end

  private
    def booking_params
      params.require(:booking).permit(:num_passengers, :total_price)
    end

end
