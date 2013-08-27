class Piece

  attr_accessor :position, :color, :name, :movability

  def initialize(position, color)
    self.position = position
    self.color = color
  end

  def destination_in_bounds?(destinations)
    dest.none? { |coor| coord < 0 || coor > 7}
  end

  def move_possible?(board,move)
    return false if board[move].piece.color == self.color
    return false if

    true
  end

end

class Pawn < Piece
  COLORS = { white: 1, black: -1 }
  def initialize(position, color)
    super(position, color)
    self.name = :pawn
  end


  def move(board,destination)
    raise "Out of Bounds." if dest_in_bounds?(destinations)
  end

  def available_moves(board)
    moves = plausible_moves(board)
    moves.select { |move| move_possible?(board,move) }
  end

  def plausible_moves(board)
    moves = [[self.position[0],self.position[1] + COLORS[self.color]]
    moves += attacking_moves(board)
  end



  # special case for pawn attacking diagonally
  def attacking_moves(board)
    []
  end

  def move_possible?(board,move)
    return false unless super(board, move)

  end
end

class Rook < Piece
end

class Knight < Piece
end

class Bishop < Piece
end

class Queen < Piece
end

class King < Piece
end