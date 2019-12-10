require('pg')
require('pry')
require_relative('./customer')
require_relative('./film')
require_relative('../db/sql_runner')

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets (
    customer_id, film_id
    ) VALUES (
      $1, $2
      ) RETURNING id"
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    results = SqlRunner.run(sql)
    tickets = results.map { |ticket| Ticket.new(ticket) }
    return tickets
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id =$1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = " UPDATE tickets SET (
      customer_id, film_id
    ) = (
      $1, $2
    ) WHERE id = $3;"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.sell_ticket(film, customer)
    if customer.can_afford_purchase(film.price) != nil && (film.capacity - film.tickets_sold_sql) > 0
      customer.take_payment(film.price)
      customer.update
      film.tickets_sold += 1
      film.update
      ticket = Ticket.new({
        'customer_id' => customer.id,
        'film_id' => film.id
        })
    end
    ticket.save()
    return ticket
  end

end
