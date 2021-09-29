#from IPython.display import clear_output
import random

# print out 3 by 3 board [0 -9]
def display_board(board):
    #clear_output()
    print('\n'*100)
    print(board[7] + "|" + board[8] + "|" + board[9])
    print(board[4] + "|" + board[5] + "|" + board[6])
    print(board[1] + "|" + board[2] + "|" + board[3])
# ask player imput
def player_input():
    ans = ''
    switch = False

    while ans != 'X' and ans != 'O' and switch == False:
        ans = input("Player 1, Enter your marker (X or O): ").upper()

        if ans =="X" or ans == "O":
            player_1 = ans

            if ans == 'X':
                player_2 = "O"
            else:
                player_2 = "X"
        else:
            switch = False
            print("Invalid Input, enter again")
    return (player_1, player_2)
# put marks in board
def place_marker(board, marker, position):
    board[position] = marker
# need more check
def win_check(board, mark):

    return ((board[1] == mark and board[2] == mark and board[3] == mark) or
    (board[4] == mark and board[5] == mark and board[6] == mark) or
    (board[7] == mark and board[8] == mark and board[9] == mark) or
    (board[7] == mark and board[4] == mark and board[1] == mark) or
    (board[8] == mark and board[5] == mark and board[2] == mark) or
    (board[9] == mark and board[6] == mark and board[3] == mark) or
    (board[7] == mark and board[5] == mark and board[3] == mark) or
    (board[9] == mark and board[5] == mark and board[1] == mark))
# random decide who goes first
def choose_first():
    flip = random.randint(0, 1)
    if flip == 0:
        return "Player 1"
    else:
        return "Player 2"
# check the space chosen is empty or not, return True if the position is empty
def space_check(board, position):
    if board[position] == "#":
            return True
# check the full board, return true if it's full
def full_board_check(board):
    for i in range (1, 10):
        if space_check(board, i):
            return False
    return True
# ask player next position, return pos
def player_choice(board):
    check = False
    position = 0

    while position not in [1, 2, 3, 4, 5, 6, 7, 8, 9] or not space_check(board, position):
        position = int(input("Next position (1-9): "))

    return position
# return true if they want to play again
def replay():
    test = False
    while test == False:

        res = input("Play again? (Y or N)").upper()

        if res == "Y":
            test = True
            return True
        elif res == "N":
            test = True
            return False
        else:
            test = False
            print("Invalid input, please type (Y or N)")

########################################### Main Prog#########################

print('Welcome to Tic Tac Toe!')

while True:
    # display_board(board)
    board = ['#','#','#','#','#','#','#','#','#','#']
    player1_marker, player2_marker = player_input()
    turn = choose_first()
    print(turn + " will go first!")
    # Welcome message
    play_game = input("Ready to play? (Y or N) ").upper()

    if play_game == 'Y':
        game_on = True
    else:
        game_on = False
    #logic
    while game_on:
        # Player 1 turn
        if turn == 'Player 1':
            # show board
            display_board(board)
            # choose position
            position = player_choice(board)
            place_marker(board,player1_marker,position)
            # check if they won
            if win_check(board, player1_marker):
                display_board(board)
                print("Player 1 win.")
                game_on = False
            else:
                if full_board_check(board):
                    display_board(board)
                    print("Tie")
                    game_on = False
                else:
                    turn = 'Player 2'
        # Player 2 turn
        else:
            # show board
            display_board(board)
            # choose position
            position = player_choice(board)
            place_marker(board, player2_marker,position)

            if win_check(board, player2_marker):
                display_board(board)
                print("Player 2 win.")
                game_on = False
            else:
                if full_board_check(board):
                    display_board(board)
                    print("Tie")
                    game_on = False
                else:
                    turn = 'Player 1'
    # exit game
    if not replay():
            break
            print("Good Game!")
