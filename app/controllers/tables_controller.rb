class TablesController < ApplicationController

  def show
    redirect_to new_table_path unless cookies["bfnz_table"]
  end

  def new
    @table = Table.new
  end

  def create
    @table = Table.new(table_params)
    if @table.save
      cookies["bfnz_table"] = { value: "#{@table.id}", expires: 12.hours.from_now }
      render action: "show", notice: "Table \##{@table.id.to_s.rjust(4, '0')} created."
    else
      flash[:error] = @table.errors.full_messages.join(", ")
      render 'new'
    end
  end

  def edit
    @table = Table.find(:id)
  end

  def update
    @table = Table.find(:id)
    if @table.save
      cookies["bfnz_table"] = { value: "#{@table.id}", expires: 12.hours.from_now }
      redirect_to table_path, notice: "Table \##{@table.id.to_s.rjust(4, '0')} updated."
    else
      flash[:error] = @table.errors.full_messages.join(", ")
      render 'new'
    end
  end

  def exit_table
    cookies.delete("bfnz_table")
    redirect_to new_table_path
  end

  private

  def table_params
    params.require(:table).permit(:coordinator_first_name,
                                  :coordinator_last_name,
                                  :coordinator_phone,
                                  :coordinator_email,
                                  :location)
  end
end