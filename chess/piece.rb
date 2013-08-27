# encoding: UTF-8
class Piece
  @@piece_string = {
    [:black, :king] => '♔',
    [:black, :queen] => '♕',
    [:black, :rook] => '♖',
    [:black, :bishop] => '♗',
    [:black, :knight] => '♘',
    [:black, :pawn] => '♙',
    [:white, :king] => '♚',
    [:white, :queen] => '♛',
    [:white, :rook] => '♜',
    [:white, :bishop] => '♝',
    [:white, :knight] => '♞',
    [:white, :pawn] => '♟' }

  attr_accessor :position, :color, :name

  def initialize(color, position)
    self.position = position
    self.color = color
  end

  def destination_in_bounds?(coord)
    # anti-plural of axis is axi: you heard it here
    coord.none? { |axi| axi < 0 || axi > 7}
  end

  def move_possible?(board,move)
    return false if board.board[move].piece.color == self.color
    return false unless destination_in_bounds?(move)

    if board.in_check?(self.color)
      temp = board.board[move].piece


    end

    true
  end

  def to_s
    @@piece_string[[self.color, self.name]]
  end

end

class Pawn < Piece
  COLORS = { white: 1, black: -1 }
  def initialize(color, position)
    super(color, position)
    self.name = :pawn
  end


  def move(board,move)
    raise "Out of Bounds." if dest_in_bounds?(move)

    dead_piece = board.board[move].piece
    board.board[move].piece = self
    board.board[self.position].piece = nil
    self.position = move

    return dead_piece
  end

  def available_moves(board)
    moves = plausible_moves(board)
    moves.select { |move| move_possible?(board,move) }
  end

  def plausible_moves(board)
    moves = [[self.position[0],self.position[1] + COLORS[self.color]]]
    moves + attacking_moves(board)
  end

  # special case for pawn attacking diagonally
  def attacking_moves(board)
    []
  end

  def move_possible?(board,move)
    return false unless super(board, move)

    true
  end
end

class Rook < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :rook
  end
end

class Knight < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :knight
  end
end

class Bishop < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :bishop
  end
end

class Queen < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :queen
  end
end

class King < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :king
  end
end