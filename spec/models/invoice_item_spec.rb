require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end
  end

  describe "instance methods" do
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
      #invoice is completed
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
      #should have no eligible_discount
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 2, unit_price: 1, status: 2)
    end

    it 'eligible_discount' do
      expect(@ii_1.eligible_discount).to eq(@bulk_discount_3)
      expect(@ii_2.eligible_discount).to eq(@bulk_discount_2)
      expect(@ii_3.eligible_discount).to eq(nil)
    end

    it 'discounted_total' do
      expect(@ii_1.discounted_total).to eq(882)
      expect(@ii_2.discounted_total).to eq(2204)
      expect(@ii_3.discounted_total).to eq(2)
    end
  end
end
