class GamesController < ApplicationController
  def index
    if params[:game]
      search = GiantBomb::Search.new
      search.limit(10)
      search.resources('game')
      search.query(params[:game])
      @games = search.fetch
    end
  end
end
