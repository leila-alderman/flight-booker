class BookingsController < ApplicationController

  def index
    @bookings = Booking.all
  end
  
  def show
    @booking = Booking.find(params[:id])
  end
  
  def new
    @flight = Flight.find(params[:flight_id])
    @booking = @flight.bookings.build
    @num_passengers = params[:num_passengers].to_i
    @total_price = @flight.price * @num_passengers
    
    # If user has just completed filling out the Spreedly Express pop-up form, 
    # then the URL will contain the payment_method_token query parameter
    if params[:payment_method_token]
      @payment_method_token = params[:payment_method_token]
      data = {
        transaction: {
          payment_method_token: @payment_method_token,
          amount: @total_price * 100,
          currency_code: "USD",
          retain_on_success: false
        }
      }
      purchase_response = `curl https://core.spreedly.com/v1/gateways/#{ENV["TEST_GATEWAY_TOKEN"]}/purchase.json \
        -u "#{ ENV["ENV_KEY"] }:#{ ENV["ACCESS_SECRET"] }" \
        -H 'Content-Type: application/json' \
        -d #{data.to_json}`
      full_response = %x{curl https://core.spreedly.com/v1/gateways/ROvQPckMbDyyE3cBYKpZCmrHYpK/purchase.json -u "ZsZlG3TIExW3qlEs5lOVIj4mEyN:UoN13oQN4oSWkN8zW87FvJuqT4efLdJJtLz5tpUCTK4a81V4v4OXC1AFUKIsZsN2" -H 'Content-Type: application/json' -d "{\"transaction\":{\"payment_method_token\":\"CYttCMCjt2ARpexVo3ewSXhExX5\",\"amount\":228800,\"currency_code\":\"USD\",\"retain_on_success\":false}}"}
      binding.pry
      # purchase_response = JSON.parse purchase_response
      if purchase_response.transaction.succeeded == true
        @booking.num_passengers = @num_passengers
        @booking.total_price = @total_price
        @booking.save
        flash[:success] = "Payment successful!"
        redirect_to flight_booking_path(@flight, @booking)
      else
        flash[:danger] = "Payment failed."
        redirect_to new_flight_booking(@flight)
      end
    end
  end

  def create

    @booking.payment_method_token = params[:payment_method_token]
    @booking.save

    
    # redirect_to flight_booking_path(@flight, @booking) #, payment_method_token: params[:payment_method_token]
    redirect_to root_path
  end

  private
    def booking_params
      params.require(:booking).permit(:num_passengers, :total_price)
    end

end
