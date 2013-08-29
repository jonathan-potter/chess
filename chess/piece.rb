# encoding: UTF-8
class Piece
  PIECES = {
    [:black, :king] => '♔',
    [:black, :queen] => '♕',
    [:black, :rook] => '♖',
    [:black, :bishop] => '♗',
    [:black, :knight] => '♘',
    [:black, :pawn] => '♙',
    [:white, :king] => '♚',
    [:white, :queen] => '♛',
    [:white, :rook] => '♜',
    [:white, :bishop] => '♝',
    [:white, :knight] => '♞',
    [:white, :pawn] => '♟' }

  attr_accessor :position, :color, :name

  def initialize(color, position)
    self.position = position
    self.color = color
  end

  def move!(dest, board)
    raise "Out of Bounds." unless dest_in_bounds?(dest)

    dead_piece = board.board[dest].piece
    board.board[dest].piece = self
    board.board[self.position].piece = nil
    self.position = dest

    return dead_piece
  end

  def dest_in_bounds?(coord)
    coord.each do |axi|
      if axi.is_a? String
        return false unless axi.match(/[a-h]/)
      else
        return false unless axi.between?(1,8)
      end
    end

    true
  end

  def available_moves(board, timeframe)
    moves = plausible_moves(board)
    moves.select! { |move| move_possible?(move, timeframe, board) }
    moves
  end

  def move_possible?(dest, timeframe, board)

    # puts "\t#{self.position}"


    return false unless dest_in_bounds?(dest)
    debugger if board.is_a?(Hash)
    unless board.board[dest].piece.nil?
      return false if board.board[dest].piece.color == self.color
    end

    if timeframe == :currently
      return false if moved_into_check?(dest, board)
    end

    true
  end

  def moved_into_check?(dest, board)
    origin = self.position
    saved_piece = move!(dest, board)
    if board.in_check?(self.color, :next_move)
      debugger
      move!(origin, board)
      board.board[dest].piece = saved_piece
      return true
    else
      move!(origin, board)
      board.board[dest].piece = saved_piece
    end

    false
  end

  def to_s
    PIECES[[self.color, self.name]]
  end

  def self.let_to_num(let)
    let.ord - 'a'.ord + 1
  end

  def self.num_to_let(num)
    (num + 'a'.ord - 1).chr
  end

end

class Pawn < Piece
  COLORS = { white: 1, black: -1 }
  def initialize(color, position)
    super(color, position)
    self.name = :pawn
  end

  def plausible_moves(board)
    moves = [[self.position[0],self.position[1] + COLORS[self.color]]]
    moves + attacking_moves(board)
  end

  # special case for pawn attacking diagonally
  def attacking_moves(board)
    []
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)
    dest_piece = board.board[dest].piece
    unless dest_piece.nil?
      return false if self.position[0] == dest_piece.position[0]
    end

    true
  end
end

class Rook < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :rook
  end

  def self.rook_lines(origin)
    [].tap do |moves|
      ('a'..'h').each do |x_var|
        moves << [x_var, origin[1]]
      end

      (1..8).each do |y_var|
        moves << [origin[0], y_var]
      end
    end
  end

  def self.check_lines(origin, dest, board)
    (origin[0]..dest[0]).to_a.sort.each do |x|
      (origin[1]..dest[1]).to_a.sort.each do |y|
        unless origin == [x, y] or dest == [x, y]
          return false unless board.board[[x, y]].piece.nil?
        end
      end
    end

    true
  end

  def plausible_moves(board)
    origin = self.position
    Rook.rook_lines(origin)
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    origin = self.position

    Rook.check_lines(origin, dest, board)
  end

end

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

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)
    true
  end
end

class Bishop < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :bishop
  end

  def self.bishop_lines(origin)
    [].tap do |moves|
      (-7..7).each do |offset|
        dest_x = Piece.num_to_let( Piece.let_to_num(origin[0]) + offset )
        dest_y = origin[1] + offset
        moves << [dest_x, dest_y]

        dest_y = origin[1] - offset
        moves << [dest_x, dest_y]
      end
    end
  end

  def self.check_lines(origin, dest, board)
    (origin[0]..dest[0]).to_a.sort.each_with_index do |x, x_index|
      (origin[1]..dest[1]).to_a.sort.each_with_index do |y, y_index|
        if x_index == y_index
          unless origin == [x, y] or dest == [x, y]
            return false unless board.board[[x, y]].piece.nil?
          end
        end
      end
    end

    true
  end

  def plausible_moves(board)
    origin = self.position
    Bishop.bishop_lines(origin)
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    origin = self.position

    Bishop.check_lines(origin, dest, board)
  end
end

class Queen < Piece
  def initialize(color, position)
    super(color, position)
    self.name = :queen
  end

  def plausible_moves(board)
    origin = self.position
    Rook.rook_lines(origin) + Bishop.bishop_lines(origin)
  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)

    origin = self.position

    Rook.check_lines(origin, dest, board) and Bishop.check_lines(origin, dest, board)
  end

end

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
          dest_x = Piece.num_to_let(Piece.let_to_num(origin[0]) + x_offset)
          dest_y = origin[1] + y_offset
          moves << [dest_x, dest_y]
        end
      end
    end

  end

  def move_possible?(dest, timeframe, board)
    return false unless super(dest, timeframe, board)
    true
  end
end