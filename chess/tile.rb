# encoding: UTF-8
require './pieces/pawn'
require './pieces/rook'
require './pieces/knight'
require './pieces/bishop'
require './pieces/queen'
require './pieces/king'

class Tile
  attr_accessor :piece, :position, :color

  def initialize(coord, color)
    self.position = coord
    self.color = color
  end

  def to_s
    return " " if self.piece.nil?
    return self.piece.to_s
  end
end