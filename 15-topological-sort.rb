puts "Topological sort"

def topological_sort(vertices, edges)
  edge_map = {}
  incoming_count = Hash.new(0)
  edges.each do |src, dest|
    edge_map[src] ||= Set.new
    edge_map[src].add(dest)
    incoming_count[dest] += 1
  end
  queue = 0.upto(vertices - 1).select { |v| incoming_count[v].zero? }
  res = []
  while !queue.empty?
    node = queue.shift
    res << node
    next unless edge_map.key?(node)
    edge_map[node].each do |dest|
      incoming_count[dest] -= 1
      queue << dest if incoming_count[dest].zero?
    end
  end
  return [] if res.length != vertices
  res
end

p topological_sort(4, [[3, 2], [3, 0], [2, 0], [2, 1]])

puts "Task scheduling"

def can_schedule_tasks(tasks_count, prereqs)
  task_dependencies, prereq_count = {}, Hash.new(0)
  prereqs.each do |prereq, depedency|
    task_dependencies[prereq] ||= []
    task_dependencies[prereq] << depedency
    prereq_count[depedency] += 1
  end
  queue = 0.upto(tasks_count - 1).select { |task| prereq_count[task].zero? }
  compeletable_tasks = 0
  while !queue.empty?
    task = queue.shift
    compeletable_tasks += 1
    next unless task_dependencies.key?(task)
    task_dependencies[task].each do |depedency|
      prereq_count[depedency] -= 1
      queue << depedency if prereq_count[depedency].zero?
    end
  end
  compeletable_tasks == tasks_count
end

p can_schedule_tasks 3, [[0, 1], [1, 2]]
p can_schedule_tasks 3, [[0, 1], [1, 2], [2, 0]]
p can_schedule_tasks 6, [[2, 5], [0, 5], [0, 4], [1, 4], [3, 2], [1, 3]]

puts "Tasks ordering"

def tasks_ordering(num_tasks, prereqs)
  depedency_map, prereq_count, ordering = {}, Hash.new(0), []
  prereqs.each do |prereq, depedency|
    prereq_count[depedency] += 1
    depedency_map[prereq] ||= []
    depedency_map[prereq] << depedency
  end
  queue = 0.upto(num_tasks - 1).select { |task| prereq_count[task].zero? }
  while !queue.empty?
    task = queue.shift
    ordering << task
    next unless depedency_map.key?(task)
    depedency_map[task].each do |depedency|
      prereq_count[depedency] -= 1
      queue << depedency if prereq_count[depedency].zero?
    end
  end
  ordering.length == num_tasks ? ordering : []
end

p tasks_ordering 3, [[0, 1], [1, 2]]
p tasks_ordering 3, [[0, 1], [1, 2], [2, 0]]
p tasks_ordering 6, [[2, 5], [0, 5], [0, 4], [1, 4], [3, 2], [1, 3]]

puts "All tasks scheduling"

def all_possible_orderings(num_tasks, prereqs)
  depedency_map, prereq_count = {}, Hash.new(0)
  prereqs.each do |prereq, depedency|
    prereq_count[depedency] += 1
    depedency_map[prereq] ||= []
    depedency_map[prereq] << depedency
  end
  available_tasks = 0.upto(num_tasks - 1).select { |task| prereq_count[task].zero? }
  generate_orderings(available_tasks, num_tasks, depedency_map, prereq_count)
end

def generate_orderings(available_tasks, num_tasks, depedency_map, prereq_count, stack = [], res = [])
  return res.push(stack.clone) if stack.length == num_tasks
  return res if available_tasks.empty?
  available_tasks.length.times do
    task = available_tasks.shift
    next_available_tasks = available_tasks.clone
    stack.push(task)
    if depedency_map.key?(task)
      depedency_map[task].each do |depedency|
        prereq_count[depedency] -= 1
        next_available_tasks << depedency if prereq_count[depedency].zero?
      end
    end

    generate_orderings(next_available_tasks, num_tasks, depedency_map, prereq_count, stack, res)

    stack.pop
    if depedency_map.key?(task)
      depedency_map[task].each do |depedency|
        prereq_count[depedency] += 1
      end
    end
    available_tasks << task
  end
  res
end

p all_possible_orderings(4, [[3, 2], [3, 0], [2, 0], [2, 1]])
p all_possible_orderings 6, [[2, 5], [0, 5], [0, 4], [1, 4], [3, 2], [1, 3]]

puts "Alien dictionary"

def alien_ordering(words)
  successor_map, ancestor_counts = generate_word_graph(words)
  queue = ancestor_counts.keys.select { |k| ancestor_counts[k].zero? }
  res = ""
  while !queue.empty?
    letter = queue.shift
    res << letter
    next unless successor_map.key?(letter)
    successor_map[letter].each do |successor|
      ancestor_counts[successor] -= 1
      queue << successor if ancestor_counts[successor].zero?
    end
  end
  res
end

def generate_word_graph(words)
  successor_map, ancestor_counts = {}, {}
  words[0].each_char { |c| ancestor_counts[c] ||= 0 }
  0.upto(words.length - 2) do |idx|
    words[idx + 1].each_char { |c| ancestor_counts[c] ||= 0 }
    if rel = get_relation(words[idx], words[idx + 1])
      ancestor, successor = rel
      successor_map[ancestor] ||= [] #Set.new
      #next if successor_map[ancestor].include?(successor)
      successor_map[ancestor] << successor
      ancestor_counts[successor] += 1
    end
  end
  [successor_map, ancestor_counts]
end

def get_relation(word1, word2)
  idx1, idx2 = 0, 0
  while idx1 < word1.length && idx2 < word2.length
    return [word1[idx1], word2[idx2]] if word1[idx1] != word2[idx2]
    idx1 += 1
    idx2 += 1
  end
  nil
end

p alien_ordering %w[ba bc ac cab]
p alien_ordering ["cab", "aaa", "aab"]
p alien_ordering ["ywx", "xww", "xz", "zyy", "zwz"]

puts "Reconstructing a sequence"

def is_possible_seq(original_seq, sequences)
  ancestor_counts, successor_map = Hash.new(0), Hash.new { |h, k| h[k] = [] }
  sequences.each do |ancestor, successor|
    ancestor_counts[successor] += 1
    successor_map[ancestor] << successor
  end
  queue, idx = original_seq.select { |num| ancestor_counts[num].zero? }, 0
  while queue.size == 1
    num = queue.shift
    return false if num != original_seq[idx]
    idx += 1
    successor_map[num].each do |next_num|
      ancestor_counts[next_num] -= 1
      queue << next_num if ancestor_counts[next_num].zero?
    end
  end
  idx >= original_seq.length
end

p is_possible_seq [1, 2, 3, 4], [[1, 2], [2, 3], [3, 4]]
p is_possible_seq [1, 2, 3, 4], [[1, 2], [2, 3], [2, 4]]

puts "Minimum height trees"

def find_min_height_trees(n, edges)
  height_nodes_map, connected_map = Hash.new { |h, k| h[k] = [] }, Hash.new { |h, k| h[k] = [] }
  min_height = n
  edges.each do |v1, v2|
    connected_map[v1] << v2
    connected_map[v2] << v1
  end
  0.upto(n - 1) do |root|
    height = find_height_for_root(root, connected_map)
    min_height = height if height < min_height
    height_nodes_map[height] << root
  end
  height_nodes_map[min_height]
end

def find_height_for_root(root, connected_map)
  queue, height, seen = [root], 0, Set.new([root])
  while !queue.empty?
    height += 1
    queue.length.times do
      node = queue.shift
      seen << node
      connected_map[node].each do |next_node|
        next if seen.include?(next_node)
        queue << next_node
      end
    end
  end
  height
end

def find_min_height_trees(n, edges)
  return 0.upto(n - 1).to_a if n <= 2
  edge_count, connections = Hash.new(0), Hash.new { |h, k| h[k] = [] }
  edges.each do |v1, v2|
    edge_count[v1] += 1
    edge_count[v2] += 1
    connections[v1] << v2
    connections[v2] << v1
  end
  leaf_nodes = 0.upto(n - 1).select { |node| edge_count[node] == 1 }
  total_nodes = n
  while total_nodes > 2
    total_nodes -= leaf_nodes.size
    leaf_nodes.size.times do
      node = leaf_nodes.shift
      edge_count[node] -= 1
      connections[node].each do |next_node|
        edge_count[next_node] -= 1
        leaf_nodes << next_node if edge_count[next_node] == 1
      end
    end
  end
  leaf_nodes
end

p find_min_height_trees 5, [[0, 1], [1, 2], [1, 3], [2, 4]]
p find_min_height_trees n = 4, edges = [[1, 0], [1, 2], [1, 3]]
p find_min_height_trees n = 6, edges = [[0, 3], [1, 3], [2, 3], [4, 3], [5, 4]]
