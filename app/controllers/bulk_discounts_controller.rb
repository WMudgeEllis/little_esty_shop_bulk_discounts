class BulkDiscountsController < ApplicationController
  before_action :find_merchant_and_bulk_discount, only: [:show, :destroy, :edit, :update]
  before_action :find_merchant, only: [:index, :create, :new]

  def index
    @bulk_discounts = @merchant.bulk_discounts
    @holidays = HolidayService.new.next_three_holidays
  end

  def show
  end

  def edit
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = bulk_discount.errors.full_messages.to_sentence
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    @bulk_discount.delete
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash[:alert] = @bulk_discount.errors.full_messages.to_sentence
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount, :threshold)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant_and_bulk_discount
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end
