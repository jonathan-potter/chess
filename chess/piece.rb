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

  def move!(dest, board)
    raise "Out of Bounds." unless dest_in_bounds?(dest)

    dead_piece = board.board[dest].piece
    board.board[dest].piece = self
    board.board[self.position].piece = nil
    self.position = dest

    return dead_piece
  end

  def dest_in_bounds?(coord)
    # anti-plural of axis is axi: you heard it here
    coord.each do |axi|
      if axi.is_a? String
        return false if axi < 'a' || axi > 'h'
      else
        return false if axi < 1 || axi > 8
      end
    end

    true
  end

  def available_moves(board)
    moves = plausible_moves(board)
    moves.select { |move| move_possible?(move, board) }
  end

  # ensures piece cannot move to a friendly square or out of bounds.
  # also enforces check.
  def move_possible?(dest, board)

    unless board.board[dest].piece.nil?
      return false if board.board[dest].piece.color == self.color
    end
    return false unless dest_in_bounds?(dest)

    if board.in_check?(self.color)
      temp = board.board[dest].piece
      ################################
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

  def plausible_moves(board)
    moves = [[self.position[0],self.position[1] + COLORS[self.color]]]
    moves + attacking_moves(board)
  end

  # special case for pawn attacking diagonally
  def attacking_moves(board)
    []
  end

  def move_possible?(dest, board)
    return false unless super(dest, board)

    true
  end
end

class Rook < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :rook
  end

  def plausible_moves(board)
    origin = self.position
    [].tap do |moves|
      (-7..7).each do |x_offset|
        moves << [origin[0] + x_offset, origin[1]]
      end

      (-7..7).each do |y_offset|
        moves << [origin[0], origin[1] + y_offset]
      end
    end

    moves
  end

  def move_possible?(dest, board)
    return false unless super(dest, board)
    origin = self.position
    (origin[0]..dest[0]).to_a.sort.each do |x|
      (origin[1]..dest[1]).to_a.sort.each do |y|
        unless origin == [x, y] or dest == [x, y]
          return false if board.board[[x, y]].piece.nil?
        end
      end
    end

    true
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