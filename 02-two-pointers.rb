puts "Find pair summing to target in sorted array"

def find_pair(nums, target)
  left, right = 0, nums.length - 1
  while left < right
    sum = nums[left] + nums[right]
    return [left, right] if sum == target
    if sum > target
      right -= 1
    else
      left += 1
    end
  end
  [-1, -1]
end

# can use hashtable for unsorted
p find_pair [1, 2, 3, 4, 6], 6
p find_pair [2, 5, 9, 11], 11

puts "Remove duplicates"

def remove_duplicates(nums)
  low, high = 0, 0
  while high < nums.length
    next_idx = high
    next_idx += 1 while next_idx < nums.length && nums[high] == nums[next_idx]
    nums[low] = nums[high]
    low += 1
    high = next_idx
  end
  nums
end

def remove_duplicates(nums)
  low = 0
  0.upto(nums.length - 1) do |high|
    if high == nums.length - 1 || nums[high] != nums[high + 1]
      nums[low] = nums[high]
      low += 1
    end
  end
  p low
  nums
end

p remove_duplicates [2, 3, 3, 3, 6, 9, 9]
p remove_duplicates [1, 2, 3, 4, 5, 6, 7, 8, 10]

puts "Remove a target in place from a sorted array"

def remove_target(nums, target)
  low = 0
  0.upto(nums.length - 1) do |high|
    if nums[high] != target
      nums[low] = nums[high]
      low += 1
    end
  end
  nums.slice(0, low)
end

p remove_target [2, 3, 3, 3, 6, 9, 9], 3
p remove_target [3, 2, 3, 6, 3, 10, 9, 3], 3
p remove_target [2, 11, 2, 2, 1], 2

puts "numbers of sorted array - create squares"

def squares(nums)
  left, right = 0, nums.length - 1
  res, other_idx = [], nums.length - 1
  while other_idx >= 0
    if nums[left] < 0 && nums[left].abs > nums[right].abs
      res[other_idx] = nums[left] * nums[left]
      left += 1
    else
      res[other_idx] = nums[right] * nums[right]
      right -= 1
    end
    other_idx -= 1
  end
  res
end

p squares [-5, -1, 0, 2, 3]
p squares [-3, -1, 0, 1, 2]

puts "Triplet sum to zero"

def three_sum(nums)
  nums.sort!
  res = []
  0.upto(nums.length - 3) do |first|
    next if first > 0 && nums[first] == nums[first - 1]
    two_sum(nums, first + 1, -1 * nums[first]).each do |second, third|
      res << [nums[first], nums[second], nums[third]]
    end
  end
  res
end

def two_sum(nums, left, target)
  start, res, right = left, [], nums.length - 1
  while left < right
    sum = nums[left] + nums[right]
    left_duplicate = left > start && nums[left] == nums[left - 1]
    right_duplicate = right < nums.length - 1 && nums[right] == nums[right + 1]
    if left_duplicate || sum < target
      left += 1
    elsif right_duplicate || sum > target
      right -= 1
    else # found target
      res << [left, right]
      left += 1
      right -= 1
    end
  end
  res
end

p three_sum [-3, 0, 1, 2, -1, 1, -2]
p two_sum [1, 2, 2, 3, 4], 0, 4

p three_sum [-1, 0, 1, 2, -1, -4]

puts "Triple with closest sum to target"

def three_sum_closest(nums, target)
  nums.sort!
  min_diff = 1.0 / 0
  0.upto(nums.length - 3) do |first|
    diff = two_sum_closest(nums, first + 1, target - nums[first])
    min_diff = diff if diff.abs < min_diff.abs
    break if min_diff.zero?
  end
  target - min_diff
end

def two_sum_closest(nums, left, target)
  right, min_diff = nums.length - 1, 1.0 / 0
  while left < right && min_diff != 0
    diff = (target - nums[left] - nums[right])
    min_diff = diff if diff.abs < min_diff.abs
    if diff < 0
      right -= 1
    elsif diff > 0
      left += 1
    end
  end
  min_diff
end

p three_sum_closest [-2, 0, 1, 2], -1
p three_sum_closest [-2, 0, 1, 2], 2
p three_sum_closest [-3, -1, 1, 2], 1
p three_sum_closest [1, 0, 1, 1], 100
p three_sum_closest [1, 1, -1, -1, 3], -1

puts "Triplets count with sum less than target"

def three_sum_smaller(nums, target)
  nums.sort!
  count = 0
  0.upto(nums.length - 3) do |first|
    next if first > 0 && nums[first] == nums[first - 1]
    count += two_sum_smaller(nums, first + 1, target - nums[first])
  end
  count
end

def two_sum_smaller(nums, left, target)
  start, right, count = left, nums.length - 1, 0
  while left < right
    sum = nums[left] + nums[right]
    left_duplicate = left > start && nums[left] == nums[left - 1]
    right_duplicate = right < nums.length - 1 && nums[right] == nums[right + 1]
    if left_duplicate || sum < target
      count += right - left if !left_duplicate
      left += 1
    elsif right_duplicate || sum >= target
      right -= 1
    end
  end
  count
end

p three_sum_smaller [-1, 0, 2, 3], 3
p three_sum_smaller [-1, 4, 2, 1, 3], 5
p three_sum_smaller [-1, 4, 2, 2, 1, 3], 5

puts "Subarrays whose product is less than target"

def subarrays_with_product_less_than_k(nums, target)
  res, product, first = [], 1, 0
  0.upto(nums.length - 1) do |last|
    product *= nums[last]
    while product >= target && first <= last
      product /= nums[first]
      first += 1
    end
    first.upto(last) do |first|
      res << nums[first..last]
    end
  end
  res
end

p subarrays_with_product_less_than_k [2, 5, 3, 10], 30
p subarrays_with_product_less_than_k nums = [10, 5, 2, 6], k = 100
p subarrays_with_product_less_than_k [8, 2, 6, 5], 50

puts "Dutch flag"

def dutch_flag(nums)
  low, current, high = 0, 0, nums.length - 1
  while current < nums.length
    if nums[current].zero?
      nums[current], nums[low] = nums[low], nums[current]
      low += 1
    end
    current += 1
  end
  current -= 1
  while current >= 0 && nums[current] > 0
    if nums[current] == 2
      nums[current], nums[high] = nums[high], nums[current]
      high -= 1
    end
    current -= 1
  end
  nums
end

def dutch_flag(nums)
  low, current, high = 0, 0, nums.length - 1
  while current <= high
    if nums[current].zero?
      nums[current], nums[low] = nums[low], nums[current]
      low += 1
      current += 1
    elsif nums[current] == 2
      nums[current], nums[high] = nums[high], nums[current]
      high -= 1
    else
      current += 1
    end
  end
  nums
end

p dutch_flag [1, 0, 2, 1, 0]
p dutch_flag [2, 2, 0, 1, 2, 0]

puts "Four Sum"

def four_sum(nums, target)
  nums.sort!
  res = []
  0.upto(nums.length - 4) do |idx|
    next if idx > 0 && nums[idx] == nums[idx - 1]
    three_sum(nums, idx + 1, target - nums[idx]).each do |three_sum_res|
      res << [nums[idx]] + three_sum_res
    end
  end
  res
end

def three_sum(nums, start, target)
  res = []
  start.upto(nums.length - 3) do |idx|
    next if idx > start && nums[idx] == nums[idx - 1]
    two_sum(nums, idx + 1, target - nums[idx]).each do |two_sum_res|
      res << [nums[idx]] + two_sum_res
    end
  end
  res
end

def two_sum(nums, start, target)
  first, last, res = start, nums.length - 1, []
  while first < last
    first_duplicate = first > start && nums[first] == nums[first - 1]
    last_duplicate = last < nums.length - 1 && nums[last] == nums[last + 1]
    sum = nums[first] + nums[last]
    if sum < target || first_duplicate
      first += 1
    elsif sum > target || last_duplicate
      last -= 1
    else
      res << [nums[first], nums[last]]
      first += 1
      last -= 1
    end
  end
  res
end

p four_sum [4, 1, 2, -1, 1, -3], 1
p four_sum [2, 0, -1, 1, -2, 2], 2

puts "Check if strings equal with backspaces"

def strings_equal(s, t)
  s_idx, t_idx = s.length - 1, t.length - 1
  while s_idx >= -1 && t_idx >= -1
    s_idx = get_next_idx(s, s_idx)
    t_idx = get_next_idx(t, t_idx)
    if s_idx < 0 && t_idx < 0
      return true
    elsif s_idx < 0 || t_idx < 0 || s[s_idx] != t[t_idx]
      return false
    end
    s_idx -= 1
    t_idx -= 1
  end
end

def get_next_idx(str, idx)
  backspaces = 0
  while idx >= 0
    if str[idx] == "#"
      backspaces += 1
    elsif backspaces > 0
      backspaces -= 1
    else
      break
    end
    idx -= 1
  end
  idx
end

p strings_equal str1 = "xy#z", str2 = "xzz#"
p strings_equal str1 = "xy#z", str2 = "xyz#"
p strings_equal str1 = "xywrrmp", str2 = "xywrrmu#p"
p strings_equal "ab##", "c#d#"
p strings_equal "bxj##tw", "bxo#j##tw"

puts "Minimum window sort"

def min_window_sort(nums)
  left, right = 0, nums.length - 1
  left += 1 while left < nums.length - 1 && nums[left] <= nums[left + 1]
  return 0 if left == nums.length - 1
  right -= 1 while right > 0 && nums[right] >= nums[right - 1]
  min, max = nums[left], nums[left]
  left.upto(right) do |idx|
    min = nums[idx] if min > nums[idx]
    max = nums[idx] if max < nums[idx]
  end
  left -= 1
  right += 1
  left -= 1 while left >= 0 && min < nums[left]
  right += 1 while right < nums.length && max > nums[right]
  right - left - 1
end

p min_window_sort [1, 2, 3, 4, -4, -3, -2, -1]
p min_window_sort [1, 2, 5, 3, 7, 10, 9, 12]

puts "Trapping water"

def max_trapped_water(heights)
  left, right, max_trapped = 0, heights.length - 1, 0
  while left < right
    trapped = [heights[left], heights[right]].min * (right - left)
    max_trapped = trapped if trapped > max_trapped
    if heights[left] == heights[right]
      left += 1
      right -= 1
    elsif heights[left] < heights[right]
      left += 1
    else
      right -= 1
    end
  end
  max_trapped
end

p max_trapped_water [1, 3, 5, 4, 1]
p max_trapped_water [3, 2, 5, 4, 2]
p max_trapped_water [1, 4, 3, 2, 5, 8, 4]
