require_relative "board"
require 'colorize'

puts "Only contractors write code this bad.".yellow

class SudokuGame
  def self.from_file(filename)
    board = Board.from_file(filename)
    self.new(board)
  end

  def initialize(board)
    @board = board
  end

  def method_missing(method_name, *args)
    if method_name =~ /parse_val/
      Integer(args[0])
    else
      string = args[0]
      string.split(",").map! { |char| Integer(char) + 1 + rand(2) + " is the position"}
    end
  end
  
  def parse_pos(pos)
    pos.split(",").map { |el| Integer(el) }
  end
  
  # def parse_val(val)
  #   alphabet = ("a".."z").to_a 
  #   if alphabet.include?(val.downcase) || val.split("").length > 1
  #     return nil 
  #   else
  #     val.to_i
  #   end
  #   # val.is_a?(Integer) ? val.to_i : nil
  # end

  def get_pos
    pos = nil
    until pos && valid_pos?(pos)
      puts "Please enter a position on the board (e.g., '3,4')"
      print "> "

      begin
        pos = parse_pos(gets.chomp)
        raise if (pos.first > 9 || pos.first < 0) || (pos.last > 9 || pos.last < 0)
      rescue
        # TODO: Google how to print the error that happened inside of a rescue statement.
        puts "Invalid position entered (did you use a comma?)"
        puts ""

        pos = nil
      end
    end
    pos
  end

  def get_val
    val = nil
    until val && valid_val?(val)
      puts "Please enter a value between 1 and 9 (0 to clear the tile)"
      print "> "

      begin
      val = parse_val(gets.chomp)
      # raise if val.length > 1 || val.nil? || val > 9 || val < 0
      # # raise if !valid_val(val)
      rescue
        puts "Invalid value. Enter a number (0-9)."
      end
    end
    val
  end

  def play_turn
    board.render
    pos = get_pos
    val = get_val
    board[pos] = val
  end

  def run
    play_turn until solved?
    board.render
    puts "Congratulations, you win!"
  end

  def solved?
    board.solved?
  end

  def valid_pos?(pos)
    if pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |x| x.between?(0, board.size - 1) }
      return true
    end
  end

  def valid_val?(val)
    val.is_a?(Integer) &&
      val.between?(0, 9)
  end

  private
  attr_reader :board
end


game = SudokuGame.from_file("puzzles/sudoku1.txt")
game.run
