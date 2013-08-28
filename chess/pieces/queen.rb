class Queen < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :queen
  end

  def plausible_moves(board)
    origin = self.position
    Rook.rook_lines(origin) + Bishop.bishop_lines(origin)
  end

  def move_possible?(dest, board, ignore = false)
    # return false unless super(dest, board)

    return false unless dest_in_bounds?(dest)
    unless board.board[dest].piece.nil?
      return false if board.board[dest].piece.color == self.color
    end

    origin = self.position

    if origin[0] == dest[0] or origin[1] == dest[1]
      return false unless Rook.check_lines(origin, dest, board)
    else
      return false unless Bishop.check_lines(origin, dest, board)
    end

    unless ignore
      return false if moved_into_check?(dest, board)
    end

    true
  end

end