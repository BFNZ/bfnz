class Api::BaseController < ActionController::API
  rescue_from ::Exception, :with => :rescue_exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::RoutingError, :with => :routing_error

  def undefined_route
    routing_error
  end

  def authenticate!
    auth_header = request.headers['Authorization'].to_s
    token = auth_header.split(' ').last
    return if token.eql?(ENV['API_KEY'])

    render json: { error: 'You are not authorized.' }, status: 401
  end

  protected

  def allow_access
    return true
  end

  def deny_access
    render :json => {
      :success  =>  false,
      :message  =>  "Access denied"
    }.to_json

    return false
  end

  def routing_error(exception = nil)
    # deliver_exception_notification(exception) if exception

    render :json => {
      :success => false,
      :message => "Invalid/Undefined API"
    }.to_json
  end

  def record_not_found(exception)
    # deliver_exception_notification(exception)

    render :json => {
      :success => false,
      :message => "Record not found"
    }.to_json
  end

  def rescue_exception(exception)
    # deliver_exception_notification(exception)

    render :json => {
      :success => false,
      :message => "Exception occured",
      :exception => exception.inspect
    }.to_json
  end
end
