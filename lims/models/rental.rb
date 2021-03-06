require_relative( '../db/sql_runner' )

class Rental

  attr_reader :id, :book_id, :customer_id

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @book_id = options['book_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  def save()
    sql = "INSERT INTO rentals (book_id, customer_id) VALUES ($1, $2) RETURNING id"
    values = [@book_id, @customer_id]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM rentals"
    rentals = SqlRunner.run(sql)
    return rentals.map{|rental_hash| Rental.new(rental_hash)}
  end

  def book()
    sql = "SELECT * FROM books WHERE id = $1"
    values = [@book_id]
    book = SqlRunner.run(sql, values)
    return Book.new(book.first)
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    cust = SqlRunner.run(sql, values)
    return Customer.new(cust.first)
  end

  def self.delete(id)
    sql = "DELETE FROM rentals WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM rentals"
    SqlRunner.run( sql )
  end

end
