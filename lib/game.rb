require 'pry'
class Game
#####################  GAME PROPERITES #######################################
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

#######################  GAME STATUS #########################################
  def current_player
    board.turn_count.even? ? player_1 : player_2
  end

  def over?
    won? || draw?
  end

  def won?
    WIN_COMBINATIONS.detect do|combo|
      board.taken?(combo[0]+1) &&
      board.cells[combo[0]] == board.cells[combo[1]] &&
      board.cells[combo[1]] == board.cells[combo[2]]
    end
  end

  def draw?
    !won? && board.full?
  end

  def winner
    winning_token = won?
    won? && board.cells[winning_token[0]]
  end

############################## TURN AND PLAY #####################################



  def turn
    input = current_player.move(board)
    if board.valid_move?(input)
      puts "#{current_player.token} moved to cell #{input}".cyan
      board.update(input,current_player)
      board.display
    else
      puts "Oops.That move is invalid!".red
        turn
    end
  end

  def play
    until over?
      turn
    end
    if won?
      puts "Congratulations #{winner}!" 
      puts "You've won the game!"
    else draw?
      puts "Cat's Game!"
    end
  end
  #colorizing line 71 and 74 causes specs to fail

end
