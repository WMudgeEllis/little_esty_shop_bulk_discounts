require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe "instance methods" do
    it "merch_total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Yadas')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: 'Ya', description: 'is overpriced', unit_price: 200, merchant_id: @merchant2.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 1, unit_price: 300, status: 1)

      expect(@invoice_1.merch_total_revenue(@merchant1.id)).to eq(100)
    end

    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Yadas')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: 'Ya', description: 'is overpriced', unit_price: 200, merchant_id: @merchant2.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 1, unit_price: 300, status: 1)

      expect(@invoice_1.total_revenue).to eq(400)
    end

    describe 'discounts' do
      before :each do
        @merchant1 = Merchant.create!(name: 'Hair Care')

        @bulk_discount_1 = BulkDiscount.create!(merchant_id: @merchant1.id, discount: 10, threshold: 30)
        @bulk_discount_2 = BulkDiscount.create!(merchant_id: @merchant1.id, discount: 5, threshold: 10)
        @bulk_discount_3 = BulkDiscount.create!(merchant_id: @merchant1.id, discount: 2, threshold: 5)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
        @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
        @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
        @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
        @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
        @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
        @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
        #bulk discount 2 should be applied to item 2 and not item 1, bulk discount 1 should not apply to any
        #bulk dicount 3 should apply to item 1, and be overwritten by bd2 on item 2
        #total for ii_1 is 882
        #total for ii_2 is 2204
        #discounted grand total: 3086
        #undiscounted grand total: 3220
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 100, status: 0)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 29, unit_price: 80, status: 0)
        #Transaction is successful
        @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)

        #the rest is just for noise/making sure that queries are being correct
        @merchant2 = Merchant.create!(name: 'Jewelry')

        @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
        @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

        @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
        @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
        @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
        # ii_3 is the one that makes merch_discounted_revenue != discounted_revenue
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_6.id, quantity: 2, unit_price: 8, status: 2)
        @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)

        @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
        @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
        @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      end

      it 'merch_discounted_revenue' do
        expect(@invoice_1.merch_discounted_revenue(@merchant1.id)).to eq(3086)
      end

      it 'discounted_revenue' do
        expect(@invoice_1.discounted_revenue).to eq(3102)
      end
    end
  end
end
