puts "max profit knapsack - each item only once"

puts "Recursive"

def max_profit(profits, weights, capacity, len = profits.length)
  return 0 if capacity.zero? || len.zero?
  if capacity >= weights[len - 1]
    [profits[len - 1] + max_profit(profits, weights, capacity - weights[len - 1], len - 1), max_profit(profits, weights, capacity, len - 1)].max
  else
    max_profit(profits, weights, capacity, len - 1)
  end
end

p max_profit [4, 5, 3, 7], [2, 3, 1, 4], 5

puts "Recursive with memo"

def max_profit_memo(profits, weights, capacity, len = profits.length, cache = {})
  return cache[[capacity, len]] if cache.key?([capacity, len])
  return 0 if capacity.zero? || len.zero?
  if capacity >= weights[len - 1]
    cache[[capacity, len]] = [profits[len - 1] + max_profit_memo(profits, weights, capacity - weights[len - 1], len - 1, cache), max_profit_memo(profits, weights, capacity, len - 1, cache)].max
  else
    cache[[capacity, len]] = max_profit_memo(profits, weights, capacity, len - 1, cache)
  end
end

p max_profit_memo [4, 5, 3, 7], [2, 3, 1, 4], 5

puts "DP with no optimization"

def max_profit_dp_no_op(profits, weights, capacity)
  dp = (profits.length + 1).times.collect { (capacity + 1).times.collect { 0 } }
  1.upto(profits.length) do |len|
    1.upto(capacity) do |cap|
      dp[len][cap] = if cap >= weights[len - 1]
                       [dp[len - 1][cap], profits[len - 1] + dp[len - 1][cap - weights[len - 1]]].max
                     else
                       dp[len - 1][cap]
                     end
    end
  end
  dp[profits.length][capacity]
end

p max_profit_dp_no_op [4, 5, 3, 7], [2, 3, 1, 4], 5
p max_profit_dp_no_op [1, 6, 10, 16], [1, 2, 3, 5], 7
p max_profit_dp_no_op [1, 6, 10, 16], [1, 2, 3, 5], 6

puts "DP with some optimization"

def max_profit_dp_some_op(profits, weights, capacity)
  prev = (capacity + 1).times.collect { 0 }
  cur = (capacity + 1).times.collect { 0 }
  1.upto(profits.length) do |len|
    1.upto(capacity) do |cap|
      cur[cap] = if cap >= weights[len - 1]
                   [prev[cap], profits[len - 1] + prev[cap - weights[len - 1]]].max
                 else
                   prev[cap]
                 end
    end
    prev, cur = cur, prev
  end
  prev[capacity]
end

p max_profit_dp_some_op [4, 5, 3, 7], [2, 3, 1, 4], 5

puts "DP with max optimization"

def max_profit_dp_max_op(profits, weights, capacity)
  max_weight = weights.max
  dp = (1 + capacity).times.collect { 0 }
  1.upto(profits.length) do |len|
    capacity.downto(1) do |cap|
      next if cap < weights[len - 1]
      dp[cap] = [dp[cap], profits[len - 1] + dp[(cap - weights[len - 1])]].max
    end
  end
  dp[capacity]
end

p max_profit_dp_max_op [4, 5, 3, 7], [2, 3, 1, 4], 5

# require "benchmark"
# Benchmark.bm(7) do |x|
#   x.report("recursive:") { 100_000.times { max_profit [4, 5, 3, 7, 7, 7, 7], [2, 3, 1, 4, 4, 4, 4], 5 } }
#   x.report("memo:") { 100_000.times { max_profit_memo [4, 5, 3, 7, 7, 7, 7], [2, 3, 1, 4, 4, 4, 4], 5 } }
#   x.report("dp_no_op:") { 100_000.times { max_profit_dp_no_op [4, 5, 3, 7, 7, 7, 7], [2, 3, 1, 4, 4, 4, 4], 5 } }
#   x.report("dp_some_op:") { 100_000.times { max_profit_dp_some_op [4, 5, 3, 7, 7, 7, 7], [2, 3, 1, 4, 4, 4, 4], 5 } }
#   x.report("dp_max_op:") { 100_000.times { max_profit_dp_max_op [4, 5, 3, 7, 7, 7, 7], [2, 3, 1, 4, 4, 4, 4], 5 } }
# end

puts "Equal subsets"

puts "Recursive:"

def equal_subset_possible(arr)
  sum = arr.sum
  return false if sum.odd?
  equal_subset(arr, sum / 2)
end

def equal_subset(arr, target, len = arr.length)
  return target.zero? if len.zero?
  if target >= arr[len - 1]
    equal_subset(arr, target - arr[len - 1], len - 1) || equal_subset(arr, target, len - 1)
  else
    equal_subset(arr, target, len - 1)
  end
end

p equal_subset_possible [1, 2, 3, 4]
p equal_subset_possible [1, 1, 3, 4, 7]
p equal_subset_possible [2, 3, 4, 6]

puts "DP:"

def equal_subset_possible(arr)
  sum = arr.sum
  return false if sum.odd?
  equal_subset(arr, sum / 2)
end

def equal_subset(arr, target, len = arr.length)
  dp = (target + 1).times.collect { false }
  dp[0] = true
  1.upto(arr.length) do |len|
    (target).downto(0) do |target|
      next if target < arr[len - 1]
      dp[target] = dp[target] || dp[target - arr[len - 1]]
    end
  end
  dp[target]
end

p equal_subset_possible [1, 2, 3, 4]
p equal_subset_possible [1, 1, 3, 4, 7]
p equal_subset_possible [2, 3, 4, 6]
p equal_subset_possible [0, 0, 0, 0]
puts

def equal_subset(arr, target, len = arr.length)
  prev = (target + 1).times.collect { false }
  cur = (target + 1).times.collect { false }
  prev[0] = true
  1.upto(arr.length) do |len|
    0.upto(target) do |target|
      if target >= arr[len - 1]
        cur[target] = prev[target] || prev[target - arr[len - 1]]
      else
        cur[target] = prev[target]
      end
    end
    prev, cur = cur, prev
  end
  prev[target]
end

p equal_subset_possible [1, 2, 3, 4]
p equal_subset_possible [1, 1, 3, 4, 7]
p equal_subset_possible [2, 3, 4, 6]
p equal_subset_possible [0, 0, 0, 0]

puts

def equal_subset(arr, target, len = arr.length)
  dp = (arr.length + 1).times.collect { [false] * (target + 1) }
  dp[0][0] = true
  1.upto(arr.length) do |len|
    0.upto(target) do |target|
      if target >= arr[len - 1]
        dp[len][target] = dp[len - 1][target] || dp[len - 1][target - arr[len - 1]]
      else
        dp[len][target] = dp[len - 1][target]
      end
    end
  end
  res = []
  arr.length.downto(1) do |len|
    if dp[len][target] != dp[len - 1][target]
      res.push(arr[len - 1])
      target -= arr[len - 1]
    end
  end
  res
end

p equal_subset_possible [1, 2, 3, 4]
p equal_subset_possible [1, 1, 3, 4, 7]
p equal_subset_possible [2, 3, 4, 6]
p equal_subset_possible [0, 0, 0, 0]
puts

puts "Subset sum"

def subset_sum(arr, target)
  dp = (arr.length + 1).times.collect { (target + 1).times.collect { false } }
  dp[0][0] = true
  1.upto(arr.length) do |len|
    1.upto(target) do |target|
      if target >= arr[len - 1]
        dp[len][target] = dp[len - 1][target] || dp[len - 1][target - arr[len - 1]]
      else
        dp[len][target] = dp[len - 1][target]
      end
    end
  end
  len, res = arr.length, []
  while len > 0 && dp[len][target]
    if !dp[len - 1][target]
      res << arr[len - 1]
      target -= arr[len - 1]
    end
    len -= 1
  end
  res
end

def subset_sum(arr, target)
  dp = (target + 1).times.collect { false }
  dp[0] = true
  1.upto(arr.length) do |len|
    target.downto(0) do |target|
      next if target < arr[len - 1]
      dp[target] ||= dp[target - arr[len - 1]]
    end
  end
  dp[target]
end

p subset_sum [1, 2, 3, 7], 6
p subset_sum [1, 2, 7, 1, 5], 10
p subset_sum [1, 3, 4, 8], 6

puts "Minimum subset difference"

def min_subset_diff(arr)
  target = arr.sum / 2
  dp = (target + 1).times.collect { false }
  max_target_possible = 0
  dp[0] = true
  1.upto(arr.length) do |len|
    target.downto(0) do |target|
      if target >= arr[len - 1]
        dp[target] ||= dp[target - arr[len - 1]]
      end
      if len == arr.length && dp[target] && target > max_target_possible
        max_target_possible = target
      end
    end
  end
  arr.sum - (2 * max_target_possible)
end

p min_subset_diff [1, 2, 3, 9]
p min_subset_diff [1, 2, 7, 1, 5]
p min_subset_diff [1, 3, 100, 4]

puts "Count of subsets"

def count_of_subsets(arr, target)
  dp = (arr.length + 1).times.collect { (1 + target).times.collect { 0 } }
  dp[0][0] = 1
  1.upto(arr.length) do |len|
    0.upto(target) do |target|
      if arr[len - 1] > target
        dp[len][target] = dp[len - 1][target]
      else
        dp[len][target] = dp[len - 1][target] + dp[len - 1][target - arr[len - 1]]
      end
    end
  end
  dp[arr.length][target]
end

p count_of_subsets [1, 1, 2, 3], 4
p count_of_subsets [1, 2, 7, 1, 5], 9
puts

def count_of_subsets(arr, target)
  dp = (1 + target).times.collect { 0 }
  dp[0] = 1
  1.upto(arr.length) do |len|
    target.downto(0) do |target|
      if arr[len - 1] <= target
        dp[target] += dp[target - arr[len - 1]]
      end
    end
  end
  dp[target]
end

p count_of_subsets [1, 1, 2, 3], 4
p count_of_subsets [1, 2, 7, 1, 5], 9

puts "Target Sum"

def target_sum(arr, sum)
  total_sum = arr.sum
  target = [(total_sum + sum) / 2, (total_sum - sum) / 2].min
  dp = (target + 1).times.collect { 0 }
  dp[0] = 1
  1.upto(arr.length) do |len|
    target.downto(0) do |target|
      if arr[len - 1] <= target
        dp[target] += dp[target - arr[len - 1]]
      end
    end
  end
  dp[target]
end

p target_sum [1, 1, 2, 3], S = 1
