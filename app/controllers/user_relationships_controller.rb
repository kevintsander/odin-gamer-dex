class UserRelationshipsController < ApplicationController
  before_action :find_user, only: %i[create update destroy]
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

  def find_user
    @user = User.find(params[:user_id])
  end

  def load_relationship
    @user_relationship = @user.user_relationships.find_or_initialize_by(friend_id: params[:friend_id])
    @user_relationship.status = params[:status]
  end
end
