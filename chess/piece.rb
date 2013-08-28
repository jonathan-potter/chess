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

  def available_moves(board, &blk)
    blk ||= Proc.new { |move| move_possible?(move, board) }

    moves = plausible_moves(board)

    moves.select!(&blk)
    moves
  end

  def move_possible?(dest, board)

    return false unless dest_in_bounds?(dest)
    unless board.board[dest].piece.nil?
      return false if board.board[dest].piece.color == self.color
    end

    return false if moved_into_check?(dest, board)

    true
  end

  def ignore_check_move_possible?(dest, board)

    return false unless dest_in_bounds?(dest)
    unless board.board[dest].piece.nil?
      return false if board.board[dest].piece.color == self.color
    end

    true
  end

  def moved_into_check?(dest, board)
    origin = self.position
    king = board.find_king(self.color)
    k_pos = king.position
    color = self.color

    pieces = [Pawn.new(color,k_pos),
              Bishop.new(color,k_pos),
              Knight.new(color,k_pos),
              Rook.new(color,k_pos),
              king]

    no_check_proc = Proc.new { |move| ignore_check_move_possible?(move, board) }

    saved_piece = move!(dest, board)
    pieces.each do |piece|
      moves = piece.available_moves(board, &no_check_proc)
      moves.each do |move|
        enemy = board.board[move].piece
        next if enemy.nil?
        if (enemy.name == piece.name or enemy.name == :queen)
          move!(origin, board)
          board.board[dest].piece = saved_piece
          return true
        end
      end
    end

    move!(origin, board)
    board.board[dest].piece = saved_piece

    false
  end

  def to_s
    PIECES[[self.color, self.name]]
  end

  def self.let_offset(let, offset)
    num = self.let_to_num(let)
    self.num_to_let(num + offset)
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

  attr_accessor :has_moved

  def initialize(color, position)
    super(color, position)
    self.name = :pawn
    self.has_moved = false
  end

  def move!(dest, board)
    self.has_moved = true
    super(dest, board)
  end

  def plausible_moves(board)

    x_pawn = self.position[0]
    y_pawn = self.position[1]
    moves = []

    moves << [x_pawn, y_pawn + COLORS[self.color]]

    unless self.has_moved
      moves << [x_pawn, y_pawn + (2 * COLORS[self.color])]
    end

    attacking_moves(board).each { |move| moves << move }

    moves
  end

  # special case for pawn attacking diagonally
  def attacking_moves(board)
    x_pawn = self.position[0]
    y_pawn = self.position[1]
    moves = []

    [-1, 1].each do |x_offset|
      dest = [Piece.let_offset(x_pawn, x_offset), y_pawn + COLORS[self.color]]

      piece = dest_in_bounds?(dest) ? board.board[dest].piece : nil

      unless piece.nil?
        moves << dest if piece.color != self.color
      end
    end

    moves
  end

  def move_possible?(dest, board)
    return false unless super(dest, board)

    dest_piece = dest_in_bounds?(dest) ? board.board[dest].piece : nil

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

  def move_possible?(dest, board)
    return false unless super(dest, board)

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

  def move_possible?(dest, board)
    return false unless super(dest, board)
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

  def move_possible?(dest, board)
    return false unless super(dest, board)

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

  def move_possible?(dest, board)
    return false unless super(dest, board)

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

  def move_possible?(dest, board)
    return false unless super(dest, board)
    true
  end
end