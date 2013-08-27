require './piece'

class Tile
  attr_accessor :piece, :position

  def initialize(coord)
    self.position = coord
  end
end