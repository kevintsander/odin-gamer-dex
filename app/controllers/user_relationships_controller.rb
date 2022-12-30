class UserRelationshipsController < ApplicationController
  before_action :load_relationship, only: %i[create update destroy]

  def create
    save_relationship
  end

  def update
    save_relationship
  end

  def destroy
    if @user_relationship.destroy
      respond_to do |format|
        format.turbo_stream { render 'change' }
      end
    else
      render user_path(params[:friend_id]), status: :unprocessable_entity
    end
  end

  private

  def save_relationship
    change_relationship_status!
    if @user_relationship.save
      respond_to do |format|
        format.turbo_stream { render 'change' }
      end
    else
      render user_path(params[:friend_id]), status: :unprocessable_entity
    end
  end

  def load_relationship
    user_id = params[:user_id].to_i
    @friend_id = params[:friend_id].to_i
    id_order = [user_id, @friend_id].minmax

    @user_relationship = UserRelationship.find_or_initialize_by(user_id: id_order.first, friend_id: id_order.last)
    @user_relationship.direction ||= UserRelationship.get_direction(user_id, @friend_id) # only set direction on initial request
    @user_relationship
  end

  def change_relationship_status!
    case params[:type]
    when 'add'
      @user_relationship.status = 'pending'
    when 'accept'
      # only the requestee can accept when the status is pending
      if @user_relationship.status == 'pending' && @user_relationship.requestee?(params[:user_id])
        @user_relationship.status = 'friends'
      end
    end
  end
end
