test_input = "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"

def read_file(path)
  File.read(path)
end

# This method does not work, because it replaces in numeric order, not from left to right
def replace_spelled_digits_with_digits(line)
  res = line
  # return res.gsub(/one/ => "1", /two/ => "2", /three/ => "3", /four/ => "4", /five/ => "5", /six/ => "6", /seven/ => "7", /eight/ => "8", /nine/ => "9")
  # res.gsub({/one/=> "1", /two/=> "2", /three/=> "3", /four/=> "4", /five/=> "5", /six/=> "6", /seven/=> "7", /eight/=> "8", /nine/ => "9"})

  res.gsub(/one/, "o1e")
     .gsub(/two/, "t2o")
     .gsub(/three/, "t3e")
     .gsub(/four/, "f4r")
     .gsub(/five/, "f5e")
     .gsub(/six/, "s6x")
     .gsub(/seven/, "s7n")
     .gsub(/eight/, "e8t")
     .gsub(/nine/, "n9e")
end

REPLACEMENT_KEYS = [
  %w[one o1e],
  %w[two t2o],
  %w[three t3e],
  %w[four f4r],
  %w[five f5e],
  %w[six s6x],
  %w[seven s7n],
  %w[eight e8t],
  %w[nine n9e]
]

# Better replace_spelled_digits_with_digits method, that works from left to right, not from 1 to 9
# def replace_spelled_digits_with_digits(line)
#   res = line
#   res.gsub(/one/, "1")
#      .gsub(/two/, "2")
#      .gsub(/three/, "3")
#      .gsub(/four/, "4")
#      .gsub(/five/, "5")
#      .gsub(/six/, "6")
#      .gsub(/seven/, "7")
#      .gsub(/eight/, "8")
#      .gsub(/nine/, "9")
# end

def get_leftmost_substr_index(line, substr)
  line.index(substr)
end

def perform_one_replacement(line)
  replacement_scores = REPLACEMENT_KEYS.map do |key, value|
    index = get_leftmost_substr_index(line, key)
    [key, value, index]
  end

  replacement_with_lowest_index = replacement_scores.filter{ |_, _, index| !index.nil? }
                                                    .min_by { |_, _, index| index }
  return line if replacement_with_lowest_index.nil?

  key, value, index = replacement_with_lowest_index
  line.sub(key, value)
end

def perform_all_replacements(line)
  replaced_line = perform_one_replacement(line)
  if replaced_line.length == line.length
    return line
  else
    perform_all_replacements(replaced_line)
  end
end

def is_digit(symbol)
  symbol.match?(/\d/)
end

def find_numbers(line)
  digits = []
  line.each_char do |symbol|
    if is_digit(symbol)
      digits << symbol
    end
  end
  digits
end

def first_and_last_numbers(numbers)
  return [0] if numbers.empty?
  return [numbers.first, numbers.first] if numbers.length == 1

  [numbers.first, numbers.last]
end

def numb_array_to_string(numbers)
  return "" if numbers.empty?
  return numbers.first if numbers.length == 1

  numbers.join("")
end

def sum_of_numbers(numbers)
  numbers.map(&:to_i).sum
end

# Solves first part
def solve(input)
  lines = input.split("\n")

  numbers = lines.map do |line|
    numbers = find_numbers(line)
    first_and_last = first_and_last_numbers(numbers)
    numb_array_to_string(first_and_last)
  end

  sum_of_numbers(numbers)
end

# p solve(test_input)
# p solve(read_file("/home/simonas/Documents/advent/1/input.txt"))

# Solves second part

def solve_second(input)
  lines = input.split("\n")
  # replaced_lines = lines.map { |line| perform_all_replacements(line) }
  replaced_lines = lines.map { |line| replace_spelled_digits_with_digits(line) }

  numbers = replaced_lines.map do |line|
    numbers = find_numbers(line)
    first_and_last = first_and_last_numbers(numbers)
    numb_array_to_string(first_and_last)
  end

  sum_of_numbers(numbers)
end

# input = read_file("/home/simonas/Documents/advent/1/input.txt")

# real_lines = input.split("\n")
# transformed_lines = real_lines.map { |line| replace_spelled_digits_with_digits(line) }

# p solve_second(read_file("/home/simonas/Documents/advent/1/input.txt"))
# 54303 is too low
# 54866 is too low
# 54878 is too low
# 57226 wrong
# 58285 wrong
# when replace all 54885

# p 'done'
test_input = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"

# p solve_second(test_input)
p solve_second(read_file("/home/simonas/Documents/advent/1/input.txt"))
