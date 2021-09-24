require "rails_helper"

RSpec.describe 'bulk discount show page' do

  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount_1 = BulkDiscount.create!(merchant_id: @merchant1.id, discount: 10, threshold: 30)

    visit merchant_bulk_discount_path(@bulk_discount)
  end

  it 'shows info' do
    expect(page).to have_content("Percent off: #{@bulk_discount_1.discount}")
    expect(page).to have_content("Quantity threshold: #{@bulk_discount_1.threshold}")
  end


end
# As a merchant
# When I visit my bulk discount show page
# Then I see the bulk discount's quantity threshold and percentage discount
