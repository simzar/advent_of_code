test_input = "seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4"

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

def is_seeds_line(line)
  line.start_with?("seeds:")
end

def is_end_of_map(line)
  line.empty?
end

def is_map_header(line)
  line.include?("map:")
end

def is_map_entry(line)
  extract_numbers(line).length == 3
end

def parse_map_header(line)
  from, _, to = line.split(" ")[0].split("-")
  [from, to]
end

def parse_seeds(line)
  extract_numbers(line)
end

def parse_data(lines)
  seeds = []
  maps = []
  current_map = nil

  lines.each do |line|
    if is_seeds_line(line)
      seeds = parse_seeds(line)
    elsif is_map_header(line)
      if !current_map.nil?
        p 'not goood, current map not nill'
      end
      from, to = parse_map_header(line)
      current_map = { from: from, to: to, entries: []}
    elsif is_map_entry(line)
      dest_start, source_start, range_length = extract_numbers(line)
      current_map[:entries] << { dest_start: dest_start, source_start: source_start, range_length: range_length }
    elsif is_end_of_map(line)
      next if current_map.nil?
      maps << current_map
      current_map = nil
    end
  end
  unless current_map.nil?
    maps << current_map
  end

  [seeds, maps]
end


@cached_entry = nil

def entry_matches?(entry, input)
  entry[:source_start] <= input && input < entry[:source_start] + entry[:range_length]
end

def get_matching_entry(input, map)
  # map[:entries].find { |entry| entry[:source_start] <= input && input < entry[:source_start] + entry[:range_length] }

  if !@cached_entry.nil? && entry_matches?(@cached_entry, input)
    return @cached_entry
  end

  @cached_entry = map[:entries].find { |entry| entry_matches?(entry, input) }
  @cached_entry
end

def apply_mapping_entry(input, entry)
  rule = entry[:dest_start] - entry[:source_start]
  input + rule
end

def map_once(input, map)
  matching_entry = get_matching_entry(input, map)
  if matching_entry.nil?
    return input
  end
  apply_mapping_entry(input, matching_entry)
end

def map_fully(input, maps)
  # maps.reduce(input) { |acc, map| map_once(acc, map) }
  maps.reduce(input) do |acc, map|
    res = map_once(acc, map)
    @cached_entry = nil
    res
  end
end

def solve(input)
  lines = get_lines(input)
  seeds, maps = parse_data(lines)

  p seeds
  last_mappings = seeds.map { |seed| map_fully(seed, maps) }
  p last_mappings
  p last_mappings.min
end


# solve(test_input)
# solve(read_file("/home/simonas/Documents/advent_of_code/5/input.txt"))
# 662197086 correct

# def find_first_matching_range(input, map)
#   map[:entries].select { |entry| entry[:source_start] <= input && input < entry[:source_start] + entry[:range_length] }
# end

def map_range_fully(seeds_array, maps)
  maps.reduce(seeds_array) do |acc, map|
    p "Mapping range: #{acc.first} - #{acc.last}"
    res = acc.map { |seed| map_once(seed, map) }
    @cached_entry = nil
    res
  end
end



def overlap?(r1,r2)
  !(r1.first > r2.last || r1.last < r2.first)
end

def matching_ranges(first_seed, last_seed, map)
  map[:entries].select { |entry| overlap?([first_seed, last_seed], [entry[:source_start], entry[:source_start] + entry[:range_length] - 1]) }
               .sort_by { |entry| entry[:source_start] }
end

def map_start_offset_to_range(start, offset)
  [start, start + offset - 1]
end

def map_once_seeds_range(first_seed, last_seed, map)
  ranges = matching_ranges(first_seed, last_seed, map)

  p ranges

  # Find lowest range, if lowest includes first_seed, then start from beginning. If not, map one to one until the start of the lowest range and map for the length of the range or for the length of the seed range, whichever is smaller.
  # Repeat process until the last seed is reached.
  # If the last seed is not included in the last range, map one to one until the end of the last range.
  # If the last seed is included in the last range, map one to one until the end of the last seed.
  #

  # Would be way easier if I used actual ranges instead of start + offset, that way splitting is simpler.

  # matching_entry = get_matching_entry(input, map)
  # if matching_entry.nil?
  #   return input
  # end
  # apply_mapping_entry(input, matching_entry)
end


def solve_second(input)
  lines = get_lines(input)
  seeds = []
  seeds_line, maps = parse_data(lines)
  seed_ranges = seeds_line.each_slice(2).map { |start, len| map_start_offset_to_range(start, len) }
  # maps = maps.map { |map| { from: map[:from], to: map[:to], source_ranges: map[:entries].map { |entry| { dest_start: entry[:dest_start], source_start: entry[:source_start], range_length: entry[:range_length] } } }

  min_value = 999999999999

  seeds_line.each_slice(2) do |start, len|
    first_seed = start
    last_seed = first_seed + len - 1
    # map_once_seeds_range(first_seed, last_seed, maps[0])
    p "Processing pair: #{start}, #{len}"
    res = map_range_fully((first_seed..last_seed), maps).min
    # (0..len-1).each do |addition|
    #   if addition % 1000000 == 0
    #     p "Processing addition: #{addition}"
    #   end
    #   seed = start + addition
    #   res = map_fully(seed, maps)
      if res < min_value
        min_value = res
        p "current min value: #{min_value}"
      end
    # end
  end

  p maps
  p min_value
end


# solve_second(test_input)
solve_second(read_file("/home/simonas/Documents/advent_of_code/5/input.txt"))

# 102613525 too big
# 52510809 correct
