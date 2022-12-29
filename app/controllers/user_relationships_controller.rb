class UserRelationshipsController < ApplicationController
  before_action :load_relationship, only: %i[create update destroy]

  def create
    if @user_relationship.save
      redirect_to user_path(params[:friend_id])
    else
      render user_path(params[:friend_id]), status: :unprocessable_entity
    end
  end

  def update
    if @user_relationship.save
      redirect_to user_path(params[:friend_id])
    else
      render user_path(params[:friend_id]), status: :unprocessable_entity
    end
  end

  def destroy
    if @user_relationship.destroy
      redirect_to user_path(params[:friend_id])
    else
      render user_path(params[:friend_id]), status: :unprocessable_entity
    end
  end

  private

  def load_relationship
    id_order = [params[:user_id].to_i, params[:friend_id].to_i].minmax
    @user_relationship = UserRelationship.find_or_initialize_by(user_id: id_order.first, friend_id: id_order.last)
    @user_relationship.status = params[:status]
  end
end
