class Admin::CoordinatorsController < Admin::BaseController

  def index
    @territorial_authorities = TerritorialAuthority.order(:name)
    @unassigned_coordinators = User.unassigned_coordinators
  end

  def new
    @coordinator = User.new
  end

  def create
    coordinator_service = Admin::CreateCoordinatorService.new(params)
    if coordinator_service.save
      redirect_to admin_coordinators_path, notice: "Coordinator created successfully."
    else
      flash[:alert] = coordinator_service.error_message
      @coordinator = coordinator_service.coordinator
      render :new
    end
  end

  def edit
    @coordinator = User.coordinators.find(params[:id])
  end

  def update
    coordinator_service = Admin::UpdateCoordinatorService.new(params)
    if coordinator_service.save
      redirect_to admin_coordinators_path, notice: "Coordinator updated successfully."
    else
      @coordinator = coordinator_service.coordinator
      render :edit
    end
  end
end
