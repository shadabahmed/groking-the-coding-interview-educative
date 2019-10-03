class TreeNode
  attr_accessor :val, :left, :right, :next

  def initialize(val)
    self.val = val
  end

  def self.create_tree(pre_order)
    return nil if pre_order.empty?
    root = self.new(pre_order.shift)
    left_vals = []
    while !pre_order.empty? && pre_order.first < root.val
      left_vals << pre_order.shift
    end
    root.left = create_tree(left_vals)
    root.right = create_tree(pre_order)
    root
  end

  def print
    max_height = height
    width = (2 ** max_height + 6)
    display = (max_height * 2 - 1).times.collect { " " * (2 ** max_height + 20) }
    queue = [[0, width / 2, self]]
    while !queue.empty?
      row, col, node = queue.shift
      cnt = 0
      node.val.to_s.each_char do |c|
        display[row][col + cnt] = c
        cnt += 1
      end
      if node.left
        display[row + 1][col - (max_height - row + 1)] = "/"
        queue << [row + 2, col - (max_height - row + 1), node.left]
      end
      if node.right
        display[row + 1][col + (max_height - row + 1)] = '\\'
        queue << [row + 2, col + (max_height - row + 1), node.right]
      end
    end
    display.each { |r| puts r }
  end

  def height(root = self)
    return 0 if root.nil?
    1 + [height(root.right), height(root.left)].max
  end
end

puts "Level order traversal"

def get_levels(root)
  res = []
  return res if root.nil?
  queue = [[0, root]]
  while !queue.empty?
    level, node = queue.shift
    res[level] ||= []
    res[level] << node.val
    queue.push([level + 1, node.left]) if node.left
    queue.push([level + 1, node.right]) if node.right
  end
  res
end

p get_levels(TreeNode.create_tree([12, 7, 9, 15, 13, 16]))

def get_levels(root)
  res = []
  return res if root.nil?
  queue = [root]
  while !queue.empty?
    cur_len, cur_level = queue.length, []
    cur_len.times do
      node = queue.shift
      cur_level << node.val
      queue.push(node.left) if node.left
      queue.push(node.right) if node.right
    end
    res.append(cur_level)
  end
  res
end

p get_levels(TreeNode.create_tree([12, 7, 9, 15, 13, 16]))

puts "Get Levels reverse order"

def get_levels_rev(root)
  res = []
  return res if root.nil?
  queue = [root]
  while !queue.empty?
    cur_len, cur_level = queue.length, []
    cur_len.times do
      node = queue.shift
      cur_level << node.val
      queue << node.left if node.left
      queue << node.right if node.right
    end
    res.unshift(cur_level)
  end
  res
end

p get_levels_rev(TreeNode.create_tree([12, 7, 9, 15, 13, 16]))

puts "Zigzag traversal"

def get_levels_zigzag(root)
  res = []
  return res if root.nil?
  queue = [root]
  while !queue.empty?
    cur_len, cur_level = queue.length, []
    cur_len.times do
      node = queue.shift
      if res.length.odd?
        cur_level.unshift(node.val)
      else
        cur_level << node.val
      end
      queue << node.left if node.left
      queue << node.right if node.right
    end
    res << cur_level
  end
  res
end

p get_levels_zigzag(TreeNode.create_tree([12, 7, 9, 15, 13, 16]))

puts "Level averages"

def level_averages(root)
  res = []
  return res if root.nil?
  queue = [root]
  while !queue.empty?
    cur_len, cur_sum = queue.length, 0.0
    cur_len.times do
      node = queue.shift
      cur_sum += node.val
      queue << node.left if node.left
      queue << node.right if node.right
    end
    res << cur_sum / cur_len
  end
  res
end

p level_averages(TreeNode.create_tree([12, 7, 9, 15, 13, 16]))

puts "Minimum depth in a binary tree"

def min_depth(root)
  return 0 if root.nil?
  queue, depth = [root], 1
  while !queue.empty?
    cur_len = queue.size
    cur_len.times do
      node = queue.shift
      return depth if node.left.nil? && node.right.nil?
      queue.push(node.left) if node.left
      queue.push(node.right) if node.right
    end
    depth += 1
  end
end

puts "Level order successor"

def succesor(root, key)
  return nil if root.nil? || key.nil?
  queue = [root]
  while !queue.empty?
    node = queue.shift
    queue << node.left if node.left
    queue << node.right if node.right
    return queue.first if node.val == key
  end
  nil
end

p succesor(TreeNode.create_tree([12, 7, 9, 15, 13, 16]), 15)

puts "Connect to sibling"

def connect_siblings(root)
  return root if root.nil?
  queue = [root]
  while !queue.empty?
    prev, cur_len = nil, queue.size
    cur_len.times do
      node = queue.shift
      prev.next = node if prev
      prev = node
      queue << node.left if node.left
      queue << node.right if node.right
    end
  end
  root
end

connect_siblings(TreeNode.create_tree([12, 7, 9, 15, 13, 16])).print

puts "Connect to sibling"

def connect_all_siblings(root)
  return root if root.nil?
  queue = [root]
  prev = nil
  while !queue.empty?
    node = queue.shift
    prev.next = node if prev
    prev = node
    queue << node.left if node.left
    queue << node.right if node.right
  end
  root
end

p connect_all_siblings(TreeNode.create_tree([12, 7, 9, 15, 13, 16])).next.next.next.next.next.val

puts "Right view of the tree"

def right_view(root)
  queue, res = [root], []
  return res if root.nil?
  while !queue.empty?
    res << queue.last
    queue.size.times do
      node = queue.shift
      prev = node
      queue << node.left if node.left
      queue << node.right if node.right
    end
  end
  res
end

p right_view(TreeNode.create_tree([12, 7, 9, 15, 13, 16])).collect(&:val)

puts "Boundary view of the tree"

def boundary_view(root)
  return [] if root.nil?
  left, right, leaves = [], [], []
  left << root.val
  queue = []
  # set true for the left subtree so we can include it in left boundary when a level has only 1 node
  queue << [true, root.left] if root.left
  queue << [false, root.right] if root.right

  while !queue.empty?
    is_left_edge, left_most = queue.first
    _, right_most = queue.last
    if left_most.left.nil? && left_most.right.nil? && (left_most != right_most || is_left_edge)
      left << left_most.val
    end

    if right_most.left.nil? && right_most.right.nil? && (left_most != right_most || !is_left_edge)
      right.unshift(right_most.val)
    end

    (queue.size - 1).downto(0) do |rem_len|
      is_left_edge, node = queue.shift
      queue << [is_left_edge, node.left] if node.left
      queue << [is_left_edge, node.right] if node.right
      # If leaf node and new nodes added to the left, then put it in result else bump this node to the next level
      if node.left.nil? && node.right.nil?
        if queue.size == rem_len
          leaves << node.val
        else
          queue << [is_left_edge, node]
        end
      end
    end
  end
  left + leaves + right
end

#p boundary_view(TreeNode.create_tree([12, 7, 9, 15, 13, 16]))
p boundary_view(TreeNode.create_tree([5, 3, 2, 1, 4, 6, 7]))

def boundary_view(root)
  left, leaves, right = [], [], []
  queue = [root]
  while !queue.empty?
    left_node, right_node = queue.first, queue.last
    left << left_node.val if !(left_node.left.nil? && left_node.right.nil?)
    right.unshift(right_node.val) if left_node != right_node && !(right_node.left.nil? && right_node.right.nil?)
    nodes_added = false
    queue.length.times do
      node = queue.shift
      if !node.left && !node.right
        if nodes_added
          queue << node
        else
          leaves << node.val
        end
      else
        nodes_added = true
        queue << node.left if node.left
        queue << node.right if node.right
      end
    end
  end
  left + leaves + right
end

TreeNode.create_tree([5, 3, 2, 1, 4, 6, 7]).print
p boundary_view(TreeNode.create_tree([5, 3, 2, 1, 4, 6, 7]))
