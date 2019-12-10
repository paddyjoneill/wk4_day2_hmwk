require('pg')
require('pry')
require_relative('./customer')
require_relative('./ticket')
require_relative('../db/sql_runner')

class Film

  attr_reader :id
  attr_accessor :title, :price, :show_time, :tickets_sold, :capacity

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @show_time = options['show_time']
    @price = options['price'].to_i
    @tickets_sold = options['tickets_sold'].to_i
    @capacity = options['capacity'].to_i
  end

  def save()
    sql = "INSERT INTO films (
    title, price, show_time, tickets_sold, capacity
    ) VALUES (
    $1, $2, $3, $4, $5
    ) RETURNING id"
    values = [@title, @price, @show_time, @tickets_sold, @capacity]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM films"
    results = SqlRunner.run(sql)
    films = results.map { |film| Film.new(film) }
    return films
  end

  def self.find(title)
    sql = "SELECT * FROM films WHERE title = $1"
    values = [title]
    results = SqlRunner.run(sql,values)
    films = results.map { |film| Film.new(film) }
    return films
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id.to_i]
    results = SqlRunner.run(sql,values)
    film = results.map { |film| Film.new(film) }
    return film[0]
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM films WHERE id =$1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = " UPDATE films SET (
      title, price, show_time, tickets_sold, capacity
    ) = (
      $1, $2, $3, $4, $5
    ) WHERE id = $6;"
    values = [@title, @price, @show_time, @tickets_sold, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.* FROM customers
      INNER JOIN tickets
      ON tickets.customer_id = customers.id
      WHERE film_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    customers = results.map { |customer| Customer.new(customer) }
  end

  def customer_count()
    result = customers()
    return result.length
  end

  def self.show_times()
    films = self.all()
      for film in films
        puts "#{film.title} | #{film.show_time}"
      end
    return
  end

  def Film.most_pop_time(film)
    sql = "SELECT * FROM films WHERE title = $1"
    values = [film.title]
    results = SqlRunner.run(sql, values)
    films = results.map { |film| Film.new(film)  }
    most_pop = films.max_by { |film| film.tickets_sold }
    p "#{most_pop.show_time}"
    return
  end

  def tickets_sold_sql()
    sql = "SELECT COUNT(*) FROM tickets WHERE tickets.film_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    p results.first["count"].to_i
    return results.first["count"].to_i
  end

end
