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
    until false #end_game?(players[play_index].color)
      display
      players[play_index].turn(self.board)
      play_index = (play_index + 1) % 2
    end

    if board.stalemate?(players[play_index - 1].color)
      puts "Stalemate!"
    else
      winner = players[play_index]
      puts "Congratulations #{winner.to_s.capitalize}!"
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

    print '   '
    puts '-' * 31
    rows.each_with_index do |row, i|
      print "#{8 - i} | "
      print row.join(" | ")
      puts " |"
      print '   '
      puts '-' * 31
    end

    print '  '
    ('a'..'h').each do |let|
      print "  #{let} "
    end
    puts ''
    puts ''

  end

  def end_game?(player)
    board.checkmate?(player) or board.stalemate?(player)
  end

end


if __FILE__ == $PROGRAM_NAME
  Chess.new.play
end