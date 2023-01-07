class GamesController < ApplicationController
  before_action :set_user
  before_action :set_search, only: [:index]

  def index
    @search_game = Game.new
    @found_games = GiantBombGameService.find_games(params[:search]) if @search
    @found_games ||= []
  end

  # POST users/:user_id/games
  def create
    @game = Game.find_or_initialize_by(giant_bomb_id: game_params[:game_id], name: game_params[:name])
    @user.games_user.build(game: @game)

    respond_to do |f|
      if @user.save
        f.turbo_stream
      else
        f.html { redirect_to user_path(@user), status: :unprocessable_entity }
      end
    end
  end

  # DELETE users/:user_id/games/:id
  def destroy
    respond_to do |f|
      if (@game = @user.games.destroy(params[:id]).first)
        f.turbo_stream
      else
        f.html { render user_path(@user), :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.includes(:games).find(params[:user_id])
  end

  def set_search
    @search = params[:search]
  end

  def game_params
    params.require(:game).permit(:game_id, :name)
  end
end
