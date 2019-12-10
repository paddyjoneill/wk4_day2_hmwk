require('pg')
require('pry')
require_relative('./models/customer')
require_relative('./models/ticket')
require_relative('./models/film')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({
  'first_name' => 'Bob',
  'last_name' => 'Jones',
  'cash' => 50
  })
customer1.save()

customer2 = Customer.new({
  'first_name' => 'Tracy',
  'last_name' => 'Stevens',
  'cash' => 100
  })
customer2.save()

film1 = Film.new({
  'title' => 'Star Wars',
  'price' => 8,
  'show_time' => '20:00',
  'capacity' => 100,
  'tickets_sold' => 0
  })
film1.save()

film2 = Film.new({
  'title' => 'Jumanji',
  'price' => 8,
  'show_time' => '19:00',
  'capacity' => 100,
  'tickets_sold' => 0
  })
film2.save()

film3 = Film.new({
  'title' => 'Jumanji',
  'price' => 8,
  'show_time' => '20:30',
  'capacity' => 100,
  'tickets_sold' => 0
  })
film3.save()

film4 = Film.new({
  'title' => 'Harry Potter',
  'price' => 8,
  'show_time' => '20:15',
  'capacity' => 100,
  'tickets_sold' => 0
  })
film4.save()

film5 = Film.new({
  'title' => 'Big',
  'price' => 8,
  'show_time' => '19:45',
  'capacity' => 100,
  'tickets_sold' => 0
  })
film5.save()

ticket1 = Ticket.sell_ticket(film1, customer1)
ticket2 = Ticket.sell_ticket(film1, customer2)
ticket3 = Ticket.sell_ticket(film2, customer1)



binding.pry
nil
