class Api::V1::HomeController < Api::BaseController
  before_action :authenticate!

  def available_items
    @items = Item.active
  end
end
