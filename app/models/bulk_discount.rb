class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :discount, :threshold
  validates_numericality_of :discount, greater_than: 0, less_than_or_equal_to: 100
  validates_numericality_of :threshold, greater_than: 0
end
