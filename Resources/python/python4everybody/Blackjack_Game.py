import random

suits = ('Hearts', 'Diamonds', 'Spades', 'Clubs')
ranks = ('Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Jack', 'Queen', 'King', 'Ace')
values = {'Two':2, 'Three':3, 'Four':4, 'Five':5, 'Six':6, 'Seven':7, 'Eight':8, 'Nine':9, 'Ten':10, 'Jack':10,
         'Queen':10, 'King':10, 'Ace':11}

playing = True

class Card:
    def __init__(self, suit, rank):
        self.suit = suit
        self.rank = rank

    def __str__(self):
        return self.rank + " of " + self.suit

class Deck:
    def __init__(self):
        self.deck = []
        for suit in suits:
            for rank in ranks:
                self.deck.append(Card(suit,rank))

# Q!
    def __str__(self):
        deck_comp = ''
        for card in self.deck:
            deck_comp += '\n' + card.__str__()
        return deck_comp

    def shuffle(self):
        random.shuffle(self.deck)
    def deal(self):
        return self.deck.pop()

class Hand:
    def __init__(self):
        self.cards = []
        self.value = 0
        self.aces = 0

    def add_card(self, card):
        self.cards.append(card)
        self.value += values[card.rank]
        if card.rank == "Ace":
            self.aces += 1

    def adjust_for_ace(self):
        while self.value > 21 and self.aces:
            self.value -= 10
            self.aces -= 1

class Chips:
    def __init__(self):
        self.total = 100
        self.bet = 0
    def win_bet(self):
        self.total += self.bet
    def lose_bet(self):
        self.total -= self.bet

def take_bet(chips):
    while True:
        try:
            chips.bet = int(input("How much you want to bet?"))
        except:
            print("Please enter a number!")
            continue
        #else:
        if chips.bet > chips.total:
            print("You don't have enough chips!")
            continue
        else:
            break

def hit(deck, hand):
    hand.add_card(deck.deal())
    hand.adjust_for_ace()

def hit_or_stand(deck, hand):
    global playing

    while True:
        player_ans = input("Do you want to Hit or Stand?")

        if player_ans[0].upper() == "H":
            hit(deck,hand)
        elif player_ans[0].upper() == 'S':
            print("Player stand, Dealer's term.")
            playing = False

        else:
            print("Please enter valid response.")
            continue
        break

def show_some_card(player, dealer):
    print("Dealer's Hand: ")
    print(dealer.cards[0])
    print("\n")
    print("Player's Hand: ")
    for card in player.cards:
        print(card)

def show_all_card(player, dealer):
    print("Dealer's Hand: ")
    for card in dealer.cards:
        print(card)
    print("\n")
    print("Player's Hand: ")
    for card in player.cards:
        print(card)

def player_busts(player,dealer,chips):
    chips.lose_bet()
    print("Player busts!")

def player_wins(player,dealer,chips):
    print("Player wins!")
    chips.win_bet()

def dealer_busts(player,dealer,chips):
    chips.win_bet()
    print("Dealer busts!")

def dealer_wins(player,dealer,chips):
    print("Dealer wins!")
    chips.lose_bet()

def push(player,dealer):
    print("Tie!")

############
while True:
    # Print an opening statement
    print("Welcome to BlackJack!")

    # Create & shuffle the deck, deal two cards to each player
    deck = Deck()
    deck.shuffle()

    player_hand = Hand()
    player_hand.add_card(deck.deal())
    player_hand.add_card(deck.deal())

    dealer_hand = Hand()
    dealer_hand.add_card(deck.deal())
    dealer_hand.add_card(deck.deal())

    # Set up the Player's chips
    player_chip = Chips()

    # Prompt the Player for their bet
    print("Place a bet!")
    take_bet(player_chip)

    # Show cards (but keep one dealer card hidden)
    show_some_card(player_hand, dealer_hand)

    while playing:  # recall this variable from our hit_or_stand function

        # Prompt for Player to Hit or Stand
        hit_or_stand(deck, player_hand)

        # Show cards (but keep one dealer card hidden)
        show_some_card(player_hand, dealer_hand)

        # If player's hand exceeds 21, run player_busts() and break out of loop
        if player_hand.value > 21:
            player_busts(player_hand, dealer_hand, player_chip)

            break

    # If Player hasn't busted, play Dealer's hand until Dealer reaches 17
    if player_hand.value <= 21:

        while dealer_hand.value < 17:
            hit(deck,dealer_hand)

        # Show all cards
        show_all_card(player_hand, dealer_hand)
        # Run different winning scenarios

        if dealer_hand.value > 21:
            dealer_busts(player_hand,dealer_hand,player_chip)
        elif dealer_hand.value > player_hand.value:
            dealer_wins(player_hand, dealer_hand,chips)
        elif dealer_hand.value == player_hand.value:
            push(player_hand,dealer_hand)
        else:
            player_wins(player_hand,dealer_hand,player_chip)

    # Inform Player of their chips total
    print("Total chips:" + str(player_chip.total))
    # Ask to play again
    new_game = input("Play again?")

    if new_game[0].lower() == 'y':
        playing = True

        continue
    else:
        print("Thank you for playing.")
        break


'''
test_deck = Deck()
test_deck.shuffle()

test_dealer = Hand()
test_player = Hand()
test_chips = Chips()

test_dealer.add_card(test_deck.deal())
test_dealer.add_card(test_deck.deal())
test_player.add_card(test_deck.deal())
test_player.add_card(test_deck.deal())

show_some_card(test_player, test_dealer)
print("\n")
show_all_card(test_player, test_dealer)
'''
