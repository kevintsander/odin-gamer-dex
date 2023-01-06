# frozen_string_literal: true

# Service for retrieving game information from GiantBomb.com
module GiantBombGameService
  class << self
    def find_games(search, limit = 10, offset = 0)
      game_search = GiantBomb::Search.new
      game_search.limit(limit)
      game_search.offset(offset)
      game_search.resources('game')
      game_search.query(search)
      @results = # create Game object for easier access to variables
        game_search.fetch.map do |fetched|
          GiantBomb::Game.new(fetched)
        end
    end

    def game_info(uid)
      GiantBomb::Game.detail(uid)
    end
  end
end
