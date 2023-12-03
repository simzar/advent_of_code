test_input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."

def read_file(path)
  File.read(path)
end

def get_lines(input)
  input.split("\n")
end

# Extract numbers, their lengths and indices
def extract_numbers(line)
  numbers = []
  line.scan(/\d+/) do |number|
    numbers << [number, number.length, $~.offset(0).first]
  end
  numbers
end

def adjacent_coords_to_number(index, length, line, line_index, lines_count)
  res = []

  # Add all adjacent cell coordinates from the line above
  if line_index > 0 && index > 0
    res << [line_index - 1, index - 1]
  end
  if line_index > 0
    (0..length - 1).each { |i|
      res << [line_index - 1, index + i]
    }
  end
  if line_index > 0 && index + length < line.length
    res << [line_index - 1, index + length]
  end

  # Add all adjacent cell coordinates from the same line
  if index > 0
    res << [line_index, index - 1]
  end
  if index + length < line.length
    res << [line_index, index + length]
  end

  # Add all adjacent cell coordinates from the line below
  if line_index < lines_count - 1 && index > 0
    res << [line_index + 1, index - 1]
  end
  if line_index < lines_count - 1
    (0..length - 1).each { |i|
      res << [line_index + 1, index + i]
    }
  end
  if line_index < lines_count - 1 && index + length < line.length
    res << [line_index + 1, index + length]
  end

  res
end

# Check if there is a symbol in coordinates. Symbols are anything but dots and digits
def is_symbol_in_coords(coords, lines)
  line_index, index = coords
  symbol = lines[line_index][index]
  !symbol.nil? && symbol != ' ' && !symbol.match?(/\d|\./)
end

# Number is a part number if it is adjacent to a symbol
def is_part_number(index, length, line, line_index, lines)
  adjacent_coords = adjacent_coords_to_number(index, length, line, line_index, lines.length)
  adjacent_coords.any? { |coords| is_symbol_in_coords(coords, lines) }
end

def solve(input)
  part_numbers_sum = 0

  lines = get_lines(input)
  (0..lines.length - 1).each { |line_index|
    line = lines[line_index]
    numbers = extract_numbers(line)

    part_numbers = numbers.select { |number, length, index| is_part_number(index, length, line, line_index, lines) }
                          .map { |number, length, index| number.to_i }
    part_numbers_sum += part_numbers.sum
  }

  part_numbers_sum
end

# p solve(test_input)
# p solve(read_file("/home/simonas/Documents/advent_of_code/3/input.txt"))
#
# 540037 is too low
# 540345 - too high, what would happen if I also included numbers
# 540212 correct

def star_indices(line)
  stars = []
  line.each_char.with_index do |symbol, index|
    if symbol == '*'
      stars << index
    end
  end
  stars
end

def is_adjacent_to_star(star_index, number_index, number_length)
  [star_index - 1, star_index, star_index + 1].any? { |ind| (number_index..number_index + number_length - 1).include?(ind) }
end

def adjacent_numbers(star_index, numbers_above, numbers_same_line, numbers_below)
  (numbers_above + numbers_same_line + numbers_below).select { |number, length, index| is_adjacent_to_star(star_index, index, length) }
                                                     .map { |number, length, index| number.to_i }
end

def solve_second(input)
  res = 0

  lines = get_lines(input)
  numbers_by_line = lines.map { |line| extract_numbers(line) }

  (0..lines.length - 1).each { |line_index|
    line = lines[line_index]
    stars = star_indices(line)
    stars.each { |star_index|
      numbers_above = numbers_by_line[line_index - 1].nil? ? [] : numbers_by_line[line_index - 1]
      numbers_same_line = numbers_by_line[line_index]
      numbers_below = numbers_by_line[line_index + 1].nil? ? [] : numbers_by_line[line_index + 1]

      adjacent_numbers = adjacent_numbers(star_index, numbers_above, numbers_same_line, numbers_below)
      if adjacent_numbers.size == 2
        res += adjacent_numbers[0] * adjacent_numbers[1]
      end
    }
  }

  res
end

# p solve_second(test_input)
p solve_second(read_file("/home/simonas/Documents/advent_of_code/3/input.txt"))
# 87605697 correct