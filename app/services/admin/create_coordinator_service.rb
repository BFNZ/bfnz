class Admin::CreateCoordinatorService
  def initialize(params)
    @params = params
  end

  def save
    generate_password
    coordinator.save.tap do |success|
      @error = coordinator.errors.full_messages.join(", ") unless success
    end
  end

  def error_message
    @error
  end

  def coordinator
    @coordinator ||= User.new(coordinator_params)
  end

  private

  def coordinator_params
    @params.require(:coordinator).
      permit(:name, :email, :territorial_authority_ids => [])
  end

  # this makes it easy to implement the ability for coordinators to log in,
  # in the future
  def generate_password
    random_password = SecureRandom.uuid
    coordinator.password = random_password
    coordinator.password_confirmation = random_password
  end
end
