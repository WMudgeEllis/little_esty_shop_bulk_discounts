class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def eligible_discount
    BulkDiscount.joins(merchant: :items)
                .where(merchant_id: item.merchant_id)
                .where('threshold <= ?', quantity)
                .order(discount: :desc)
                .first
  end

  def discounted_total
    discount = 1
    discount = (100 - eligible_discount.discount)/100.to_f if eligible_discount != nil
    quantity * unit_price * discount
  end
end
