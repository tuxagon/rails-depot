require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  test "add to cart" do
    visit store_index_url

    assert_no_selector ".line-item-highlight"

    first('.catalog li').click_on 'Add to Cart'

    assert_selector ".line-item-highlight"
  end

  test "empty cart" do
    visit store_index_url

    first('.catalog li').click_on 'Add to Cart'
    
    assert_selector ".line-item-highlight"

    page.accept_confirm { click_on 'Empty cart' }

    assert_no_selector ".line-item-highlight"
  end
end
