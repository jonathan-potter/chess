class Pawn < Piece

  COLORS = { white: 1, black: -1 }

  attr_accessor :has_moved

  def initialize(color, position)
    super(color, position)
    self.name = :pawn
    self.has_moved = false
  end

  def move!(dest, board)
    self.has_moved = true
    super(dest, board)
  end

  def plausible_moves(board)

    x_pawn = self.position[0]
    y_pawn = self.position[1]
    moves = []

    moves << [x_pawn, y_pawn + COLORS[self.color]]

    unless self.has_moved
      moves << [x_pawn, y_pawn + (2 * COLORS[self.color])]
    end

    attacking_moves(board).each { |move| moves << move }

    # p self.object_id
    # p self.position
    # p self.color
    # p moves

    moves
  end

  # special case for pawn attacking diagonally
  def attacking_moves(board)
    x_pawn = self.position[0]
    y_pawn = self.position[1]
    moves = []

    [-1, 1].each do |x_offset|
      dest = [Piece.let_offset(x_pawn, x_offset), y_pawn + COLORS[self.color]]

      # set piece to nil so that we don't try to run methods on nil
      piece = dest_in_bounds?(dest) ? board.board[dest].piece : nil

      unless piece.nil?
        moves << dest if piece.color != self.color
      end
    end

    moves
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    # move not possible if destination off board
    return false unless dest_in_bounds?(dest)

    # if there is a piece where we are moving to
    unless board.board[dest].piece.nil?
      # move not possible if the attacked piece is the same color
      return false if board.board[dest].piece.color == self.color
    end

    # double jump not possible if there is a piece in the way
    y1 = self.position[1]
    y2 = dest[1]
    y_range = [y1,y2].sort

    if dest[0] == self.position[0]
      (y_range[0]..y_range[1]).each do |y|
        next if y == self.position[1]
        piece = board.board[[dest[0],y]].piece
        return false unless piece.nil?
      end
    end

    true
  end


end