require './pieces/piece'
class Pawn < Piece

  COLORS = { white: 1, black: -1 }

  attr_accessor :first_move

  def initialize(color, position)
    super(color, position)
    self.name = :pawn
    self.first_move = true
  end

  def move!(dest, board, test)
    self.first_move = false if test == false
    super(dest, board, test)
  end

  def plausible_moves(board)

    x_pawn = self.position[0]
    y_pawn = self.position[1]

    moves = []

      moves << [x_pawn, y_pawn + COLORS[self.color]]

      if self.first_move
        moves << [x_pawn, y_pawn + (2 * COLORS[self.color])]
      end

      moves = moves + attacking_moves(board)

    moves
  end

  # special case for pawn attacking diagonally
  def attacking_moves(board)

    # current position
    x = self.position[0]
    y = self.position[1]

    # return the forward oblique positions
    [].tap do |moves|
      moves << [Piece.let_offset(x, -1), y + COLORS[self.color]]
      moves << [Piece.let_offset(x,  1), y + COLORS[self.color]]
    end
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    # current position
    x = self.position[0]
    y = self.position[1]

    # if the destination is straight forward
    if x == dest[0]
      # move not possible if any piece is one space in front
      return false unless board.board[[x, y + 1 * COLORS[self.color]]].piece.nil?
      # if the move is a double jump
      if (y - dest[1]).abs == 2
        # move not possible if any piece is two spaces in front
        return false unless board.board[[x, y + 2 * COLORS[self.color]]].piece.nil?
      end
    else # the movement is an attacking move
      # debugger unless board.board[dest].nil? and board.board[dest].piece.color
      # attack move not possible unless a piece is there
      return false if board.board[dest].piece.nil?
      # attack move not possible if the attacked piece is friendly
      return false if board.board[dest].piece.color == self.color
    end

    true
  end


end