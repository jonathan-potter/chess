class Knight < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :knight
  end

  def plausible_moves(board)

    origin = self.position
    [].tap do |moves|
      [-2, -1, 1, 2].each do |x_offset|
        [-2, -1, 1, 2].each do |y_offset|
          next if x_offset.abs == y_offset.abs
          dest_x = Piece.num_to_let(Piece.let_to_num(origin[0]) + x_offset)
          dest_y = origin[1] + y_offset
          moves << [dest_x, dest_y]
        end
      end
    end

  end

end