require "rails_helper"

RSpec.describe 'bulk discount edit page' do

  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount_1 = BulkDiscount.create!(merchant_id: @merchant1.id, discount: 10, threshold: 30)

    visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1)
  end

  it 'can edit a bulk discount' do
    fill_in :bulk_discount_discount, with: 1
    fill_in :bulk_discount_threshold, with: 7
    click_button :save

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
    expect(page).to have_content(1)
    expect(page).to have_content(7)
  end
  #add test for flashes for invalid numbers?

  it 'can flash for invalid discount' do
    fill_in :bulk_discount_discount, with: 105
    fill_in :bulk_discount_threshold, with: 4
    click_button :save

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
    expect(page).to have_content('Discount must be less than or equal to 100')
  end

  it 'can flash for invalid threshold' do
    fill_in :bulk_discount_discount, with: 105
    fill_in :bulk_discount_threshold, with: 4
    click_button :save

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_1))
    expect(page).to have_content('Threshold must be greater than 0')
  end
end
