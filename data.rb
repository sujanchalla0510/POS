# sequel gem to connect to postgres database
require 'sequel'
DATABASE_URL = 'postgres://postgres:123456@localhost/pos'
DB = Sequel.connect(DATABASE_URL)

# create products table
create_products_table = %{
  CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    price float NOT NULL
  )
}

DB.run(create_products_table)
