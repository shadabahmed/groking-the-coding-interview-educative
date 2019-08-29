puts "Cyclic Sort"

def sort(nums)
  0.upto(nums.length - 1) do |idx|
    if nums[idx] != idx + 1
      other_idx = nums[idx] - 1
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    end
  end
  nums
end

p sort [3, 1, 5, 4, 2]
p sort [2, 6, 4, 3, 1, 5]

puts "Missing number"

def find_missing_number(nums)
  idx = 0
  while idx < nums.length
    other_idx = nums[idx]
    if nums[idx] < nums.length && nums[idx] != idx
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    else
      idx += 1
    end
  end
  nums.each_with_index do |idx, num|
    return num if num != idx
  end
  nums.length
end

p find_missing_number [4, 0, 3, 1]
p find_missing_number [8, 3, 5, 2, 4, 6, 0, 1]

puts "Find all missing numbers"

def find_missing_numbers(nums)
  idx = 0
  while idx < nums.length
    other_idx = nums[idx] - 1
    if nums[other_idx] != nums[idx]
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    else
      idx += 1
    end
  end
  1.upto(nums.length).select { |num| nums[num - 1] != num }
end

p find_missing_numbers [2, 4, 1, 2]
p find_missing_numbers [2, 3, 1, 8, 2, 3, 5, 1]
p find_missing_numbers [2, 3, 2, 1]

puts "Find duplicate number"

def find_duplicate_number(nums)
  idx = 0
  while idx < nums.length
    other_idx = nums[idx] - 1
    if idx != other_idx
      return nums[other_idx] if nums[other_idx] == nums[idx]
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    end
    idx += 1
  end
  nums
end

def find_duplicate(nums)
  slow, fast = 0, nums[0]
  while slow != fast
    slow = nums[slow]
    fast = nums[nums[fast]]
  end
  slow_nxt = nums[slow]
  len = 1
  while slow_nxt != slow
    len += 1
    slow_nxt = nums[slow_nxt]
  end
  ptr1 = nums[0]
  len.times { ptr1 = nums[ptr1] }
  slow = nums[0]
  while ptr1 != slow
    slow = nums[slow]
    ptr1 = nums[ptr1]
  end
  ptr1
end

p find_duplicate_number [1, 4, 4, 3, 2]
p find_duplicate_number [2, 1, 3, 3, 5, 4]

puts "Find duplicate numbers"

def find_duplicates(nums)
  res, idx = [], 0
  while idx < nums.length
    other_idx = nums[idx] - 1
    if nums[idx] != idx + 1
      if nums[other_idx] == nums[idx]
        res << nums[idx]
        idx += 1
      else
        nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
      end
    else
      idx += 1
    end
  end
  res
end

def find_duplicates(nums)
  res, idx = [], 0
  while idx < nums.length
    other_idx = nums[idx] - 1
    if nums[idx] != nums[other_idx]
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    else
      idx += 1
    end
  end
  0.upto(nums.length - 1) do |idx|
    res << nums[idx] if nums[idx] != idx + 1
  end
  res
end

p find_duplicates [3, 4, 4, 5, 5]
p find_duplicates [5, 4, 7, 2, 3, 5, 3]

puts "Corrupt Pair"

def corrupt_pair(nums)
  idx = 0
  while idx < nums.length
    other_idx = nums[idx] - 1
    if nums[other_idx] != nums[idx]
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    else
      idx += 1
    end
  end
  0.upto(nums.length - 1) do |idx|
    next if nums[idx] == idx + 1
    return [nums[idx], idx + 1]
  end
  [-1, -1]
end

p corrupt_pair [3, 1, 2, 5, 2]
p corrupt_pair [3, 1, 2, 3, 6, 4]

puts "Find smallest missing positive number"

def smallest_positive_missing_number(nums)
  idx = 0
  while idx < nums.length
    other_idx = nums[idx] - 1
    if other_idx < nums.length && other_idx >= 0 && nums[other_idx] != nums[idx]
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    else
      idx += 1
    end
  end
  1.upto(nums.length) do |num|
    return num if nums[num - 1] != num
  end
  nums.length + 1
end

p smallest_positive_missing_number [-3, 1, 5, 4, 2]
p smallest_positive_missing_number [3, -2, 0, 1, 2]
p smallest_positive_missing_number [3, 2, 5, 1]

puts "Find first k missing numbers"

def find_first_k_missing(nums, k)
  next_k_nums, idx = [], 0
  res = []
  while idx < nums.length
    other_idx = nums[idx] - 1
    if other_idx >= 0 && other_idx < nums.length && nums[other_idx] != nums[idx]
      nums[idx], nums[other_idx] = nums[other_idx], nums[idx]
    else
      if other_idx >= nums.length && other_idx < nums.length + k && next_k_nums[other_idx - nums.length] != nums[idx]
        next_k_nums[other_idx - nums.length] = nums[idx]
      end
      idx += 1
    end
  end
  1.upto(nums.length + k) do |num|
    if num <= nums.length && nums[num - 1] != num || num > nums.length && next_k_nums[num - nums.length - 1] != num
      res << num
    end
    break if res.length == k
  end
  res
end

p find_first_k_missing [3, -1, 4, 5, 6], 3
p find_first_k_missing [2, 3, 4], 3
p find_first_k_missing [-2, -3, 4], 2
