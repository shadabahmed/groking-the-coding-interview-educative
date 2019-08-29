puts "All distinct subsets"

def all_subsets(nums, idx = 0, set = [], res = [])
  return res.push(set.clone) if idx >= nums.length
  set.push(nums[idx])
  all_subsets(nums, idx + 1, set, res)
  set.pop
  all_subsets(nums, idx + 1, set, res)
  res
end

def all_subsets(nums)
  subsets = [[]]
  nums.each do |num|
    0.upto(subsets.size - 1) do |idx|
      subsets << subsets[idx] + [num]
    end
  end
  subsets
end

p all_subsets [1, 3]
p all_subsets [1, 5, 3]
p all_subsets [1, 5, 5, 3]

puts "Subsets with duplicate numbers"

def all_subsets(nums)
  subsets, idx = [[]], 0
  while idx < nums.length
    next_idx = idx
    next_idx += 1 while next_idx < nums.length && nums[next_idx] == nums[idx]
    subsets_len = subsets.length
    idx.upto(next_idx - 1) do |last_idx|
      0.upto(subsets_len - 1) do |subset_idx|
        subsets << subsets[subset_idx] + nums[idx..last_idx]
      end
    end
    idx = next_idx
  end
  subsets
end

def all_subsets(nums)
  subsets, idx, last_start = [[]], 0, 0
  0.upto(nums.length - 1) do |idx|
    start_idx = idx > 0 && nums[idx] == nums[idx - 1] ? last_start : 0
    last_start = subsets.length
    start_idx.upto(subsets.length - 1) do |subset_idx|
      subsets << [nums[idx]] + subsets[subset_idx]
    end
  end
  subsets
end

p all_subsets([1, 3, 3]) == [[], [1], [3], [1, 3], [3, 3], [1, 3, 3]]
p all_subsets([1, 5, 3, 3])
p [[], [1], [5], [3], [1, 5], [1, 3], [5, 3], [1, 5, 3], [3, 3], [1, 3, 3], [3, 3, 5], [1, 5, 3, 3]]

puts "Permutations"

def permutations(nums, res = [], idx = 0)
  return res.push(nums.clone) if idx >= nums.length
  idx.upto(nums.length - 1) do |swap_idx|
    nums[idx], nums[swap_idx] = nums[swap_idx], nums[idx]
    permutations(nums, res, idx + 1)
    nums[idx], nums[swap_idx] = nums[swap_idx], nums[idx]
  end
  res
end

p permutations [1, 2, 3]

def permutations(nums)
  res = [[]]
  nums.each do |num|
    len = res.length
    len.times do
      perm = res.shift << num
      0.upto(perm.length - 1) do |swap_idx|
        perm[perm.length - 1], perm[swap_idx] = perm[swap_idx], perm[perm.length - 1]
        res << perm.clone
        perm[perm.length - 1], perm[swap_idx] = perm[swap_idx], perm[perm.length - 1]
      end
    end
  end
  res
end

p permutations [1, 2, 3]

puts "String case change"

def case_change_permutations(str)
  res = [str.clone]
  0.upto(str.length - 1) do |idx|
    ord = str[idx].ord
    next if !(65..90).include?(ord) && !(97..122).include?(ord)
    0.upto(res.length - 1) do |str_idx|
      cur_str = res[str_idx].clone
      if ord > 90
        cur_str[idx] = (str[idx].ord - 32).chr
      else
        cur_str[idx] = (str[idx].ord + 32).chr
      end
      res << cur_str
    end
  end
  res
end

p case_change_permutations "ad52"

puts "Balanced Parenthesis"

def balanced_parens(pairs)
  res = [""]
  pairs.times do
    res.length.times do
      prev = res.shift + "()"
      0.upto(prev.length - 2) do |swap_idx|
        next if swap_idx < prev.length - 2 && prev[swap_idx] == prev[prev.length - 2]
        prev[swap_idx], prev[prev.length - 2] = prev[prev.length - 2], prev[swap_idx]
        res << prev.clone
        prev[swap_idx], prev[prev.length - 2] = prev[prev.length - 2], prev[swap_idx]
      end
    end
  end
  res
end

def balanced_parens(pairs)
  res = [["", 0, 0]]
  (pairs * 2).times do
    res.length.times do
      prev, open_count, closed_count = res.shift
      res << [prev + "(", open_count + 1, closed_count] if open_count < pairs && open_count >= closed_count
      res << [prev + ")", open_count, closed_count + 1] if closed_count < pairs
    end
  end
  res.collect(&:first)
end

p balanced_parens 3

def balanced_parens(pairs, balance = 0, stack = [], res = [])
  return res.push(stack.join) if pairs.zero? && balance.zero?
  return res if pairs.zero? || balance < 0
  stack.push("(")
  balanced_parens(pairs - 0.5, balance + 1, stack, res)
  stack.pop
  stack.push(")")
  balanced_parens(pairs - 0.5, balance - 1, stack, res)
  stack.pop
  res
end

p balanced_parens 3

puts "Generalized abbreviations"

def abbreviations(str)
  res = [""]
  str.each_char do |c|
    res.length.times do
      prev = res.shift
      res << prev + c
      res << get_next(prev)
    end
  end
  res
end

def get_next(str)
  return "#{str}1" if str.empty? || !(48..57).include?(str[-1].ord)
  idx, num, multiplier = str.length - 1, 0, 1
  while idx >= 0 && (48..57).include?(str[idx].ord)
    num = (str[idx].ord - 48) * multiplier + num
    multiplier *= 10
    idx -= 1
  end
  if idx >= 0
    str[0..idx] + (num + 1).to_s
  else
    (num + 1).to_s
  end
end

p abbreviations "BAT"
p abbreviations "code"

def abbreviations(str, idx = 0, stack = [], res = [])
  return res.push(stack.join) if idx >= str.length
  stack.push(str[idx])
  abbreviations(str, idx + 1, stack, res)
  stack.pop
  if stack.last.is_a?(Numeric)
    stack.push(stack.pop + 1)
    abbreviations(str, idx + 1, stack, res)
  else
    stack.push(1)
    abbreviations(str, idx + 1, stack, res)
    stack.pop
  end
  res
end

p abbreviations "BAT"

puts "Evaluate Expressions"

def evaluate_expr(expr, first = 0, last = expr.length - 1, cache = {})
  return cache[first..last] if cache.key?(first..last)
  if first.upto(last).all? { |idx| (48..57).include?(expr[idx].ord) }
    res = [expr[first..last].to_i]
  else
    res = []
    first.upto(last) do |idx|
      next if (48..57).include?(expr[idx].ord)
      left_parts = evaluate_expr(expr, first, idx - 1, cache)
      right_parts = evaluate_expr(expr, idx + 1, last, cache)
      left_parts.each do |left|
        right_parts.each do |right|
          res << left.send(expr[idx].to_sym, right)
        end
      end
    end
  end
  cache[first..last] = res
end

p evaluate_expr "1+2*3"
p evaluate_expr "2*3-4-5"

puts "Count BSTs"

class TreeNode
  attr_accessor :val, :left, :right

  def initialize(val)
    self.val = val
  end
end

def count_bsts(n)
  return 1 if n <= 1
  count = 0
  0.upto(n - 1) do |k|
    count += count_bsts(k) * count_bsts(n - k - 1)
  end
  count
end

def gen_bsts(n)
  get_all_bsts(1, n)
end

def get_all_bsts(first, last)
  return [nil] if first > last
  res = []
  first.upto(last) do |root_val|
    get_all_bsts(first, root_val - 1).each do |left|
      get_all_bsts(root_val + 1, last).each do |right|
        root = TreeNode.new(root_val)
        root.left = left
        root.right = right
        res << root
      end
    end
  end
  res
end

p gen_bsts(3)
