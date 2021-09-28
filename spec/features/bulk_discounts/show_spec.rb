require "rails_helper"

RSpec.describe 'bulk discount show page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount_1 = BulkDiscount.create!(merchant_id: @merchant1.id, discount: 10, threshold: 30)

    visit merchant_bulk_discount_path(@merchant1, @bulk_discount_1)
  end

  it 'shows info' do
    expect(page).to have_content("Percent off: #{@bulk_discount_1.discount}")
    expect(page).to have_content("Quantity threshold: #{@bulk_discount_1.threshold}")
  end

  it 'links to edit page' do
    click_link 'edit'

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
  end
end
