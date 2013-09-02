# encoding: UTF-8

require 'colorize'
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
    until end_game?(players[play_index].color)
      display
      players[play_index].turn(self.board)
      play_index = (play_index + 1) % 2
    end

    self.display
    if board.stalemate?(players[play_index - 1].color)
      puts "Stalemate!"
    else
      winner = players[play_index]
      puts "Congratulations #{board.other_color(winner.color).to_s.capitalize}!"
    end

  end

  def display
    rows = []
    (1..8).to_a.reverse.each do |y|
      row = []
      ('a'..'h').each do |x|
        row << board.board[[x,y]]
      end
      rows << row
    end

    rows.each_with_index do |row,index|
      print " #{8 - index} "
      row.each do |tile|
        if tile.piece.nil?
          print "   ".colorize(:background => tile.color)
        else
          print " #{tile} ".colorize(:background => tile.color, :color => tile.piece.color)
        end
      end
      puts ""
    end
    print '   '
    ('a'..'h').each { |x| print " #{x} " }
    puts ""
  end

  def end_game?(color)
    board.checkmate?(color) or board.stalemate?(color)
  end

end


if __FILE__ == $PROGRAM_NAME
  Chess.new.play
end