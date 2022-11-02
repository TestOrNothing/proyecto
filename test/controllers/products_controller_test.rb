# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product1 = Product.create(name: 'Coca Cola', price: 10, category: 'Bebestible',
                               volume: 1)
    @product2 = Product.create(name: 'Papas', price: 5, category: 'Comestibles',
                               weight: 1)
    @product3 = Product.create(name: 'Camiseta', price: 20, category: 'Souvenir',
                               weight: 1)
    @product_to_create = Product.new(name: 'Sprite', price: 12, category: 'Bebestible',
                                     volume: 2)
  end

  test 'should get index' do
    get products_url
    assert_response :success
  end

  test 'should get new' do
    get new_product_url
    assert_response :success
  end

  test 'difference in should create product' do
    assert_difference('Product.count') do
      post products_url,
           params: { product: {
             category: @product_to_create.category,
             name: @product_to_create.name,
             price: @product_to_create.price,
             volume: @product_to_create.volume, weight: @product_to_create.weight
           } }
    end
  end

  test 'redirect in should create product' do
    post products_url,
         params: { product: {
           category: @product_to_create.category,
           name: @product_to_create.name,
           price: @product_to_create.price,
           volume: @product_to_create.volume, weight: @product_to_create.weight
         } }

    assert_redirected_to product_url(Product.last)
  end

  test 'should fail to create product no diference' do
    assert_no_difference('Product.count') do
      post products_url,
           params: { product: { category: 'Bebestible', name: 'Failed product', price: 0,
                                volume: 1, weight: 1 } }
    end
  end

  test 'should fail to create product redirect' do
    post products_url,
         params: { product: { category: 'Bebestible', name: 'Failed product', price: 0,
                              volume: 1, weight: 1 } }
    assert_response :unprocessable_entity
  end

  test 'should show product' do
    get product_url(@product1)
    assert_response :success
  end

  test 'should show filtered product' do
    get products_url, params: { category: 'Bebestible' }
    assert_response :success
  end

  test 'should get edit' do
    get edit_product_url(@product1)
    assert_response :success
  end

  test 'should update product' do
    patch product_url(@product1),
          params: { product: {
            category: @product1.category,
            name: @product1.name,
            price: @product1.price + 1,
            volume: @product1.volume,
            weight: @product1.weight
          } }
    assert_redirected_to product_url(@product1)
  end

  test 'should fail to update product' do
    patch product_url(@product1),
          params: { product: { category: @product1.category, name: @product1.name, price: 0,
                               volume: @product1.volume, weight: 1 } }
    assert_response :unprocessable_entity
  end

  test 'should destroy product difference' do
    assert_difference('Product.count', -1) do
      delete product_url(@product1)
    end
  end

  test 'should destroy product redirect' do
    delete product_url(@product1)
    assert_redirected_to products_url
  end
end
