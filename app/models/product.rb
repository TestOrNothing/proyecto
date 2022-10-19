class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, comparison: { greater_than_or_equal_to: 0 }
  validates :category,
            inclusion: { in: %w[Bebestible Comestibles Souvenir],
                         message: '%<value>s is not a valid category' }
  validates :weight, presence: true, if: :is_comestible?
  validates :volume, absence: true, if: :is_comestible?
  validates :volume, presence: true, if: :is_bebestible?
  validates :weight, absence: true, if: :is_bebestible?
  validates :weight, absence: true, if: :is_souvenir?
  validates :volume, absence: true, if: :is_souvenir?

  def is_comestible?
    category == 'Comestibles'
  end

  def is_bebestible?
    category == 'Bebestible'
  end

  def is_souvenir?
    category == 'Souvenir'
  end
end
