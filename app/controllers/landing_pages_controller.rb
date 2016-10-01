class LandingPagesController < ApplicationController

  before_action :disable_breadcrumb

  def index
    render layout: 'landing'
  end

  private

  def disable_breadcrumb
    @disabled_breadcrumb = true
  end

end
