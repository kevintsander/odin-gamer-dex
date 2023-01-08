class UserRelationshipsController < ApplicationController
  before_action :load_relationship, only: %i[create update destroy]

  def create
    save_relationship
  end

  def update
    save_relationship
  end

  def destroy
    if @relationship.destroy
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
    if @relationship.save
      respond_to do |format|
        format.turbo_stream { render 'change' }
      end
    else
      render user_path(params[:friend_id]), status: :unprocessable_entity
    end
  end

  def load_relationship
    current_user_id = params[:user_id].to_i
    @user = User.find(params[:friend_id])
    id_order = [current_user_id, @user.id].minmax

    @relationship = UserRelationship.find_or_initialize_by(user_id: id_order.first, friend_id: id_order.last)
    @relationship.direction ||= UserRelationship.get_direction(current_user_id, @user.id) # only set direction on initial request
    @relationship
  end

  def change_relationship_status!
    case params[:type]
    when 'add'
      @relationship.status = 'pending'
    when 'accept'
      # only the requestee can accept when the status is pending
      if @relationship.status == 'pending' && @relationship.requestee?(params[:user_id])
        @relationship.status = 'friends'
      end
    end
  end
end
