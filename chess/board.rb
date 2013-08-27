class Board
  attr_accessor :board

  def initialize
    self.board = build_board
    populate_board!
  end

  def build_board
    {}.tap do |hash|
      ('a'..'h').each do |x|
        (1..8).each do |y|
          hash[[x, y]] = Tile.new
        end
      end
    end
  end

  def populate_board!
    black_major = []
    black_pawns = []
    white_pawns = []
    white_major = []

    ('a'..'h').each do |x|
      black_major << hash[[x, 8]]
      black_pawns << hash[[x, 7]]
      white_pawns << hash[[x, 2]]
      white_major << hash[[x, 1]]
    end

    place_pieces(:black)
  end

  def in_check?(color)

  end

  def move_piece(piece,coord)

  end

end