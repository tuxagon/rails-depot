class StoreController < ApplicationController
  skip_before_action :authorize
  include VisitCounter
  include CurrentCart
  before_action :set_counter, only: [:index]
  before_action :set_cart

  def index
    @products = Product.order(:title)
  end
end
