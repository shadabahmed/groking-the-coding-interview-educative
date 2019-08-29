puts "Search in sorted array - order agnostic"

def search(nums, key)
  first, last = 0, nums.length - 1
  while first <= last
    mid = (first + last) / 2
    return mid if nums[mid] == key
    if nums[0] < nums[-1] && key > nums[mid] || nums[0] > nums[-1] && key < nums[mid]
      first = mid + 1
    else
      last = mid - 1
    end
  end
  -1
end

p search [4, 6, 10], 10
p search [10, 6, 4], 4

puts "Ceiling"

def ceiling(nums, key)
  first, last = 0, nums.length - 1
  while first < last
    mid = (first + last) / 2
    if nums[mid] < key
      first = mid + 1
    else
      last = mid
    end
  end
  nums[first] >= key ? first : -1
end

p ceiling [4, 6, 10], 6
p ceiling [1, 3, 8, 10, 15], key = 12
p ceiling [4, 6, 10], 17

puts "Floor"

def floor(nums, key)
  first, last = 0, nums.length - 1
  return -1 if nums[0] > key
  while first <= last
    mid = (first + last) / 2
    if nums[mid] > key
      last = mid - 1
    elsif nums[mid] < key
      first = mid + 1
    else
      return mid
    end
  end
  last
end

def floor(nums, key)
  first, last = 0, nums.length - 1
  while first < last
    mid = (first + last + 1) / 2
    if nums[mid] > key
      last = mid - 1
    else
      first = mid
    end
  end
  nums[first] <= key ? first : -1
end

p floor [4, 6, 10], 6
p floor [1, 3, 8, 10, 15], key = 12
p floor [4, 6, 10], 17

puts "First Letter"

def first_letter(chars, key)
  first, last = 0, chars.length - 1
  while first <= last
    mid = (first + last) / 2
    if chars[mid].ord <= key.ord
      first = mid + 1
    else
      last = mid - 1
    end
  end
  chars[first % chars.length]
end

p first_letter ["a", "c", "f", "h"], key = "f"
p first_letter ["a", "c", "f", "h"], key = "b"
p first_letter ["a", "c", "f", "h"], key = "m"
p first_letter ["a", "c", "f", "h"], key = "h"

puts "number range"

def number_range(nums, key)
  first, last = 0, nums.length - 1
  while first <= last
    mid = (first + last) / 2
    if nums[mid] > key
      first = mid + 1
    elsif nums[mid] < key
      last = mid - 1
    else
      break
    end
  end
  return [-1, -1] if first > last
  first, last = (first + last) / 2, (first + last) / 2
  first -= 1 while first >= 0 && nums[first] == key
  last += 1 while last < nums.length && nums[last] == key
  [first + 1, last - 1]
end

def number_range(nums, key)
  [bin_search_idx(nums, key, false), bin_search_idx(nums, key, true)]
end

def bin_search_idx(nums, key, find_max_idx = true)
  first, last = 0, nums.length - 1
  key_index = -1
  while first <= last
    mid = (last + first) / 2
    if nums[mid] > key
      last = mid - 1
    elsif nums[mid] < key
      first = mid + 1
    else
      key_index = mid
      if find_max_idx
        first = mid + 1
      else
        last = mid - 1
      end
    end
  end
  key_index
end

p number_range [4, 6, 6, 6, 9], key = 6
p number_range [1, 3, 8, 10, 15], 10
p number_range [1, 3, 8, 10, 15], 12

puts "Find in infinite sorted array"

def find_in_infinite_array(arr, key)
  last = 1
  last *= 2 while arr[last - 1] < key
  first = 0
  while first <= last
    mid = (first + last) / 2
    return mid if arr[mid] == key
    if arr[mid] > key
      last = mid - 1
    else
      first = mid + 1
    end
  end
  -1
end

p find_in_infinite_array [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30], key = 16

puts "Element with minimum diff"

def min_diff(nums, key)
  first, last = 0, nums.length - 1
  while first < last
    mid = (first + last) / 2
    diff = (nums[mid] - key).abs
    return nums[mid] if diff.zero?
    if (nums[mid + 1] - key).abs > diff
      last = mid
    else
      first = first + 1
    end
  end
  nums[first]
end

def min_diff(nums, key)
  first, last = 0, nums.length - 1
  while first <= last
    mid = (first + last) / 2
    if nums[mid] < key
      first = mid + 1
    elsif nums[mid] > key
      last = mid - 1
    else
      return nums[mid]
    end
  end
  first_diff = first < nums.length ? nums[first] : 1.0 / 0
  last_diff = last >= 0 ? nums[last] : 1.0 / 0
  [last_diff, first_diff].min
end

p min_diff [4, 6, 10], 7
p min_diff [4, 6, 10], key = 4
p min_diff [1, 3, 8, 10, 15], key = 12
p min_diff [4, 6, 10], key = 17

puts "Max in bitonic array"

def max_in_bitonic(nums)
  first, last = 0, nums.length - 1
  while first < last
    mid = (first + last) / 2
    if nums[mid] < nums[mid + 1]
      first = mid + 1
    elsif nums[mid] > nums[mid + 1]
      last = mid
    end
  end
  nums[first]
end

p max_in_bitonic [1, 3, 8, 12, 4, 2]
p max_in_bitonic [3, 8, 3, 1]
p max_in_bitonic [1, 3, 8, 12]
p max_in_bitonic [10, 9, 8]

puts "Search in bitonic"

def search_in_bitonic(arr, key)
  first, last = 0, arr.length - 1
  while first < last
    mid = (first + last) / 2
    if arr[mid] > arr[mid + 1]
      last = mid
    else
      first = mid + 1
    end
  end
  left_idx = bin_search(arr, 0, mid, key)
  return left_idx if left_idx >= 0
  bin_search(arr, mid + 1, arr.length - 1, key, true)
end

def bin_search(arr, first, last, key, descending = false)
  while first <= last
    mid = (first + last) / 2
    return mid if arr[mid] == key
    if (!descending && arr[mid] > key) || (descending && arr[mid] < key)
      last = mid - 1
    else
      first = mid + 1
    end
  end
  -1
end

p search_in_bitonic [1, 3, 8, 4, 3], key = 4
p search_in_bitonic [3, 8, 3, 1], key = 8
p search_in_bitonic [1, 3, 8, 12], key = 12
p search_in_bitonic [10, 9, 8], key = 10

puts "Search in rotated array"

def search_in_rotated(arr, key)
  first, last = 0, arr.length - 1
  while first < last
    mid = (first + last) / 2
    if arr[mid] > arr[mid + 1]
      first = last = mid
    elsif arr[mid] >= arr[first]
      if arr[mid] == arr[first] && arr[mid] == arr[last]
        first += 1
        last -= 1
      else
        first = mid + 1
      end
    else
      last = mid - 1
    end
  end
  left_idx = bin_search(arr, 0, first, key)
  return left_idx if left_idx >= 0
  bin_search(arr, first + 1, arr.length - 1, key)
end

def search_in_rotated(arr, key)
  first, last = 0, arr.length - 1
  while first <= last
    mid = (first + last) / 2
    return mid if arr[mid] == key
    if arr[mid] == arr[last] && arr[mid] == arr[first]
      last -= 1
      first += 1
    elsif arr[mid] >= arr[first]
      if (arr[first]..arr[mid]).include?(key)
        last = mid - 1
      else
        first = mid + 1
      end
    elsif arr[last] >= arr[mid]
      if (arr[mid]..arr[last]).include?(key)
        first = mid + 1
      else
        last = mid - 1
      end
    end
  end
  -1
end

p search_in_rotated [10, 15, 1, 3, 8], 15
p search_in_rotated [4, 5, 7, 9, 10, -1, 2], key = 10
p search_in_rotated [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], key = 10
p search_in_rotated [1, 1, 1, 1, 0, 1, 1, 1, 1], 0

puts "Rotation count"

def rotation_count(arr)
  first, last = 0, arr.length - 1
  while first < last
    mid = (first + last) / 2
    return mid + 1 if arr[mid] > arr[mid + 1]
    if arr[mid] > arr[last]
      first = mid + 1
    else
      last = mid
    end
  end
  first
end

p rotation_count [10, 15, 1, 3, 8]
p rotation_count [4, 5, 7, 9, 10, -1, 2]
