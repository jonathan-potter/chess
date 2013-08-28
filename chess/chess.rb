# encoding: UTF-8
require './board.rb'
require './player.rb'
require 'debugger'

class Chess
  attr_accessor :board, :players

  def initialize
    self.board = Board.new
    self.players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
  end

  def play
    play_index = 0
    until end_game?(players[0])
      display
      players[play_index].turn(self.board)
      play_index = (play_index + 1) % 2
    end

    # if winner = board.checkmate?
#       puts "Congratulations #{winner.to_s.capitalize}!"
#     else
#       puts "Stalemate!"
#     end

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

    puts '-' * ((8*4) + 1)
    rows.each do |row|
      print "| "
      print row.join(" | ")
      puts " |"
      puts '-' * ((8*4) + 1)
    end

  end

  def end_game?
    board.checkmate? or board.stalemate?
  end

end


if __FILE__ == $PROGRAM_NAME
  Chess.new.play
end