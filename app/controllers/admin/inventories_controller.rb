class Admin::InventoriesController < Admin::BaseController
  before_action :set_inventory, only: %i[show edit update destroy]

  def stock_take
    stock_take_params.each do |book_id, data|
      Inventory.create!(
        entry_type: 'Stock Take',
        date: data[:date],
        book_id: book_id,
        quantity: data[:quantity],
        person_name: data[:person_name]
      )
    end

    redirect_to admin_inventories_path, notice: 'Stock Take submitted successfully.'
  end

  def index
    @inventory_entries = Inventory.all
    @books = Book.all
  end

  def show
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)

    if @inventory.save
      redirect_to admin_inventories_path, notice: 'Inventory entry was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to admin_inventories_path, notice: 'Inventory entry was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to admin_inventories_path, notice: 'Inventory entry was successfully destroyed.'
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:entry_type, :date, :book_id, :quantity, :unit_cost, :person_name)
  end

  def stock_take_params
    params.require(:stock_take).permit!
  end
end
