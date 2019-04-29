# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Airport.create(code: "ATL", name: "Hartsfield-Jackson Atlanta International Airport")
Airport.create(code: "LAX", name: "Los Angeles International Airport")
Airport.create(code: "ORD", name: "O'Hare International Airport")
Airport.create(code: "DFW", name: "Dallas/Fort Worth International Airport")
Airport.create(code: "DEN", name: "Denver International Airport")
Airport.create(code: "JFK", name: "John F. Kennedy International Airport")
Airport.create(code: "SFO", name: "San Francisco International Airport")

arr = (1..7).to_a
perms = arr.permutation(2).to_a
perms.each do |perm|
    10.times do |n|
        Flight.create(from_airport: Airport.find(perm[0]), 
            to_airport: Airport.find(perm[1]),
            departure: Time.now + n.days, 
            duration: "#{1 + rand(9)} hours #{1 + rand(59)} minutes")
    end
end