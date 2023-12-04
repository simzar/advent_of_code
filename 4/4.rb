test_input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"

def read_file(path)
  File.read(path)
end

def get_lines(input)
  input.split("\n")
end

def extract_numbers(str)
  str.scan(/\d+/)
     .map(&:to_i)
end

def is_winning_number(number, winning_numbers)
  winning_numbers.include?(number)
end

def extract_drawn_numbers(line)
  drawn_numbers_string = line.split(": ")[1].split(" | ")[1]
  extract_numbers(drawn_numbers_string)
end

def extract_lucky_numbers(line)
  lucky_numbers_string = line.split(": ")[1].split(" | ")[0]
  extract_numbers(lucky_numbers_string)
end

def calculate_card_score(winning_numbers, drawn_numbers)
  lucky_numbers_count = drawn_numbers.select { |number| is_winning_number(number, winning_numbers) }.length

  return 0 if lucky_numbers_count == 0
  2.pow(lucky_numbers_count - 1)
end

def solve(input)
  total_score = 0

  lines = get_lines(input)
  lines.each do |line|
    winning_numbers = extract_lucky_numbers(line)
    drawn_numbers = extract_drawn_numbers(line)
    total_score += calculate_card_score(winning_numbers, drawn_numbers)
  end

  total_score
end

# p solve(test_input)
# p solve(read_file("/home/simonas/Documents/advent_of_code/4/input.txt"))
# 20667 correct

def map_line_to_game(line)
  id = line.split(": ")[0].split(" ")[1].to_i
  winning_numbers = extract_lucky_numbers(line)
  drawn_numbers = extract_drawn_numbers(line)

  [id, winning_numbers, drawn_numbers]
end

def get_card_by_id(id, cards)
  cards[id - 1]
end

def get_card_winnings(card, cards)
  card_id, winning_numbers, drawn_numbers = card
  lucky_numbers_count = drawn_numbers.select { |number| is_winning_number(number, winning_numbers) }.length


  return [] if lucky_numbers_count == 0

  (card_id+1..card_id+lucky_numbers_count).map { |id| get_card_by_id(id, cards) }
end


def solve_second(input)
  lines = get_lines(input)
  original_cards = lines.map { |line| map_line_to_game(line) }
  cards = original_cards.clone

  cards.each do |card|
    p "Running for card: #{card[0]}"
    winnings = get_card_winnings(card, original_cards)
    winnings.each { |won_card| cards << won_card }
  end

  # p cards.map(&:first)
  cards.size
end

# p solve_second(test_input)
p solve_second(read_file("/home/simonas/Documents/advent_of_code/4/input.txt"))
# 5833065 correct