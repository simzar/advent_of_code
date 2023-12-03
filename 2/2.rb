test_input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"

def read_file(path)
  File.read(path)
end

def get_lines(input)
  input.split("\n")
end


def parse_round(round_str)
  red = 0
  green = 0
  blue = 0
  round_str.split(", ").each do |color_str|
    count, color = color_str.split(" ")
    case color
    when "red"
      red = count.to_i
    when "green"
      green =count.to_i
    when "blue"
      blue = count.to_i
    end
  end

  [red, green, blue]
end

def validate_round(round, rules)
  red, green, blue = round
  max_red, max_green, max_blue = rules
  red <= max_red && green <= max_green && blue <= max_blue
end

def parse_game(line)
  line.split(": ")[0].split(" ")[1].to_i
  id_part, rounds_str = line.split(": ")
  id = id_part.split(" ")[1].to_i
  rounds = rounds_str.split("; ").map { |round| parse_round(round) }
  [id, rounds]
end

def validate_game(game, rules)
  id, rounds = game
  rounds.all? { |round| validate_round(round, rules) }
end

MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14


def solve(input)
  lines = get_lines(input)
  games = lines.map { |line| parse_game(line) }
  valid_games = games.select { |game| validate_game(game, [MAX_RED, MAX_GREEN, MAX_BLUE]) }
  valid_game_ids_sum = valid_games.map { |game| game[0] }.sum

  valid_game_ids_sum
end

# p solve(test_input)
# p solve(read_file("/home/simonas/Documents/advent_of_code/1/input.txt"))


def game_maximum(game)
  id, rounds = game
  reds = rounds.map { |round| round[0] }
  greens = rounds.map { |round| round[1] }
  blues = rounds.map { |round| round[2] }

  [reds.max, greens.max, blues.max]
end

def game_power(game)
  r, g, b = game_maximum(game)
  r * g * b
end

def solve_second(input)
  lines = get_lines(input)
  games = lines.map { |line| parse_game(line) }
  game_powers = games.map { |game| game_power(game) }

  game_powers.sum
end

# p solve_second(test_input)
p solve_second(read_file("/home/simonas/Documents/advent_of_code/1/input.txt"))
