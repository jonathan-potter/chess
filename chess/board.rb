# encoding: UTF-8
require './tile.rb'

class Board
  attr_accessor :board

  def initialize
    self.board = build_board
    # populate_board!
  end

  def build_board
    {}.tap do |hash|
      ('a'..'h').each do |x|
        (1..8).each do |y|
          hash[[x, y]] = Tile.new([x, y])
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
      black_major << self.board[[x, 8]]
      black_pawns << self.board[[x, 7]]
      white_pawns << self.board[[x, 2]]
      white_major << self.board[[x, 1]]
    end

    place_major(:black, black_major)
    place_pawns(:black, black_pawns)
    place_pawns(:white, white_pawns)
    place_major(:white, white_major)
  end

  def place_major(color, tiles)
    pieces = [
      Rook.new(color, tiles[0].position),
      Knight.new(color, tiles[1].position),
      Bishop.new(color, tiles[2].position),
      Queen.new(color, tiles[3].position),
      King.new(color, tiles[4].position),
      Bishop.new(color, tiles[5].position),
      Knight.new(color, tiles[6].position),
      Rook.new(color, tiles[7].position)]

    8.times do |x|
      tiles[x].piece = pieces[x]
    end
  end

  def place_pawns(color, tiles)
    tiles.each do |tile|
      tile.piece = Pawn.new(color, tile.position)
    end
  end

  def in_check?(color)

  end

  def move_piece(piece,coord)


  end

end