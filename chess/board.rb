# encoding: UTF-8
require './tile.rb'

class Board
  attr_accessor :board, :dead_pieces

  def initialize
    self.board = build_board
    self.populate_board!
    self.dead_pieces = []
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
    king = find_king(color)
    opp_pieces = all_pieces(other_color(color))

    opp_pieces.each do |piece|
      moves = piece.available_moves(self)
      return true if moves.include?(king.position)
    end

    false
  end

  def checkmate?(color)
    return false unless in_check?(color)

    our_pieces = all_pieces(color)
    our_pieces.each do |piece|
      moves = piece.available_moves(self)
      return false if moves.any?
    end

    true
  end

  def stalemate?(color)
    return false if in_check?(color)

    our_pieces = all_pieces(color)
    our_pieces.each do |piece|
      moves = piece.available_moves(self)
   debugger if moves.nil?
      return false if moves.any?
    end

    true
  end

  def find_king(color)
    ('a'..'h').each do |x|
      (1..8).each do |y|
        piece = self.board[[x, y]].piece
        next if piece.nil?
        # debugger if piece.name == :king
        return piece if (piece.color == color and piece.name == :king)
      end
    end
    raise "King not found for #{color}"
  end

  def all_pieces(color)
    [].tap do |pieces|
      ('a'..'h').each do |x|
        (1..8).each do |y|
          piece = self.board[[x, y]].piece
          next if piece.nil?
          pieces << piece if piece.color == color
        end
      end
    end
  end

  def other_color(color)
    raise "Invalid Color" unless [:white, :black].include?(color)
    color == :white ? :black : :white
  end


end