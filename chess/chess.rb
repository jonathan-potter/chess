# encoding: UTF-8
require './board.rb'
require './player.rb'

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

    print '  '
    puts '-' * ((8*4) + 1)
    rows.each_with_index do |row,index|
      print "#{8 - index} | "
      print row.join(" | ")
      puts " |"
      print '  '
      puts '-' * ((8*4) + 1)
    end
    print '  '
    ('a'..'h').each { |x| print "  #{x} " }
    puts ""
  end

  def end_game?(color)
    board.checkmate?(color) or board.stalemate?(color)
  end

end


if __FILE__ == $PROGRAM_NAME
  Chess.new.play
end