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
    # moves.delete(self.position)

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
    saved_piece = move!(dest, board)
    king = board.find_king(self.color)
    k_pos = king.position
    color = self.color

    pieces = [Pawn.new(color,k_pos),
              Bishop.new(color,k_pos),
              Knight.new(color,k_pos),
              Rook.new(color,k_pos),
              king]

    no_check_proc = Proc.new { |move| ignore_check_move_possible?(move, board) }

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