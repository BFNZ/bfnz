class Admin::CoordinatorPresenter
  def initialize(coordinator)
    @coordinator = coordinator
  end

  def message
    if coordinator
      "#{coordinator.name} is the coordinator for this district"
    else
      "Warning! No coordinator has been assigned for this district"
    end
  end

  private

  attr_reader :coordinator
end
