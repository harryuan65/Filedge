# frozen_string_literal: true

#
# Catches root exceptions
#
module ErrorBoundary
  extend ActiveSupport::Concern

  included do |origin_class|
    origin_class.class_eval do
      rescue_from StandardError, with: :server_error_handler
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_handler
      rescue_from ActionController::RoutingError, with: :not_found_handler
      rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
    end
  end

  private

  def not_found_handler(_exception)
    render "shared/not_found", status: :not_found
  end

  def record_invalid_handler(exception)
    handle error_message: exception.to_s, status: :bad_request
  end

  def server_error_handler(exception)
    error_details = "#{exception}\n#{exception.backtrace[0]}"
    logger.fatal error_details
    # Rollbar.error(exception)
    handle error_message: "#{exception}\n#{error_details}", status: :internal_server_error
  end

  def handle(error_message:, status:)
    logger.warn error_message
    @status = status
    @error_message = error_message
    redirect_to root_path, alert: "Error: #{error_message}", status: status
  end
end
