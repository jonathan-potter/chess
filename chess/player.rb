# encoding: UTF-8
class Player
  attr_accessor :color

  def initialize(color)
    self.color = color
  end


end

class HumanPlayer < Player
  def turn(board)
    input = take_input(board)
    move!(input,board)
  end

  def take_input(board)
    color_s = self.color.to_s.capitalize
    input = nil
    until input
      print "#{color_s}'s Turn (b1, c3): "
      input = get_valid_move(board)
    end

    input
  end

  def get_valid_move(board)
    input = gets.chomp

    return nil unless input =~ /^[a-h][1-8]\,?\s[a-h][1-8]$/

    if input.include?(',')
      input = input.split(', ')
    else
      input = input.split(' ')
    end
    origin = [input[0][0], input[0][1].to_i]
    dest = [input[1][0], input[1][1].to_i]
    [origin, dest]

    piece = board.board[origin].piece
    return nil if piece.nil?
    return nil if piece.color != self.color
    available_moves = piece.available_moves(board, :currently)

    return [origin, dest] if available_moves.include?(dest)

    nil
  end

  def move!(input,board)
    origin = input[0]
    dest = input[1]
    dead_piece = board.board[origin].piece.move!(dest, board, false)
    board.dead_pieces << dead_piece
  end

end