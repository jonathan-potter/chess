# encoding: UTF-8
require './piece'

class Tile
  attr_accessor :piece, :position

  def initialize(coord)
    self.position = coord
  end

  def to_s
    return " " if self.piece.nil?
    return self.piece.to_s
  end
end