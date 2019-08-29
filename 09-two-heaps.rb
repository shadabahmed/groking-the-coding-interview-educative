puts "Two heaps"

class Heap
  attr_accessor :arr, :comparator

  def initialize(&block)
    self.arr = []
    self.comparator = block
  end

  def insert(val)
    self.arr << val
    heapify_up(arr.size - 1)
  end

  def remove_top
    return if empty?
    swap(0, size - 1)
    top = arr.pop
    heapify_down(0)
    top
  end

  def delete(val)
    idx = arr.index(val)
    if idx
      swap(idx, arr.size - 1)
      arr.pop
      if idx < arr.size
        heapify_up(idx)
        heapify_down(idx)
      end
    end
  end

  def replace(val, new_val)
    idx = arr.index(val)
    if idx
      arr[idx] = new_val
      heapify_up(idx)
      heapify_down(idx)
    end
  end

  def top
    return if empty?
    arr[0]
  end

  def empty?
    self.arr.empty?
  end

  def size
    self.arr.size
  end

  private

  def swap(idx1, idx2)
    arr[idx1], arr[idx2] = arr[idx2], arr[idx1]
  end

  def compare(idx1, idx2)
    self.comparator[arr[idx1], arr[idx2]]
  end

  def parent(idx)
    return if idx.zero?
    (idx - 1) / 2
  end

  def left(idx)
    2 * idx + 1
  end

  def right(idx)
    2 * idx + 2
  end

  def heapify_up(idx)
    return if idx.zero?
    parent_idx = parent(idx)
    if compare(idx, parent_idx)
      swap(idx, parent_idx)
      heapify_up(parent_idx)
    end
  end

  def heapify_down(idx)
    return if idx >= size / 2
    top_idx = idx
    left_idx, right_idx = left(idx), right(idx)
    top_idx = left_idx if left_idx < size && compare(left_idx, top_idx)
    top_idx = right_idx if right_idx < size && compare(right_idx, top_idx)

    if top_idx != idx
      swap(idx, top_idx)
      heapify_down(top_idx)
    end
  end
end

puts "Median of a number stream"

class MedianStream
  attr_accessor :min, :max

  def initialize
    self.min = Heap.new { |x, y| x < y }
    self.max = Heap.new { |x, y| x > y }
  end

  def insert(num)
    if max.empty? || num < max.top
      max.insert(num)
    else
      min.insert(num)
    end
    if min.size > max.size
      max.insert(min.remove_top)
    elsif max.size > min.size + 1
      min.insert(max.remove_top)
    end
  end

  def median
    return if max.empty?
    if min.size == max.size
      (min.top + max.top) / 2.0
    else
      max.top
    end
  end
end

ms = MedianStream.new
ms.insert(3)
ms.insert(1)
p ms.median
ms.insert(5)
p ms.median
ms.insert(4)
p ms.median

puts "Median of all k sized windows in an array"

def get_mean(min_heap, max_heap, discarded_set, k)
  total_size = discarded_set.size + k

  while discarded_set.include?(max_heap.top)
    discarded_set.delete(max_heap.remove_top)
    total_size -= 1
  end

  while discarded_set.include?(min_heap.top)
    discarded_set.delete(min_heap.remove_top)
    total_size -= 1
  end

  while max_heap.size > (total_size + 1) / 2
    if discarded_set.include?(max_heap.top)
      discarded_set.delete(max_heap.remove_top)
      total_size -= 1
    else
      min_heap.insert(max_heap.remove_top)
    end
  end

  while max_heap.size < (total_size + 1) / 2
    if discarded_set.include?(min_heap.top)
      discarded_set.delete(min_heap.remove_top)
      total_size -= 1
    else
      max_heap.insert(min_heap.remove_top)
    end
  end
  k.even? ? (min_heap.top + max_heap.top) / 2.0 : max_heap.top
end

def means_of_k_windows(arr, k)
  min_heap = Heap.new { |a, b| a < b }
  max_heap = Heap.new { |a, b| a > b }
  discarded_set, res = Set.new, []
  0.upto(arr.length - 1) do |idx|
    max_heap.insert(arr[idx])
    discarded_set.add(arr[idx - k]) if idx >= k
    res << get_mean(min_heap, max_heap, discarded_set, k) if idx >= k - 1
  end
  res
end

def rebalance_heaps(min_heap, max_heap)
  while min_heap.size > max_heap.size
    max_heap.insert(min_heap.remove_top)
  end
  while max_heap.size > min_heap.size + 1
    min_heap.insert(max_heap.remove_top)
  end
end

def median(min_heap, max_heap, arr)
  if min_heap.size == max_heap.size
    (arr[min_heap.top] + arr[max_heap.top]) / 2.0
  else
    arr[max_heap.top].to_f
  end
end

def means_of_k_windows(nums, k)
  min_heap = Heap.new { |a, b| nums[a] < nums[b] }
  max_heap = Heap.new { |a, b| nums[a] > nums[b] }
  discarded_set, res = Set.new, []
  0.upto(nums.length - 1) do |idx|
    if idx >= k
      max_heap.delete(idx - k)
      min_heap.delete(idx - k)
      rebalance_heaps(min_heap, max_heap)
    end
    if max_heap.empty? || nums[idx] <= nums[max_heap.top]
      max_heap.insert(idx)
    else
      min_heap.insert(idx)
    end
    rebalance_heaps(min_heap, max_heap)
    res << median(min_heap, max_heap, nums) if idx >= k - 1
  end
  res
end

p means_of_k_windows [4, 1, 7, 1, 8, 7, 8, 7, 7, 4], 4

puts "Lazy deletion for window k median"

def means_of_k_windows(nums, k)
  min_heap = Heap.new { |a, b| a < b }
  max_heap = Heap.new { |a, b| a > b }
  discarded, res = Hash.new(0), []

  0.upto(k - 1) do |idx|
    if max_heap.empty? || nums[idx] <= max_heap.top
      max_heap.insert(nums[idx])
    else
      min_heap.insert(nums[idx])
    end
    if min_heap.size > max_heap.size
      max_heap.insert(min_heap.remove_top)
    elsif max_heap.size > min_heap.size + 1
      min_heap.insert(max_heap.remove_top)
    end
  end
  res << (k.even? ? (min_heap.top + max_heap.top) / 2.0 : max_heap.top.to_f)

  k.upto(nums.length - 1) do |idx|
    outgoing, incoming, balance = nums[idx - k], nums[idx], 0
    if outgoing <= max_heap.top
      balance -= 1
    else
      balance += 1
    end
    discarded[outgoing] += 1

    if incoming <= max_heap.top
      max_heap.insert(incoming)
      balance += 1
    else
      min_heap.insert(incoming)
      balance -= 1
    end

    if balance > 0
      min_heap.insert(max_heap.remove_top)
      balance -= 1
    end

    if balance < 0
      max_heap.insert(min_heap.remove_top)
      balance += 1
    end

    while discarded.include?(max_heap.top) && discarded[max_heap.top] > 0
      discarded[max_heap.remove_top] -= 1
    end

    while discarded.include?(min_heap.top) && discarded[min_heap.top] > 0
      discarded[min_heap.remove_top] -= 1
    end

    res << (k.even? ? (min_heap.top + max_heap.top) / 2.0 : max_heap.top.to_f)
  end
  res
end

# p means_of_k_windows [1, 2, -1, 3, 5], 2
# p means_of_k_windows [1, 2, -1, 3, 5], 3
#p means_of_k_windows [1, 3, -1, -3, 5, 3, 6, 7], 3
p means_of_k_windows [4, 1, 7, 1, 8, 7, 8, 7, 7, 4], 4

puts "Maximize project capitals"

def max_capital(capitals, profits, initial_capital, max_projects)
  possible_projects = Heap.new { |a, b| profits[a] > profits[b] }
  remaining_projects = Heap.new { |a, b| capitals[a] < capitals[b] }
  capital = initial_capital
  0.upto(capitals.length - 1) do |idx|
    remaining_projects.insert(idx)
  end
  max_projects.times do
    while !remaining_projects.empty? && capitals[remaining_projects.top] <= capital
      possible_projects.insert(remaining_projects.remove_top)
    end
    break if possible_projects.empty?
    capital += profits[possible_projects.remove_top]
  end
  capital
end

p max_capital [0, 1, 2], [1, 2, 3], 1, 2
p max_capital [0, 1, 2, 3], [1, 2, 3, 5], 0, 3
p max_capital [1, 1, 2, 3], [1, 2, 3, 5], 0, 3

puts "Next interval"

def next_interval(intervals)
  next_intervals = Heap.new { |a, b| intervals[a][0] < intervals[b][0] }
  prev_intervals = Heap.new { |a, b| intervals[a][0] > intervals[b][0] }
  res = []
  0.upto(intervals.length - 1) { |idx| next_intervals.insert(idx) }
  0.upto(intervals.length - 1) do |idx|
    start_time, end_time = intervals[idx]
    while !next_intervals.empty? && (intervals[next_intervals.top][0] < end_time || next_intervals.top == idx)
      prev_intervals.insert(next_intervals.remove_top)
    end

    while !prev_intervals.empty? && intervals[prev_intervals.top][0] >= end_time && prev_intervals.top != idx
      next_intervals.insert(prev_intervals.remove_top)
    end

    res << (next_intervals.top || -1)
  end
  res
end

def next_interval(intervals)
  max_end_time = Heap.new { |a, b| intervals[a][1] > intervals[b][1] }
  max_start_time = Heap.new { |a, b| intervals[a][0] > intervals[b][0] }
  res = [-1] * intervals.length
  0.upto(intervals.length - 1) do |idx|
    max_start_time.insert(idx)
    max_end_time.insert(idx)
  end

  0.upto(intervals.length - 1) do |idx|
    idx = max_end_time.remove_top
    start_time, end_time = intervals[idx]
    if !max_start_time.empty? && intervals[max_start_time.top][0] >= end_time && intervals[max_start_time.top][0] != start_time
      last_top = max_start_time.remove_top
      while !max_start_time.empty? && intervals[max_start_time.top][0] >= end_time && intervals[max_start_time.top][0] != start_time
        last_top = max_start_time.remove_top
      end
      res[idx] = last_top
      max_start_time.insert(last_top)
    end
  end
  res
end

p next_interval [[2, 3], [3, 4], [5, 6]]
p next_interval [[3, 4], [1, 5], [4, 6]]

p next_interval [[2, 2], [3, 3], [4, 4]]
