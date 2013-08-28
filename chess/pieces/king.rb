class King < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :king
  end

  def plausible_moves(board)

    origin = self.position
    [].tap do |moves|
      [-1, 0, 1].each do |x_offset|
        [-1, 0, 1].each do |y_offset|
          next if x_offset == 0 and y_offset == 0
          dest_x = Piece.let_offset(origin[0], x_offset)
          dest_y = origin[1] + y_offset
          moves << [dest_x, dest_y]
        end
      end
    end
  end

end