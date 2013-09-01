class Bishop < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :bishop
  end

  def self.bishop_lines(origin)
    [].tap do |moves|
      (-7..7).each do |offset|
        dest_x = Piece.num_to_let( Piece.let_to_num(origin[0]) + offset )
        dest_y = origin[1] + offset
        moves << [dest_x, dest_y]

        dest_y = origin[1] - offset
        moves << [dest_x, dest_y]
      end
    end
  end

  def self.check_lines(origin, dest, board)
    return true if dest == origin
    dest_0 = Piece.let_to_num(dest[0])
    origin_0 = Piece.let_to_num(origin[0])

    x_sign = (dest_0 - origin_0) > 0 ? 1 : -1
    y_sign = (dest[1] - origin[1]) > 0 ? 1 : -1
    diff = (origin[1] - dest[1]).abs

    (diff + 1).times do |axis_offset|
      x = Piece.let_offset(origin[0], (axis_offset * x_sign))
      y = origin[1] + (axis_offset * y_sign)
      piece = board.board[[x, y]]
      unless origin == [x, y] or dest == [x, y]
        return false unless piece.nil?
      end
    end

    true
  end

  def plausible_moves(board)
    origin = self.position
    Bishop.bishop_lines(origin)
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    origin = self.position

    Bishop.check_lines(origin, dest, board)
  end
end