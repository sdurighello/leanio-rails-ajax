class LandingPagesController < ApplicationController

  before_filter :disable_breadcrumb

  def index

  end

  private

  def disable_breadcrumb
    @disabled_breadcrumb = true
  end

end
