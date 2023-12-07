test_input = "Time:      7  15   30
Distance:  9  40  200"

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

def distance_for_time(hold_duration, total_time)
  hold_duration * (total_time - hold_duration)
end

def breaks_record?(hold_duration, total_time, record_distance)
  distance_for_time(hold_duration, total_time) > record_distance
end

def get_winning_hold_durations(total_time, record_distance)
  (0..total_time).select { |hold_duration| breaks_record?(hold_duration, total_time, record_distance) }
end

def solve(input)
  lines = get_lines(input)
  times = extract_numbers(lines[0])
  distances = extract_numbers(lines[1])
  error_margins = []

  times.each_with_index do |time, index|
    error_margins << get_winning_hold_durations(time, distances[index]).size
  end

  p error_margins
  p error_margins.inject(:*)
end


# solve(test_input)
# solve(read_file("/home/simonas/Documents/advent_of_code/6/input.txt"))

second_test_input = "Time: 71530
Distance:  940200"

# solve(second_test_input)
solve(read_file("/home/simonas/Documents/advent_of_code/6/input_2.txt"))
# 34454850 is correct, although the way to solve it was lazy