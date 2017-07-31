class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  end

  def dashboard
    @organizations = current_user.organizations
    @inventories = current_user.inventories
  end
end
