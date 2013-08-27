require './board'
require './players'

class Chess
  attr_accessor :board, :players, :dead_pieces

  def initialize
    self.board = Board.new
    self.players = [Player.new(:white), Player.new(:black)]
  end

  def play
    until end_game?
      player = self.players.pop
      player.turn
      self.players.shift(player)
    end
  end

end