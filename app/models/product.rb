# frozen_string_literal: true

# Model that represents a product
class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, comparison: { greater_than_or_equal_to: 0 }
  validates :category,
            inclusion: { in: %w[Bebestible Comestibles Souvenir],
                         message: '%<value>s is not a valid category' }
  validates :weight, presence: true, if: :comestible?
  validates :volume, absence: true, if: :comestible?
  validates :volume, presence: true, if: :bebestible?
  validates :weight, absence: true, if: :bebestible?
  validates :weight, absence: true, if: :souvenir?
  validates :volume, absence: true, if: :souvenir?

  def comestible?
    category == 'Comestibles'
  end

  def bebestible?
    category == 'Bebestible'
  end

  def souvenir?
    category == 'Souvenir'
  end
end
