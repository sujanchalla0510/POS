require './data'
require './product'
require 'highline'

class Pos
  attr_reader :cli, :cart

  def initialize
    # initializing cart with empty array
    @cart = []
    # using highline gem for stdout and stdin
    @cli = HighLine.new
  end

  def main_menu
    puts '===================='
    cli.say 'Point Of Sale System'
    puts '===================='
    cli.choose do |menu|
      menu.prompt = 'select one of the option: '
      menu.choice(:start_scanning) { scan_menu }
      menu.choice(:view_my_cart) { my_cart }
      menu.choice(:add_new_product) { add_new_product }
      menu.choice(:list_products) { list_products }
      menu.choice(:exit)
    end
  end

  private

  def scan_menu
    print_newlines
    puts '===================='
    cli.say 'Scan Menu'
    puts '===================='
    cli.choose do |menu|
      menu.prompt = 'Select one of the option: '
      menu.choice('scan or enter barcode') { scan_or_enter_barcode }
      menu.choice('main menu') { main_menu }
      menu.choice('exit') { end_pos }
    end
  end

  def scan_or_enter_barcode
    print_newlines 2
    print 'Enter or Scan Barcode: '
    product_name = gets.chomp
    product = Product.first(name: product_name)
    if product
      cart << product
      print_newlines 2
      puts 'product added to cart'
      puts "Name: #{product.name} \nPrice: #{product.price}"
      scan_menu
    else
      puts 'Product Not Found'
      scan_menu
    end
  end

  def add_new_product
    print_newlines
    puts '===================='
    cli.say 'Adding New Product'
    puts '===================='
    product_name = cli.ask 'enter a product name'
    price = cli.ask 'enter a product price'
    puts '===================='
    Product.create(name: product_name, price: price)
    list_products
  end

  def list_products
    print_newlines
    puts '===================='
    cli.say 'Products in Database'
    puts '===================='
    Product.each_with_index do |product, i|
      puts "#{i + 1}. #{product.name}  #{product.price}"
    end
    puts '===================='

    cli.choose do |menu|
      menu.prompt = 'select option:'
      menu.choice(:main_menu) { main_menu }
      menu.choice(:enter_new_product) { add_new_product }
    end
  end

  def my_cart
    print_newlines
    puts '===================='
    cli.say 'My Cart'
    puts '===================='
    if cart.empty?
      puts 'Cart is Empty'
    else
      cart.each_with_index do |product, i|
        puts "#{i + 1}. #{product.name}  #{product.price}"
      end
    end
    print_newlines 2
    main_menu
  end

  def end_pos
    total = cart.collect(&:price).reduce(:+)
    puts "Total = $#{total}"

    File.open('./printer.txt', 'w+') do |file|
      cart.each_with_index do |product, i|
        file.puts "#{i + 1}. #{product.name}  #{product.price}"
      end
      file.puts "Total = $#{total}"
      file.close
    end
  end

  def print_newlines(i = 3)
    i.times { puts "\n" }
  end
end

Pos.new.main_menu
