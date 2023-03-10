class ApplicationController < ActionController::Base
  include ErrorBoundary

  def not_found
    flash.clear
    render "shared/not_found", status: :not_found
  end
end
