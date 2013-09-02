
require './pieces/piece'

class Rook < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :rook
  end

  def self.rook_lines(origin)
    [].tap do |moves|
      ('a'..'h').each do |x_var|
        moves << [x_var, origin[1]]
      end

      (1..8).each do |y_var|
        moves << [origin[0], y_var]
      end
    end
  end

  def self.check_lines(origin, dest, board)
    x_range = [origin[0], dest[0]].sort
    y_range = [origin[1], dest[1]].sort
    (x_range[0]..x_range[1]).to_a.each do |x|
      (y_range[0]..y_range[1]).to_a.each do |y|
        unless origin == [x, y] or dest == [x, y]
          return false unless board.board[[x, y]].piece.nil?
        end
      end
    end

    true
  end

  def plausible_moves(board)
    origin = self.position
    Rook.rook_lines(origin)
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    origin = self.position

    Rook.check_lines(origin, dest, board)
  end

end