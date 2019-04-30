class FlightsController < ApplicationController

  def index
    @airport_options = Airport.all.map { |a| ["#{a.code} - #{a.name}", a.id] }
    dates = Flight.all.map { |flight| flight.departure.strftime("%m/%d/%y") }
    @date_options = dates.uniq

    if params[:from_airport] || params[:to_airport]
        @flights = Flight.where(from_airport: Airport.find(params[:from_airport]), 
            to_airport: Airport.find(params[:to_airport]), 
            departure: DateTime.strptime(params[:date], "%m/%d/%y"))
    else        
        @flights = Flight.all
    end
  end

end
