class Rate < ApplicationRecord
  belongs_to :post, counter_cache: true
  validates :value, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5 }
  after_create :after_create

  private
  def after_create
    sum_rating = post.sum_rating + value
    post.update(sum_rating: sum_rating, average_rating: sum_rating / post.rates_count.to_f)
  end

end