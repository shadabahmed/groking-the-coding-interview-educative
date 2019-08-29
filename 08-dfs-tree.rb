class TreeNode
  attr_accessor :val, :left, :right, :next

  def initialize(val)
    self.val = val
  end

  def self.create_tree(pre_order, idx = 0)
    return nil if idx >= pre_order.length || pre_order[idx].nil?
    root = new(pre_order[idx])
    root.left = create_tree(pre_order, idx * 2 + 1)
    root.right = create_tree(pre_order, idx * 2 + 2)
    root
  end
end

puts "Find if tree has path with sum = k"

def has_path(root, k)
  return false if root.nil?
  return true if root.val == k && root.right.nil? && root.left.nil?
  has_path(root.left, k - root.val) || has_path(root.right, k - root.val)
end

puts "Find all paths with sum"

def find_paths(root, sum)
  return 0 if root.nil?
  if root.val == sum && root.left.nil? && root.right.nil?
    return 1
  else
    find_paths(root.left, sum - root.val) + find_paths(root.right, sum - root.val)
  end
end

def find_paths(root, sum, path = [], res = [])
  return res if root.nil?
  path << root.val
  if root.val == sum && root.left.nil? && root.right.nil?
    res << path.clone
  else
    find_paths(root.left, sum - root.val, path, res) + find_paths(root.right, sum - root.val, path, res)
  end
  path.pop
  res
end

p find_paths(TreeNode.create_tree([1, 7, 9, 4, 5, 2, 7]), 12)
p find_paths(TreeNode.create_tree([12, 7, 1, nil, 4, 10, 5]), 23)

puts "Find path with max sum"

def find_paths(root, cur_path = [], max_path = [])
  return max_path if root.nil?
  cur_path << root.val
  if cur_path.sum > max_path.sum && root.left.nil? && root.right.nil?
    max_path = cur_path.clone
  else
    max_path = find_paths(root.left, cur_path, max_path)
    max_path = find_paths(root.right, cur_path, max_path)
  end
  cur_path.pop
  max_path
end

p find_paths(TreeNode.create_tree([1, 7, 9, 4, 5, 2, 7]))
p find_paths(TreeNode.create_tree([12, 7, 1, nil, 4, 10, 5]))

puts "Sum of path numbers"

def sum_of_path_numbers(root, prev = 0)
  return 0 if root.nil?
  num = prev * 10 + root.val
  if root.left.nil? && root.right.nil?
    return num
  else
    sum_of_path_numbers(root.left, num) + sum_of_path_numbers(root.right, num)
  end
end

p sum_of_path_numbers(TreeNode.create_tree([1, 7, 9, nil, nil, 2, 9]))

puts "Path as given sequence"

def has_path_with_sequence(root, sequence, idx = 0)
  return idx == sequence.length if root.nil?
  return false if root.val != sequence[idx]
  has_path_with_sequence(root.left, sequence, idx + 1) || has_path_with_sequence(root.right, sequence, idx + 1)
end

p has_path_with_sequence(TreeNode.create_tree([1, 7, 9, nil, nil, 2, 9]), [1, 9, 9])
p has_path_with_sequence(TreeNode.create_tree([1, 0, 1, nil, 1, 6, 5]), [1, 0, 7])
p has_path_with_sequence(TreeNode.create_tree([1, 0, 1, nil, 1, 6, 5]), [1, 1, 6])

puts "Count all paths"

def count_paths_with_sum(root, sum, cur_path = [])
  return 0 if root.nil?
  cur_path.push(root.val)
  count = 0
  if root.left.nil? && root.right.nil?
    count = windows_with_sum(cur_path, sum)
  else
    count = count_paths_with_sum(root.left, sum, cur_path) + count_paths_with_sum(root.right, sum, cur_path)
  end
  cur_path.pop
  return count
end

def windows_with_sum(nums, sum)
  first, last, current_sum, count = 0, 0, 0, 0
  while first < nums.length
    if current_sum < sum && last < nums.length
      current_sum += nums[last]
      last += 1
    else
      count += 1 if current_sum == sum
      current_sum -= nums[first]
      first += 1
    end
  end
  count
end

def count_paths_with_sum(root, sum, cur_path = [])
  return 0 if root.nil?
  cur_path.push(root.val)
  count, cur_sum = 0, 0
  (cur_path.length - 1).downto(0) do |idx|
    cur_sum += cur_path[idx]
    count += 1 if cur_sum == sum
  end
  count += count_paths_with_sum(root.left, sum, cur_path)
  count += count_paths_with_sum(root.right, sum, cur_path)
  cur_path.pop
  return count
end

p count_paths_with_sum(TreeNode.create_tree([1, 7, 9, 6, 5, 2, 3]), 12)
p count_paths_with_sum(TreeNode.create_tree([12, 7, 1, nil, 4, 10, 5]), 11)

puts "Tree Diameter"

def tree_diameter_helper(root)
  return [0, 0] if root.nil?
  left_dia, left_depth = tree_diameter_helper(root.left)
  right_dia, right_depth = tree_diameter_helper(root.right)
  cur_dia, cur_depth = left_depth + right_depth + 1, [right_depth, left_depth].max + 1
  if left_dia > cur_dia
    [left_dia, cur_depth]
  elsif right_dia > cur_dia
    [right_dia, cur_depth]
  else
    [cur_dia, cur_depth]
  end
end

p tree_diameter_helper(TreeNode.create_tree([1, 2, 3, nil, 4, 5, 6]))
p tree_diameter_helper(TreeNode.create_tree([1, 2, 3, nil, nil, 5, 6, nil, nil, nil, nil, 7, 8, 9, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, 11]))

puts "Max path sum"

def max_path_sum(root)
  return [0, 0] if root.nil?
  sum_at_left, left_max_sum = max_path_sum(root.left)
  sum_at_right, right_max_sum = max_path_sum(root.right)
  cur_max_sum, cur_path_sum = left_max_sum + right_max_sum + root.val, root.val + [left_max_sum, right_max_sum].max
  cur_max_sum = sum_at_left if sum_at_left > cur_max_sum
  cur_max_sum = sum_at_right if sum_at_right > cur_max_sum
  [cur_max_sum, cur_path_sum]
end

p max_path_sum(TreeNode.create_tree([1, 2, 3, nil, 4, 5, 6]))

class Solution
  attr_accessor :max_sum

  def initialize
    self.max_sum = -1.0 / 0
  end

  def result(root)
    max_path_sum(root)
    self.max_sum
  end

  private

  def max_path_sum(root)
    return 0 if root.nil?
    left_path_sum = max_path_sum(root.left)
    right_path_sum = max_path_sum(root.right)
    cur_sum = root.val + left_path_sum + right_path_sum
    self.max_sum = cur_sum if cur_sum > self.max_sum
    root.val + [left_path_sum, right_path_sum].max
  end
end

p Solution.new.result(TreeNode.create_tree([1, 2, 3, nil, 4, 5, 6]))
