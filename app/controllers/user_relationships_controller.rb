class UserRelationshipsController < ApplicationController
  before_action :load_relationship, only: %i[create update destroy]

  def create
    change_relationship_status!
    if @user_relationship.save
      redirect_to user_path(params[:friend_id])
    else
      render user_path(params[:friend_id]), status: :unprocessable_entity
    end
  end

  def update
    change_relationship_status!
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
    user_id = params[:user_id].to_i
    other_id = params[:friend_id].to_i
    id_order = [user_id, other_id].minmax

    @user_relationship = UserRelationship.find_or_initialize_by(user_id: id_order.first, friend_id: id_order.last)
    @user_relationship.direction ||= UserRelationship.get_direction(user_id, other_id) # only set direction on initial request
    @user_relationship
  end

  def change_relationship_status!
    case params[:type]
    when 'add'
      @user_relationship.status = 'pending'
    when 'accept'
      # only the requestee can accept when the status is pending
      puts '*' * 1000
      puts @user_relationship.status
      puts @user_relationship.requestee?(params[:user_id])
      if @user_relationship.status == 'pending' && @user_relationship.requestee?(params[:user_id])
        @user_relationship.status = 'friends'
      end
    end
  end
end
