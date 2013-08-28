class Queen < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :queen
  end

  def plausible_moves(board)
    origin = self.position
    Rook.rook_lines(origin) + Bishop.bishop_lines(origin)
  end

  def move_possible?(dest, board)
    return false unless super(dest, board)

    origin = self.position

    if origin[0] == dest[0] or origin[1] == dest[1]
      Rook.check_lines(origin, dest, board)
    else
      Bishop.check_lines(origin, dest, board)
    end
  end

end