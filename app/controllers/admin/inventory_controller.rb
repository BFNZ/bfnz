class Admin::InventoryController < Admin::BaseController
  def index
    @inventories = Inventory.all
  end
end
