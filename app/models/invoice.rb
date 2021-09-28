class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def merch_total_revenue(merchant_id)
    invoice_items.joins(:item)
                 .select('invoice_items.*, items.merchant_id')
                 .where(items: {merchant_id: merchant_id})
                 .sum("invoice_items.unit_price * quantity")
  end

  def discounted_revenue
    invoice_items.sum {|ii| ii.discounted_total}
  end

  def merch_discounted_revenue(merchant_id)
    invoice_items.joins(:item)
                 .select('invoice_items.*, items.merchant_id')
                 .where(items: {merchant_id: merchant_id})
                 .sum {|ii| ii.discounted_total}
  end
end
