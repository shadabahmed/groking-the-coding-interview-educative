class Heap
  attr_accessor :comparator, :arr

  def initialize(&comparator)
    self.comparator = comparator
    self.arr = []
  end

  def compare(idx1, idx2)
    self.comparator[arr[idx1], arr[idx2]]
  end

  def swap(idx1, idx2)
    arr[idx1], arr[idx2] = arr[idx2], arr[idx1]
  end

  def insert(val)
    arr << val
    heapify_up(arr.length - 1)
  end

  def top
    return if empty?
    arr.first
  end

  def remove_top
    return if empty?
    swap(0, arr.length - 1)
    top_element = arr.pop
    heapify_down(0)
    top_element
  end

  def empty?
    arr.empty?
  end

  def size
    arr.size
  end

  private

  def parent(idx)
    (idx - 1) / 2
  end

  def left(idx)
    2 * idx + 1
  end

  def right(idx)
    2 * idx + 2
  end

  def heapify_down(idx)
    return if idx > (arr.size / 2)
    top_idx = idx
    left_idx = left(idx)
    right_idx = right(idx)
    top_idx = left_idx if left_idx < arr.length && compare(left_idx, top_idx)
    top_idx = right_idx if right_idx < arr.length && compare(right_idx, top_idx)
    if top_idx != idx
      swap(idx, top_idx)
      heapify_down(top_idx)
    end
  end

  def heapify_up(idx)
    return if idx < 1
    parent_idx = parent(idx)
    if compare(idx, parent_idx)
      swap(idx, parent_idx)
      heapify_up(parent_idx)
    end
  end
end

puts "Merge k sorted lists"

def merge_k_lists(lists)
  pq = Heap.new { |(list1, idx1), (list2, idx2)| list1[idx1] < list2[idx2] }
  res = []
  lists.each { |list| pq.insert([list, 0]) unless list.empty? }
  while !pq.empty?
    list, idx = pq.remove_top
    res << list[idx]
    if idx < list.length - 1
      pq.insert([list, idx + 1])
    end
  end
  res
end

p merge_k_lists [[2, 6, 8], [3, 6, 7], [1, 3, 4]]
p merge_k_lists [[5, 8, 9], [1, 7]]
p merge_k_lists [[-8, -7, -7, -5, 1, 1, 3, 4], [-2], [-10, -10, -7, 0, 1, 3], [2]]

puts "Kth smallest number in a sorted matrix"

def kth_smallest_in_matrix(matrix, k)
  pq, smallest = Heap.new { |(r1, c1), (r2, c2)| matrix[r1][c1] < matrix[r2][c2] }, 0
  0.upto([matrix.first.length - 1, k - 1].min) { |col| pq.insert([0, col]) }
  while k > 0
    min_row, min_col = pq.remove_top
    k -= 1
    smallest = matrix[min_row][min_col]
    pq.insert([min_row + 1, min_col]) if min_row < matrix.length - 1
  end
  smallest
end

p kth_smallest_in_matrix [
                           [1, 5, 9],
                           [10, 11, 13],
                           [12, 13, 15],
                         ], k = 8

puts "Kth smallest number in a sorted matrix with binary search"

def kth_smallest_in_matrix(matrix, k)
  first, last = matrix[0][0], matrix[-1][-1]
  while first < last
    mid = (first + last) / 2
    lesser_count, smaller, larger = get_count_smaller_larger(matrix, mid)
    if lesser_count == k
      return smaller
    elsif lesser_count < k
      first = larger
    else
      last = smaller
    end
  end
  first
end

def get_count_smaller_larger(matrix, target)
  count, row, col = 0, matrix.length - 1, 0
  smaller, larger = matrix[0][0], matrix[-1][-1]
  while row >= 0 && col < matrix.first.length
    if matrix[row][col] > target
      larger = [larger, matrix[row][col]].min
      row -= 1
    else
      smaller = [smaller, matrix[row][col]].max
      count += row + 1
      col += 1
    end
  end
  [count, smaller, larger]
end

p kth_smallest_in_matrix [
                           [1, 5, 9],
                           [10, 11, 13],
                           [12, 13, 15],
                         ], k = 8

puts "Smallest number range"

def smallest_range(lists)
  pq = Heap.new { |(list1, idx1), (list2, idx2)| list1[idx1] < list2[idx2] }
  min_overall, max_overall = -1.0 / 0, 1.0 / 0
  lists.each do |list|
    pq.insert([list, 0])
  end
  while pq.size == lists.length
    min_list, min_idx = pq.remove_top
    min = min_list[min_idx]
    max = pq.arr.collect { |list, idx| list[idx] }.max
    min_overall, max_overall = min, max if max_overall - min_overall > max - min
    pq.insert([min_list, min_idx + 1]) if min_idx < min_list.length - 1
  end
  [min_overall, max_overall]
end

def smallest_range(lists)
  list_indices = {}
  pq = Heap.new { |list1_idx, list2_idx| lists[list1_idx][list_indices[list1_idx]] < lists[list2_idx][list_indices[list2_idx]] }
  min_overall, max_overall = -1.0 / 0, 1.0 / 0
  max = min_overall
  0.upto(lists.length - 1) do |idx|
    list_indices[idx] = 0
    max = lists[idx][0] if lists[idx][0] > max
    pq.insert(idx)
  end

  while pq.size == lists.length
    min_list_idx = pq.remove_top
    min = lists[min_list_idx][list_indices[min_list_idx]]
    min_overall, max_overall = min, max if max_overall - min_overall > max - min
    list_indices[min_list_idx] += 1
    if list_indices[min_list_idx] < lists[min_list_idx].length
      next_num = lists[min_list_idx][list_indices[min_list_idx]]
      max = next_num if next_num > max
      pq.insert(min_list_idx)
    end
  end
  [min_overall, max_overall]
end

p smallest_range [[1, 5, 8], [4, 12], [7, 8, 10]]
p smallest_range [[1, 9], [4, 12], [7, 10, 16]]

puts "K pairs with largest sum"

def k_largest_pairs(list1, list2, k)
  pq = Heap.new { |(idx1, idx2), (idx3, idx4)| list1[idx1] + list2[idx2] > list1[idx3] + list2[idx4] }
  0.upto([list2.length - 1, k - 1].min) { |idx| pq.insert([0, idx]) }
  res = []
  while k > 0 && !pq.empty?
    max_idx1, max_idx2 = pq.remove_top
    res << [list1[max_idx1], list2[max_idx2]]
    k -= 1
    pq.insert([max_idx1 + 1, max_idx2]) if max_idx1 < list1.length - 1
  end
  res
end

p k_largest_pairs [9, 8, 2], [6, 3, 1], 3
p k_largest_pairs [5, 2, 1], [2, -1], 3
