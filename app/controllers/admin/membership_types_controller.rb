class Admin::MembershipTypesController < ApplicationController
  before_filter "set_current_tab('admin/membership_types')", :only => [ :index, :show ]

  load_resource

  def create
    @membership_type = MembershipType.new(params[:membership_type])

    respond_with(@membership_type) do |format|
      @membership_type.save
    end
  end
  def destroy
    @membership_type = MembershipType.find(params[:id])
    @membership_type.destroy
    respond_with(@membership_type)
  end
end
