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
# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
