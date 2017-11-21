class InventoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_owner, only: [:new, :create, :show]
  before_action :validate_organization_owner, only: [:new, :create]
  before_action :load_inventory, only: [:show]

  def new
    authorize Inventory
    @inventory = Inventory.new
  end

  def create
    authorize Inventory
    @inventory = Inventory.new(inventory_params.merge(owner: @owner))
    if @inventory.save
      inventory_user = InventoryUser.new(user: current_user, inventory: @inventory, user_role: 'admin', confirmed_at: Time.now)
      inventory_user.save
      flash[:success] = 'Your inventory has been successfully created'
      redirect_to [@owner, @inventory]
    else
      render 'new'
    end
  end

  def show
    authorize @inventory
  end

  private

  def load_inventory
    @inventory = current_user.inventories.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:name, :description)
  end

  def set_owner
    resource, id = request.path.split('/')[1, 2]
    @owner = resource.singularize.classify.constantize.find(id)
  end

  def validate_organization_owner
    return unless @owner.class == Organization && @owner.owner != current_user
    flash[:alert] = 'Only the owner of an organization can create an inventory for it'
    redirect_to organization_path(@owner)
  end
end
