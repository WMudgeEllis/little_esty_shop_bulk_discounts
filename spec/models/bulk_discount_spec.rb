require "rails_helper"

RSpec.describe BulkDiscount do
  describe "relationships" do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:discount)}
    it { should validate_presence_of(:threshold)}
    it { should validate_numericality_of(:discount).is_less_than_or_equal_to(100)}
    it { should validate_numericality_of(:discount).is_greater_than(0)}
    it { should validate_numericality_of(:threshold).is_greater_than(0)}
  end
end
