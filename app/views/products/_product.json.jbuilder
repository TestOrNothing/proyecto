# frozen_string_literal: true

json.extract! product, :id, :name, :price, :category, :weight, :volume, :created_at, :updated_at
json.url product_url(product, format: :json)
