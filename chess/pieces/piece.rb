# encoding: UTF-8
class Piece
  PIECES = {
    [:black, :king] => '♚',
    [:black, :queen] => '♛',
    [:black, :rook] => '♜',
    [:black, :bishop] => '♝',
    [:black, :knight] => '♞',
    [:black, :pawn] => '♟',
    [:white, :king] => '♔',
    [:white, :queen] => '♕',
    [:white, :rook] => '♖',
    [:white, :bishop] => '♗',
    [:white, :knight] => '♘',
    [:white, :pawn] =>  '♙'}

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

    return false unless dest_in_bounds?(dest)
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