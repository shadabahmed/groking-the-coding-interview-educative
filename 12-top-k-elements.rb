puts "Top k numbers"

class Heap
  attr_accessor :arr, :comparator

  def initialize(&comparator)
    self.comparator = comparator
    self.arr = []
  end

  def size
    arr.size
  end

  def empty?
    arr.empty?
  end

  def insert(val)
    arr << val
    heapify_up(arr.size - 1)
  end

  def top
    return if empty?
    arr.first
  end

  def remove_top
    return if empty?
    swap(0, arr.size - 1)
    top = arr.pop
    heapify_down(0)
    top
  end

  def swap(idx, other_idx)
    arr[idx], arr[other_idx] = arr[other_idx], arr[idx]
  end

  def compare(idx1, idx2)
    self.comparator[arr[idx1], arr[idx2]]
  end

  def parent(idx)
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
    return if idx > arr.length / 2

    top_idx = idx
    left_idx = left(idx)
    right_idx = right(idx)
    if left_idx < arr.size && compare(left_idx, top_idx)
      top_idx = left_idx
    end

    if right_idx < arr.size && compare(right_idx, top_idx)
      top_idx = right_idx
    end

    if top_idx != idx
      swap(idx, top_idx)
      heapify_down(top_idx)
    end
  end
end

puts "With heap"

def top_k_numbers(nums, k)
  pq = Heap.new { |a, b| a < b }
  0.upto(nums.length - 1) do |idx|
    if idx >= k && pq.top < nums[idx]
      pq.remove_top
      pq.insert(nums[idx])
    elsif idx < k
      pq.insert(nums[idx])
    end
  end
  pq.arr
end

p top_k_numbers [3, 1, 5, 12, 2, 11], 3
p top_k_numbers [5, 12, 11, -1, 12], 3

puts "With partitioning"

def partition(nums, pivot = 0, first = 0, last = nums.length - 1)
  nums[pivot], nums[first] = nums[first], nums[pivot]
  low, high, cur = first + 1, last, first + 1
  while cur <= high
    if nums[cur] < nums[first]
      nums[cur], nums[high] = nums[high], nums[cur]
      high -= 1
    elsif nums[cur] > nums[first]
      nums[cur], nums[low] = nums[low], nums[cur]
      low += 1
      cur += 1
    else
      cur += 1
    end
  end
  nums[first], nums[low - 1] = nums[low - 1], nums[first]
  high
end

def top_k_numbers(nums, k, first = 0, last = nums.length - 1)
  return nums[0..first] if first == last
  original_pivot = pivot = partition(nums, first, first, last)
  pivot -= 1 while pivot > k - 1 && nums[pivot] == nums[pivot - 1]
  if pivot == k - 1
    nums[0..pivot]
  elsif k > original_pivot
    top_k_numbers(nums, k, original_pivot + 1, last)
  else
    top_k_numbers(nums, k, first, pivot - 1)
  end
end

p top_k_numbers [3, 1, 5, 12, 2, 11], 3
p top_k_numbers [5, 12, 11, -1, 12], 3

puts "Kth smallest number"

puts "with heap"

def kth_smallest_number(nums, k)
  pq = Heap.new { |a, b| a > b }
  nums.each_with_index do |num, idx|
    if idx < k
      pq.insert(num)
    elsif num < pq.top
      pq.remove_top
      pq.insert(num)
    end
  end
  pq.top
end

p kth_smallest_number [1, 5, 12, 2, 11, 5], 3
p kth_smallest_number [1, 5, 12, 2, 11, 5], 4
p kth_smallest_number [5, 12, 11, -1, 12], 3

puts "with_partitioning"

def partition(nums, pivot = 0, first = 0, last = nums.length - 1)
  nums[pivot], nums[first] = nums[first], nums[pivot]
  low, high, cur = first + 1, last, first + 1
  while cur <= high
    if nums[cur] > nums[first]
      nums[cur], nums[high] = nums[high], nums[cur]
      high -= 1
    elsif nums[cur] < nums[first]
      nums[cur], nums[low] = nums[low], nums[cur]
      low += 1
      cur += 1
    else
      cur += 1
    end
  end
  nums[first], nums[low - 1] = nums[low - 1], nums[first]
  high
end

def kth_smallest_number(nums, k, first = 0, last = nums.length - 1)
  return nums[first] if first == last
  original_pivot = pivot = partition(nums, first, first, last)
  pivot -= 1 while pivot > k - 1 && nums[pivot] == nums[pivot - 1]
  if pivot == k - 1
    nums[pivot]
  elsif k > original_pivot
    kth_smallest_number(nums, k, original_pivot + 1, last)
  else
    kth_smallest_number(nums, k, first, pivot - 1)
  end
end

p kth_smallest_number [1, 5, 12, 2, 11, 5], 3
p kth_smallest_number [1, 5, 12, 2, 11, 5], 4
p kth_smallest_number [5, 12, 11, -1, 12], 3

puts "K closest points to the origin"

def dist(x, y)
  x ** x + y ** y
end

def k_closest_points(points, k)
  pq = Heap.new { |p1, p2| dist(*p1) > dist(*p2) }
  points.each_with_index do |point, idx|
    distance = dist(*point)
    if idx < k
      pq.insert(point)
    elsif distance < dist(*pq.top)
      pq.remove_top
      pq.insert(point)
    end
  end
  pq.arr
end

p k_closest_points(points = [[1, 2], [1, 3]], 1)
p k_closest_points(points = [[1, 3], [3, 4], [2, -1]], 2)

puts "Connecting ropes"

def connect_ropes(ropes)
  pq = Heap.new { |l1, l2| l1 < l2 }
  ropes.each do |r|
    pq.insert(r)
  end
  len = pq.remove_top
  cost = 0
  while !pq.empty?
    len += pq.remove_top
    cost += len
  end
  cost
end

p connect_ropes [1, 3, 11, 5]
p connect_ropes [1, 3, 11, 5, 2]

puts "Top k frequent"

def top_k_frequent_numbers(nums, k)
  freq_map = Hash.new(0)
  nums.each { |num| freq_map[num] += 1 }
  pq = Heap.new { |p, q| freq_map[p] < freq_map[q] }
  nums = freq_map.keys
  0.upto(nums.length - 1) do |idx|
    if idx < k
      pq.insert(nums[idx])
    elsif freq_map[nums[idx]] > freq_map[pq.top]
      pq.remove_top
      pq.insert(nums[idx])
    end
  end
  pq.arr
end

p top_k_frequent_numbers [1, 3, 5, 12, 11, 12, 11], 2
p top_k_frequent_numbers [5, 12, 11, 3, 11], 2
p top_k_frequent_numbers [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5], 2

puts "Frequency sort"

def freq_sort(str)
  freq_map = Hash.new(0)
  str.each_char { |c| freq_map[c] += 1 }
  pq = Heap.new { |c1, c2| freq_map[c1] > freq_map[c2] }
  freq_map.each { |c, _| pq.insert(c) }
  res = ""
  while !pq.empty?
    chr = pq.remove_top
    res << chr * freq_map[chr]
  end
  res
end

p freq_sort "Programming"
p freq_sort "abcbab"

puts "Kth largest in a stream"

def kth_largest_in_stream(nums, k)
  pq = Heap.new { |a, b| a < b }
  nums.each do |num|
    if pq.size < k
      pq.insert(num)
    elsif num > pq.top
      pq.remove_top
      pq.insert(num)
    end
  end
  pq.top
end

p kth_largest_in_stream [3, 1, 5, 12, 2, 11], K = 4

puts "K closest numbers"

def k_closest_numbers(nums, k, x)
  pq = Heap.new { |a, b| (a - x).abs > (b - x).abs }
  nums.each do |num|
    if pq.size < k
      pq.insert(num)
    elsif (num - x).abs < (pq.top - x).abs
      pq.remove_top
      pq.insert(num)
    end
  end
  pq.arr
end

p k_closest_numbers [5, 6, 7, 8, 9], 3, 7
p k_closest_numbers [2, 4, 5, 6, 9], 3, 10

puts "K closest numbers in a sorted array"

def find_closest(arr, target)
  first, last = 0, arr.length - 1
  return 0 if target < arr[0]
  return arr.length - 1 if target > arr[-1]
  while first <= last
    mid = (first + last) / 2
    return mid if arr[mid] == target
    if arr[mid] > target
      last = mid - 1
    else
      first = mid + 1
    end
  end
  (arr[first] - target).abs < (arr[last] - target).abs ? first : last
end

def k_closest_numbers(arr, k, x)
  closest_idx = find_closest(arr, x)
  pq = Heap.new { |a, b| a < b }
  first, last = [0, closest_idx - k].max, [closest_idx + k, arr.length - 1].min
  first.upto(last) do |idx|
    num = arr[idx]
    if pq.size < k
      pq.insert(num)
    elsif (num - x).abs < (pq.top - x).abs
      pq.remove_top
      pq.insert(num)
    end
  end
  pq.arr.sort
end

p k_closest_numbers [5, 6, 7, 8, 9], 3, 7
p k_closest_numbers [2, 4, 5, 6, 9], 3, 10
p k_closest_numbers [1, 2, 2, 2, 5, 5, 5, 8, 9, 9], 4, 0
p k_closest_numbers [0, 0, 1, 2, 3, 3, 4, 7, 7, 8], 3, 5

puts "Maximum distinct numbers"

def max_distinct_numbers(nums, k)
  freq_map = Hash.new(0)
  nums.each { |num| freq_map[num] += 1 }
  pq = Heap.new { |a, b| freq_map[a] < freq_map[b] }
  freq_map.each { |num, freq| pq.insert(num) if freq > 1 }
  while !pq.empty? && k > 0
    lowest_fre_elem = pq.remove_top
    if k >= freq_map[lowest_fre_elem] - 1
      k -= freq_map[lowest_fre_elem] - 1
      freq_map[lowest_fre_elem] = 1
    else
      freq_map[lowest_fre_elem] -= k
      k = 0
    end
  end
  uniq_nums = freq_map.keys.select { |num| freq_map[num] == 1 }
  uniq_nums.slice(0, uniq_nums.length - k)
end

p max_distinct_numbers [7, 3, 5, 8, 5, 3, 3], 2
p max_distinct_numbers [3, 5, 12, 11, 12], 3
p max_distinct_numbers [1, 2, 3, 3, 3, 3, 4, 4, 5, 5, 5], 2

puts "Sum of numbers between k1th and k2th smallest numbers in array"

def sum_between_smallest(nums, k1, k2)
  pq = Heap.new { |a, b| a > b }
  sum = 0
  nums.each do |num|
    if pq.size < k2 - 1
      pq.insert(num)
    elsif num < pq.top
      pq.remove_top
      pq.insert(num)
    end
  end
  sum += pq.remove_top while pq.size > k1
  sum
end

p sum_between_smallest [1, 3, 12, 5, 15, 11], 3, 6
p sum_between_smallest [3, 5, 8, 7], 1, 4

def sum_between_smallest(nums, k1, k2)
  k1_pq = Heap.new { |a, b| a > b }
  k2_pq = Heap.new { |a, b| a > b }
  sum = 0
  nums.each do |num|
    inserted = false
    if k1_pq.size < k1
      inserted = true
      k1_pq.insert(num)
    elsif num < k1_pq.top
      removed_num = k1_pq.remove_top
      k1_pq.insert(num)
      num = removed_num
    end

    next if inserted
    if k2_pq.size < k2 - k1 - 1
      sum += num
      k2_pq.insert(num)
    elsif num < k2_pq.top
      sum += num - k2_pq.remove_top
      k2_pq.insert(num)
    end
  end
  sum
end

p sum_between_smallest [1, 3, 12, 5, 15, 11], 3, 6
p sum_between_smallest [3, 5, 8, 7], 1, 4

puts "Rearrange String"

def rearrange_string(str)
  freq_map = Hash.new(0)
  str.each_char { |c| freq_map[c] += 1 }
  pq = Heap.new { |a, b| freq_map[a] > freq_map[b] }
  freq_map.each { |c, _| pq.insert(c) }
  res = ""
  while !pq.empty?
    most_frequent = pq.remove_top
    if !pq.empty?
      second_most_frequent = pq.remove_top
      res += "#{most_frequent}#{second_most_frequent}" * freq_map[second_most_frequent]
      freq_map[most_frequent] -= freq_map[second_most_frequent]
      freq_map.delete(second_most_frequent)
      if freq_map[most_frequent].zero?
        freq_map.delete(most_frequent)
      else
        pq.insert(most_frequent)
      end
    elsif freq_map[most_frequent] > 1
      return ""
    else
      res += most_frequent
    end
  end
  res
end

p rearrange_string "aappp"
p rearrange_string "Programming"
p rearrange_string "aapa"

puts "Rearrange string k distance apart"

def rearrange_string_k_apart(str, k)
  freq_map, res = Hash.new(0), ""
  str.each_char { |c| freq_map[c] += 1 }
  pq = Heap.new { |a, b| freq_map[a] > freq_map[b] }
  freq_map.each { |c, _| pq.insert(c) }
  queue = []
  while !pq.empty?
    top = pq.remove_top
    res << top
    queue << top
    if queue.size >= k
      first = queue.shift
      if freq_map[first].zero?
        freq_map.delete(first)
      else
        pq.insert(first)
      end
    end
  end
  res.length == str.length ? res : ""
end

p rearrange_string_k_apart "abcdefg", 20
p rearrange_string_k_apart "mmpp", 2
p rearrange_string_k_apart "Programming", 3
p rearrange_string_k_apart "aab", 2
p rearrange_string_k_apart "aappa", 3
p rearrange_string_k_apart s = "aaadbbcc", 2
p rearrange_string_k_apart "aabbcc", 2
p rearrange_string_k_apart "a", 2
p rearrange_string_k_apart "aa", 0

puts "Scheduling tasks"

def schedule_tasks(tasks, k)
  freq_map = Hash.new(0)
  tasks.each { |t| freq_map[t] += 1 }
  pq = Heap.new { |t1, t2| freq_map[t1] > freq_map[t2] }
  freq_map.each { |t, _| pq.insert(t) }
  queue, cycles = [], 0
  while !freq_map.empty?
    if pq.empty?
      queue << nil
    else
      task = pq.remove_top
      freq_map[task] -= 1
      if freq_map[task].zero?
        freq_map.delete(task)
        queue << nil
      else
        queue << task
      end
    end
    if queue.size >= k
      first = queue.shift
      pq.insert(first) if first
    end
    cycles += 1
  end
  cycles
end

p schedule_tasks %w[a a a b c c], 2
p schedule_tasks ["A", "A", "A", "B", "B", "B"], n = 3
p schedule_tasks tasks = ["A", "A", "A", "B", "B", "B"], n = 2

p schedule_tasks tasks = ["A", "A", "A", "B", "B", "B"], n = 50

p schedule_tasks ["A", "A", "A", "A", "A", "A", "B", "C", "D", "E", "F", "G"], 2

def schedule_tasks(tasks, k)
  freq_map = Hash.new(0)
  tasks.each { |t| freq_map[t] += 1 }
  pq = Heap.new { |t1, t2| freq_map[t1] > freq_map[t2] }
  freq_map.each { |t, _| pq.insert(t) }
  cycles = 0
  while !freq_map.empty?
    queue = []
    n = k
    while n > 0 && !pq.empty?
      cycles += 1
      n -= 1
      top_task = pq.remove_top
      freq_map[top_task] -= 1
      if freq_map[top_task].zero?
        freq_map.delete(top_task)
      else
        queue << top_task
      end
    end
    queue.each { |task| pq.insert(task) }
    cycles += n if !freq_map.empty?
  end
  cycles
end

p schedule_tasks %w[a a a b c c], 2
p schedule_tasks ["A", "A", "A", "B", "B", "B"], n = 3
p schedule_tasks tasks = ["A", "A", "A", "B", "B", "B"], n = 2

p schedule_tasks tasks = ["A", "A", "A", "B", "B", "B"], n = 50

p schedule_tasks ["A", "A", "A", "A", "A", "A", "B", "C", "D", "E", "F", "G"], 2

puts "Frequency Stack"

puts "Using single heap"

class FreqStack
  attr_accessor :pq, :freq_map, :counter

  def initialize()
    self.pq = Heap.new do |(_, freq1, counter1), (_, freq2, counter2)|
      if freq1 == freq2
        counter1 > counter2
      else
        freq1 > freq2
      end
    end
    self.counter = 0
    self.freq_map = Hash.new(0)
  end

  def push(num)
    self.freq_map[num] += 1
    self.counter += 1
    pq.insert([num, freq_map[num], self.counter])
  end

  def pop
    num, freq, _ = pq.remove_top
    freq_map[num] -= 1
    num
  end
end

fq = FreqStack.new

input = ["FreqStack", "push", "push", "push", "push", "push", "push", "pop", "pop", "pop", "pop"]
input_vals = [[], [5], [7], [5], [7], [4], [5], [], [], [], []]
outputs = [nil, nil, nil, nil, nil, nil, nil, 5, 7, 5, 4]
1.upto(input.length - 1) do |idx|
  if input[idx] == "push"
    fq.push(input_vals[idx][0])
  else
    puts fq.pop
  end
end

puts "Using linked lists for each freq"

class FreqStack
  class ListNode < Struct.new(:val, :freq, :prev, :next)
  end

  attr_accessor :node_map, :pq, :node_lists

  def initialize
    self.node_map = {}
    self.node_lists = {}
    self.pq = Heap.new { |a, b| a > b }
  end

  def push(num)
    self.node_map[num] ||= ListNode.new(num, 0)
    node = self.node_map[num]
    remove_from_list(node)
    node.freq += 1
    if pq.empty? || pq.top < node.freq
      pq.insert(node.freq)
    end
    append_to_tail(node)
  end

  def pop
    top_freq = pq.top
    if node_lists[top_freq].prev
      node = node_lists[top_freq].prev
      remove_from_list(node_lists[top_freq].prev)
      node.freq -= 1
      append_to_tail(node) if node.freq > 0
      if !node_lists[top_freq].prev
        node_lists.delete(top_freq)
        pq.remove_top
      end
      return node.val
    end
  end

  private

  def remove_from_list(node)
    if node.next
      node.next.prev = node.prev
      node.prev.next = node.next if node.prev
    end
    node.next = nil
    node.prev = nil
  end

  def append_to_tail(node)
    freq = node.freq
    node_lists[freq] ||= ListNode.new
    tail = node_lists[freq]

    node.prev = tail.prev
    tail.prev.next = node if tail.prev

    node.next = tail
    tail.prev = node
  end
end

class FreqStack
  attr_accessor :freq_map, :freq_stacks

  def initialize()
    self.freq_map = Hash.new(0)
    self.freq_stacks = {}
  end

  def push(num)
    freq_map[num] += 1
    freq_stacks[freq_map[num]] ||= []
    freq_stacks[freq_map[num]].push(num)
  end

  def pop
    top_frequency = freq_stacks.length
    num = freq_stacks[top_frequency].pop
    freq_map[num] -= 1
    if freq_stacks[top_frequency].empty?
      freq_stacks.delete(top_frequency)
    end
    num
  end
end

fq = FreqStack.new

input = ["FreqStack", "push", "push", "push", "push", "push", "push", "pop", "pop", "pop", "pop"]
input_vals = [[], [5], [7], [5], [7], [4], [5], [], [], [], []]
outputs = [nil, nil, nil, nil, nil, nil, nil, 5, 7, 5, 4]
1.upto(input.length - 1) do |idx|
  if input[idx] == "push"
    fq.push(input_vals[idx][0])
  else
    puts fq.pop
  end
end
