
require './pieces/piece'

class Queen < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :queen
  end

  def plausible_moves(board)
    origin = self.position
    Rook.rook_lines(origin) + Bishop.bishop_lines(origin)
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    origin = self.position

    if origin[0] == dest[0] or origin[1] == dest[1]
      return false unless Rook.check_lines(origin, dest, board)
    else
      return false unless Bishop.check_lines(origin, dest, board)
    end
    
    true
  end

end