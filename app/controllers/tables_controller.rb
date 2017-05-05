class TablesController < ApplicationController

  def show
    @disable_navbar = true
    if cookies["bfnz_table"]
      @table = Table.find(cookies["bfnz_table"])
    else
      redirect_to new_table_path
    end
    @order_form ||= CustomerAndOrderForm.new({})
  end

  def new
    @table = Table.new
  end

  def create
    @table = Table.new(table_params)
    if @table.save
      bake_cookie @table.id
      redirect_to show_table_path, notice: "Table \##{@table.id.to_s.rjust(4, '0')} created."
    else
      flash[:error] = @table.errors.full_messages.join("<br>")
      render 'new'
    end
  end

  def edit
    @table = Table.find(:id)
  end

  def update
    @table = Table.find(:id)
    if @table.save
      bake_cookie @table.id
      redirect_to table_path, notice: "Table \##{@table.code} updated."
    else
      flash[:error] = @table.errors.full_messages.join("<br>")
      render 'new'
    end
  end

  def exit_table
    cookies.delete("bfnz_table")
    redirect_to new_table_path
  end

  private

  def bake_cookie table_id
      cookies["bfnz_table"] = { value: table_id, expires: 12.hours.from_now }
  end

  def table_params
    params.require(:table).permit(:coordinator_first_name,
                                  :coordinator_last_name,
                                  :coordinator_phone,
                                  :coordinator_email,
                                  :location,
                                  :city)
  end
end