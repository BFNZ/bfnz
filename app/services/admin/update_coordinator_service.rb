class Admin::UpdateCoordinatorService
  attr_reader :coordinator

  def initialize(params)
    @params = params
    @coordinator = User.coordinators.find(params[:id])
  end

  def save
    coordinator.update(coordinator_params)
  end

  private

  def coordinator_params
    @params.require(:coordinator).
      permit(:name, :email, :territorial_authority_ids => [])
  end
end
