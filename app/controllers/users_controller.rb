class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @relationship = current_user.find_relationship(@user.id)
    if params[:user_search]
      @user_search = params[:user_search]
      @found_users = User.where('username LIKE ?',
                                '%' + User.sanitize_sql_like(params[:user_search]) + '%')
    end
  end

  def current_user_home
    redirect_to current_user
  end
end
