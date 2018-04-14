require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @title = "The Great Book #{rand(1000)}"
  end

  test "should get index" do
    get products_url
    assert_response :success
    assert_select '.products tr .image', 3
    assert_select '.products .actions a', 'Show'
    assert_select '.products .actions a', 'Edit'
    assert_select '.products .actions a', 'Destroy'
    assert_select '.products a', 'New Product'
  end

  test "should get new" do
    get new_product_url
    assert_response :success
    assert_select 'input#product_title', 1
    assert_select 'textarea#product_description', 1
    assert_select 'input#product_price', 1
    assert_select 'input#product_image_url', 1
    assert_select 'a', 'Back'
    assert_select '.actions input' do
      assert_select '[value=?]', 'Create Product'
    end
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { 
        product: { 
          description: @product.description, 
          image_url: @product.image_url,
          price: @product.price,
          title: @title
        } 
      }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
    assert_select 'a', 'Back'
    assert_select 'a', 'Edit'
    assert_select 'p', /#{@product.title}/
    assert_select 'p', /#{@product.description}/
    assert_select 'p', /#{@product.price}/
    assert_select 'p', /#{@product.image_url}/
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
    assert_select 'input#product_title', 1
    assert_select 'input#product_title' do
      assert_select '[value=?]', @product.title
    end
    assert_select 'textarea#product_description', 1
    assert_select 'textarea#product_description', @product.description
    assert_select 'input#product_price', 1
    assert_select 'input#product_price' do
      assert_select '[value=?]', @product.price.to_s
    end
    assert_select 'input#product_image_url', 1
    assert_select 'input#product_image_url' do
      assert_select '[value=?]', @product.image_url
    end
    assert_select 'a', 'Back'
    assert_select 'a', 'Show'
    assert_select '.actions input' do
      assert_select '[value=?]', 'Update Product'
    end
  end

  test "should update product" do
    patch product_url(@product), params: { 
      product: { 
        description: @product.description,
        image_url: @product.image_url,
        price: @product.price,
        title: @title
      } 
    }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
