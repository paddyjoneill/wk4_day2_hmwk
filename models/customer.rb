require('pg')
require('pry')
require_relative('./film')
require_relative('./ticket')
require_relative('../db/sql_runner')

class Customer

  attr_reader :id
  attr_accessor :first_name, :last_name, :cash

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
    @cash = options['cash'].to_i
  end

  def save()
    sql = "INSERT INTO customers (
    first_name, last_name, cash
    ) VALUES (
      $1, $2, $3
      ) RETURNING id"
    values = [@first_name, @last_name, @cash]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM customers"
    results = SqlRunner.run(sql)
    customers = results.map { |customer| Customer.new(customer) }
    return customers
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id =$1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = " UPDATE customers SET (
      first_name, last_name, cash
    ) = (
      $1, $2, $3
    ) WHERE id = $4;"
    values = [@first_name, @last_name, @cash, @id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films
      INNER JOIN tickets
      ON tickets.film_id = films.id
      WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    films = results.map { |film| Film.new(film) }
    return films
  end

  def film_count()
    result = films()
    result.count
  end

  def can_afford_purchase(amount)
    if @cash > amount
      return 1
    end
    return nil
  end

  def take_payment(amount)
    if @cash > amount
      @cash -= amount
      update()
    end
  end

end
