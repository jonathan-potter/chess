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

  def display
    rows = []
    (1..8).to_a.reverse.each do |y|
      row = []
      ('a'..'h').each do |x|
        row << board.board[[x,y]].to_s
      end
      rows << row
    end

    puts '-' * (8*3)
    rows.each do |row|
      print "| "
      print row.join(" | ")
      puts " |"
      puts '-' * (8*3)
    end

  end

  def end_game?
    false
  end

end