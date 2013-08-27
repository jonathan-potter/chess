# encoding: UTF-8
class Player
  attr_accessor :color

  def initialize(color)
    self.color = color
  end


end

class HumanPlayer < Player
  def turn
    take_input

  end

  def take_input
    input = ""
    until is_valid_move?(input)
      input = gets.chomp
    end
  end

  def is_valid_move?

  end

end