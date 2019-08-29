puts "Merge intervals"

def merge_intervals(intervals)
  res = []
  return res if intervals.empty?
  intervals.sort_by! { |i| i[0] }
  prev_start, prev_end = intervals.shift
  intervals.each do |current_start, current_end|
    if current_start <= prev_end
      prev_end = [prev_end, current_end].max
    else
      res.push([prev_start, prev_end])
      prev_start, prev_end = current_start, current_end
    end
  end
  res.push([prev_start, prev_end])
end

p merge_intervals [[1, 4], [2, 5], [7, 9]]
p merge_intervals [[6, 7], [2, 4], [5, 9]]
p merge_intervals [[1, 4], [2, 6], [3, 5]]

puts "Insert Interval"

def insert_interval(intervals, interval)
  merge_intervals(intervals << interval)
end

def insert_interval(intervals, interval)
  intervals = merge_intervals(intervals)
  res = []
  intervals.each_with_index do |(i_start, i_end), idx|
    if i_end < interval[0]
      res << [i_start, i_end]
    elsif i_start > interval[1]
      res << interval
      return res + intervals[idx..(intervals.length - 1)]
    else
      interval = [[i_start, interval[0]].min, [i_end, interval[1]].max]
    end
  end
  res << interval if res.empty? || res.last[1] < interval[0]
  res
end

p insert_interval [[1, 3], [5, 7], [8, 12]], [4, 6]
p insert_interval [[1, 3], [5, 7], [8, 12]], [4, 10]
p insert_interval [[2, 3], [5, 7]], [1, 4]
p insert_interval [[2, 3], [5, 7]], [-11, 40]
p insert_interval [[2, 5], [6, 7], [8, 9]], [0, 1]

puts "Interval intersection"

def find_intersection(i1, i2)
  res = []
  i1.sort_by! { |i| i[0] }
  i2.sort_by! { |i| i[0] }
  idx1, idx2 = 0, 0
  while idx1 < i1.length && idx2 < i2.length
    if i1[idx1][1] < i2[idx2][0]
      idx1 += 1
    elsif i2[idx2][1] < i1[idx1][0]
      idx2 += 1
    else
      res << [[i1[idx1][0], i2[idx2][0]].max, [i1[idx1][1], i2[idx2][1]].min]
      if i1[idx1][1] > i2[idx2][1]
        idx2 += 1
      else
        idx1 += 1
      end
    end
  end
  res
end

p find_intersection [[1, 3], [5, 6], [7, 9]], [[2, 3], [5, 7]]
p find_intersection arr1 = [[1, 3], [5, 7], [9, 12]], arr2 = [[5, 10]]

puts "Conflicting appointments"

def can_attend_all(appointments)
  appointments.sort_by! { |a| a[0] }
  prev_end = appointments[0][1]
  1.upto(appointments.length - 1) do |idx|
    current_start, current_end = appointments[idx]
    return false if current_start < prev_end
    prev_end = current_end
  end
  true
end

def can_attend_all(appointments)
  appointments.sort_by! { |a| a[0] }
  1.upto(appointments.length - 1) do |idx|
    return false if appointments[idx][0] < appointments[idx - 1][1]
  end
  true
end

p can_attend_all [[1, 4], [2, 5], [7, 9]]
p can_attend_all [[6, 7], [2, 4], [8, 12]]
p can_attend_all [[4, 5], [2, 3], [3, 6]]

puts "Minimum meeting rooms: with segment tree"

class SegmentTree
  class Node < Struct.new(:start, :finish, :val, :left, :right)
  end

  attr_accessor :root

  def initialize(start, finish)
    self.root = Node.new(start, finish, 0)
  end

  def add(start, finish, val, node = root)
    if node.start == start && node.finish == finish
      node.val += val
    else
      mid = (node.start + node.finish) / 2
      node.left ||= Node.new(node.start, mid, 0)
      node.right ||= Node.new(mid, node.finish, 0)
      if finish <= mid
        add(start, finish, val, node.left)
      elsif start >= mid
        add(start, finish, val, node.right)
      else
        add(start, mid, val, node.left)
        add(mid, finish, val, node.right)
      end
    end
  end

  def max_path_to_leaf(node = root)
    return 0 if node.nil?
    node.val + [max_path_to_leaf(node.left), max_path_to_leaf(node.right)].max
  end
end

def minimum_meeting_rooms(intervals)
  return 0 if intervals.empty?
  min, max = 1.0 / 0, -1.0 / 0
  intervals.each do |start, finish|
    min = start if start < min
    max = finish if finish > max
  end
  st = SegmentTree.new(min, max)
  intervals.each do |start, finish|
    st.add(start, finish, 1)
  end
  st.max_path_to_leaf
end

p minimum_meeting_rooms [[1, 4], [2, 5], [7, 9]]
p minimum_meeting_rooms [[6, 7], [2, 4], [8, 12]]
p minimum_meeting_rooms [[1, 4], [2, 3], [3, 6]]
p minimum_meeting_rooms [[4, 5], [2, 3], [2, 4], [3, 5]]

puts "Minimum meeting rooms: with heap"

class Heap
  attr_accessor :arr, :comparator

  def initialize(&comparator)
    self.arr = []
    self.comparator = comparator
  end

  def insert(elem)
    arr << elem
    heapify_up(arr.size - 1)
  end

  def top
    return nil if empty?
    arr.first
  end

  def remove_top
    return nil if empty?
    swap(0, arr.length - 1)
    top = arr.pop
    heapify_down(0)
    top
  end

  def empty?
    arr.empty?
  end

  def size
    arr.size
  end

  private

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

  def swap(idx, swap_idx)
    arr[idx], arr[swap_idx] = arr[swap_idx], arr[idx]
  end

  def heapify_down(idx)
    top_idx = idx
    left_idx = left(top_idx)
    right_idx = right(top_idx)
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

  def heapify_up(idx)
    return if idx.zero?
    parent_idx = parent(idx)
    if compare(idx, parent_idx)
      swap(idx, parent_idx)
      heapify_up(parent_idx)
    end
  end
end

def minimum_meeting_rooms(intervals)
  intervals.sort_by! { |start, _| start }
  min_rooms, heap = 0, Heap.new { |finish1, finish2| finish1 < finish2 }
  intervals.each do |start, finish|
    while heap.top && heap.top <= start
      heap.remove_top
    end
    heap.insert(finish)
    min_rooms = heap.size if heap.size > min_rooms
  end
  min_rooms
end

p minimum_meeting_rooms [[1, 4], [2, 5], [7, 9]]
p minimum_meeting_rooms [[6, 7], [2, 4], [8, 12]]
p minimum_meeting_rooms [[1, 4], [2, 3], [3, 6]]
p minimum_meeting_rooms [[4, 5], [2, 3], [2, 4], [3, 5]]

p minimum_meeting_rooms [[6, 17], [8, 9], [11, 12], [6, 9]]
puts "Maximum cpu load: with segment tree"

def max_cpu_load(loads)
  min_time, max_time = 1.0 / 0, -1.0 / 0
  loads.each do |start, finish, _|
    min_time = start if start < min_time
    max_time = finish if finish > max_time
  end
  sg = SegmentTree.new(min_time, max_time)
  loads.each do |start, finish, load|
    sg.add(start, finish, load)
  end
  sg.max_path_to_leaf
end

p max_cpu_load [[1, 4, 3], [2, 5, 4], [7, 9, 6]]
p max_cpu_load [[6, 7, 10], [2, 4, 11], [8, 12, 15]]
p max_cpu_load [[1, 4, 2], [2, 4, 1], [3, 6, 5]]

puts "Maximum cpu load: with heap"

def max_cpu_load(loads)
  current_load, max_load = 0, 0
  loads.sort_by! { |l| l[0] }
  heap = Heap.new { |(finish1, _), (finish2, _)| finish1 < finish2 }
  loads.each do |start, finish, load|
    while heap.top && heap.top[0] <= start
      current_load -= heap.remove_top[1]
    end
    heap.insert([finish, load])
    current_load += load
    max_load = current_load if current_load > max_load
  end
  max_load
end

p max_cpu_load [[1, 4, 3], [2, 5, 4], [7, 9, 6]]
p max_cpu_load [[6, 7, 10], [2, 4, 11], [8, 12, 15]]
p max_cpu_load [[1, 4, 2], [2, 4, 1], [3, 6, 5]]

puts "Employee free time"

def find_free_times(hours)
  res = []
  start_heap = Heap.new do |(emp_idx1, hours_idx1), (emp_idx2, hours_idx2)|
    hours[emp_idx1][hours_idx1][0] < hours[emp_idx2][hours_idx2][0]
  end
  finish_heap = Heap.new { |finish1, finish2| finish1 < finish2 }

  0.upto(hours.length - 1) do |idx|
    start_heap.insert([idx, 0])
  end

  while !start_heap.empty?
    emp_idx, hours_idx = start_heap.remove_top
    start, finish = hours[emp_idx][hours_idx]
    if hours_idx < hours[emp_idx].length - 1
      start_heap.insert([emp_idx, hours_idx + 1])
    end
    prev_finish = nil
    while finish_heap.top && finish_heap.top <= start
      prev_finish = finish_heap.remove_top
    end
    if prev_finish && finish_heap.empty? && prev_finish != start
      res << [prev_finish, start]
    end
    finish_heap.insert(finish)
  end
  res
end

p find_free_times [[[1, 3], [5, 6]], [[2, 3], [6, 8]]]
p find_free_times [[[1, 3], [9, 12]], [[2, 4]], [[6, 8]]]
p find_free_times [[[1, 3]], [[2, 4]], [[3, 5], [7, 9]]]
