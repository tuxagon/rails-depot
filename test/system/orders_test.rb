require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "check pay type form" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    first('.catalog li').click_on 'Add to Cart'

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector "#order_routing_number"
    assert_no_selector "#order_account_number"

    select 'Check', from: 'pay_type'

    assert_selector "#order_routing_number"
    assert_selector "#order_account_number"

    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    perform_enqueued_jobs do
      click_button "Place Order"
    end

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal "Dave Thomas",      order.name
    assert_equal "123 Main Street",  order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check",            order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"],                 mail.to
    assert_equal 'Sam Ruby <depot@example.com>',       mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "credit card pay type form" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    first('.catalog li').click_on 'Add to Cart'

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector "#order_credit_card_number"
    assert_no_selector "#order_expiration_date"

    select 'Credit card', from: 'pay_type'

    assert_selector "#order_credit_card_number"
    assert_selector "#order_expiration_date"

    fill_in "CC #", with: "1234-2345-3456-4567"
    fill_in "Expiry", with: "06/24"

    perform_enqueued_jobs do
      click_button "Place Order"
    end

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal "Dave Thomas",      order.name
    assert_equal "123 Main Street",  order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Credit card",      order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"],                 mail.to
    assert_equal 'Sam Ruby <depot@example.com>',       mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "purchase order pay type form" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    first('.catalog li').click_on 'Add to Cart'

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector "#order_po_number"

    select 'Purchase order', from: 'pay_type'

    assert_selector "#order_po_number"

    fill_in "PO #", with: "123456"

    perform_enqueued_jobs do
      click_button "Place Order"
    end

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal "Dave Thomas",      order.name
    assert_equal "123 Main Street",  order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Purchase order",   order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"],                 mail.to
    assert_equal 'Sam Ruby <depot@example.com>',       mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "ship order" do
    Order.delete_all
    order = Order.new(
      name: "Dave Thomas",
      address: "123 Main Street",
      email: "dave@example.com",
      pay_type: "Purchase order"
    )
    order.save!

    ship_date = Date.today + 1

    visit edit_order_url(order.id)

    fill_in "order_ship_date", with: ship_date.strftime('%m/%d/%Y')

    perform_enqueued_jobs do
      click_button "Ship Order"
    end

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal ship_date, order.ship_date
  end
end
