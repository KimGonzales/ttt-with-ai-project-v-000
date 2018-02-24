require 'pry'
class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [6,4,2]
  ]

  def initialize(player_1 =Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  def current_player
    board.turn_count.even? ? player_1 : player_2
  end

  def over?
    won? || board.full? || draw?
  end

  def won?
    WIN_COMBINATIONS.detect do|combo|
      board.taken?(combo[0]+1) &&
      board.cells[combo[0]] == board.cells[combo[1]] &&
      board.cells[combo[1]] == board.cells[combo[2]]
    end
  end

  def draw?
    !self.won? && board.full?
  end

  def winner
    winning_token = won?
    won? && board.cells[winning_token[0]]
  end

  def turn
    input = current_player.move
    if board.valid_move?(input)
      board.update(input,current_player)
    else
      puts "That move is invalid!"
        turn
    end
  end

  def play
    board.display
    until over?
      turn
    end
  end
end
