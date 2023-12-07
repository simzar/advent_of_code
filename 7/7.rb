test_input = "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"

def read_file(path)
  File.read(path)
end

def get_lines(input)
  input.split("\n")
end
#
# CARD_VALUES = {
#   "A" => 1,
#   "K" => 2,
#   "Q" => 3,
#   "J" => 4,
#   "T" => 5,
#   "9" => 6,
#   "8" => 7,
#   "7" => 8,
#   "6" => 9,
#   "5" => 10,
#   "4" => 11,
#   "3" => 12,
#   "2" => 13
# }

HAND_VALUES = {
  "five_of_a_kind" => 1,
  "four_of_a_kind" => 2,
  "full_house" => 3,
  "three_of_a_kind" => 4,
  "two_pairs" => 5,
  "one_pair" => 6,
  "highest_card" => 7
}

def get_symbol_frequencies(symbols)
  symbol_frequencies = {}
  symbols.each do |symbol|
    if symbol_frequencies[symbol].nil?
      symbol_frequencies[symbol] = 1
    else
      symbol_frequencies[symbol] += 1
    end
  end
  symbol_frequencies
end

# def construct_hand_value(line)
#   cards, bid = line.split(" ")
#   cards = cards.split("")
#   frequencies = get_symbol_frequencies(cards)
#   different_cards = frequencies.keys.length
#
#   type = 'highest_card'
#   if different_cards == 1
#     type = 'five_of_a_kind'
#   elsif different_cards == 2
#     if frequencies.values.include?(4)
#       type = 'four_of_a_kind'
#     else
#       type = 'full_house'
#     end
#   elsif different_cards == 3
#     if frequencies.values.include?(3)
#       type = 'three_of_a_kind'
#     else
#       type = 'two_pairs'
#     end
#   elsif different_cards == 4
#     type = 'one_pair'
#   end
#
#   { cards: cards, bid: bid.to_i, type: type, value: HAND_VALUES[type] }
# end

def compare_hands(a, b)
  return a[:value] <=> b[:value] if a[:value] != b[:value]

  a_card_values = a[:cards].map { |card| CARD_VALUES[card] }
  b_card_values = b[:cards].map { |card| CARD_VALUES[card] }

  return a_card_values[0] <=> b_card_values[0] if a_card_values[0] != b_card_values[0]
  return a_card_values[1] <=> b_card_values[1] if a_card_values[1] != b_card_values[1]
  return a_card_values[2] <=> b_card_values[2] if a_card_values[2] != b_card_values[2]
  return a_card_values[3] <=> b_card_values[3] if a_card_values[3] != b_card_values[3]
  a_card_values[4] <=> b_card_values[4]
end

def solve(input)
  lines = get_lines(input)
  hands = lines.map(&method(:construct_hand_value))
  max_rank = hands.length
  winnings = []

  hands.sort! { |a, b| compare_hands(a, b) }
       .each_with_index do |hand, index|
    rank = max_rank - index
    winnings << hand[:bid] * rank
  end

  winnings.sum
end

# p solve(test_input)
# p solve(read_file("/home/simonas/Documents/advent_of_code/7/input.txt"))
# 250254244 correct

# Now J becomes joker

CARD_VALUES = {
  "A" => 1,
  "K" => 2,
  "Q" => 3,
  "T" => 5,
  "9" => 6,
  "8" => 7,
  "7" => 8,
  "6" => 9,
  "5" => 10,
  "4" => 11,
  "3" => 12,
  "2" => 13,
  "J" => 14,
}

def construct_hand_value(line)
  cards, bid = line.split(" ")
  cards = cards.split("")
  frequencies = get_symbol_frequencies(cards)
  different_cards = frequencies.keys.length

  type = 'highest_card'
  if different_cards == 1
    type = 'five_of_a_kind'
  elsif different_cards == 2
    if frequencies.values.include?(4)
      if frequencies.keys.include?('J')
        type = 'five_of_a_kind'
      else
        type = 'four_of_a_kind'
      end
    else
      # JJJAA or JJAAA would result in AAAAA
      if frequencies.keys.include?('J')
        type = 'five_of_a_kind'
      else
        type = 'full_house'
      end
    end
  elsif different_cards == 3
    if frequencies.values.include?(3)
      if frequencies.keys.include?('J')
        type = 'four_of_a_kind'
      else
        type = 'three_of_a_kind'
      end
    else
      if frequencies.keys.include?('J')
        if frequencies['J'] == 2
          type = 'four_of_a_kind'
        else
          type = 'full_house'
        end
      else
        type = 'two_pairs'
      end
    end
  elsif different_cards == 4
    if frequencies.keys.include?('J')
      type = 'three_of_a_kind'
    else
      type = 'one_pair'
    end
  else
    if frequencies.keys.include?('J')
      type = 'one_pair'
    else
      type = 'highest_card'
    end
  end

  { cards: cards, bid: bid.to_i, type: type, value: HAND_VALUES[type] }
end

# for the second part with overrides

# p solve(test_input)
p solve(read_file("/home/simonas/Documents/advent_of_code/7/input.txt"))
# 250087440 is correct