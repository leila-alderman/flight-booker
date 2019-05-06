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
      # Extract the payment method token from the params (passed as a hidden form field)
      payment_method_token = params[:payment_method_token]
      # Set up the Spreedly enviornment using the environment key and access secret
      env = Spreedly::Environment.new(ENV["ENV_KEY"], ENV["ACCESS_SECRET"])

      # If the user has chosen to make the purchase through Expedia
      if params[:expedia] == "true"
        # Add the test receiver
        receiver = env.add_receiver("test", 
          host_names = "https://spreedly-echo.herokuapp.com", 
          credentials = [
            {
              "name": "app-id",
              "value": 1234,
              "safe": true
            },
            {
              "name": "app-secret",
              "value": 5678
            }
          ])
        # Process the payment transaction
        transaction = env.deliver_to_receiver(receiver.token, # receiver token for the test echo receiver
          payment_method_token,       # payment method token from the query parameters
          url: "https://spreedly-echo.herokuapp.com",
          headers: {"Content-Type" => "application/json"},
          body:
            {amount: @total_price * 100}) # add amount option in cents
      # Otherwise, use the Spreedly test gateway
      else
        # If the use has selected to save their card
        if params[:save_card]
          transaction = env.purchase_on_gateway(ENV["TEST_GATEWAY_TOKEN"], # gateway token for the test API gateway
            payment_method_token,     # payment method token from the query parameters
            @total_price * 100,       # purchase amount converted into cents
            retain_on_success: true)  # retain the payment method if the transaction is successful
        else
          transaction = env.purchase_on_gateway(ENV["TEST_GATEWAY_TOKEN"], # gateway token for the test API gateway
            payment_method_token,     # payment method token from the query parameters
            @total_price * 100)       # purchase amount converted into cents
        end
      end

      if transaction.succeeded?
        @booking.num_passengers = @num_passengers
        @booking.total_price = @total_price
        @booking.transaction_token = transaction.token
        @booking.save
        flash[:success] = "Payment successful!"
        # redirect_to flight_booking_path(@flight, @booking)
      else
        flash[:danger] = "Payment failed. Please try again."
        redirect_to new_flight_booking_path(@flight, num_passengers: @num_passengers)
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
