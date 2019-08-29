puts "AVG of all subarrays of size k"

def averages_of_size_k(nums, k)
  res = []
  return res if k > nums.size
  window_sum = 0
  0.upto(k - 1) do |idx|
    window_sum += nums[idx]
  end
  res << window_sum.to_f / k
  k.upto(nums.length - 1) do |idx|
    window_sum -= nums[idx - k]
    window_sum += nums[idx]
    res << window_sum.to_f / k
  end
  res
end

p averages_of_size_k [1, 3, 2, 6, -1, 4, 1, 8, 2], 5

puts "max sum of any subarray of size k"

def max_sum_subarray_k(nums, k)
  return -1 if k > nums.length
  window_sum, max = 0, 0
  0.upto(nums.length - 1) do |idx|
    window_sum += nums[idx]
    window_sum -= nums[idx - k] if idx >= k
    max = window_sum if window_sum > max
  end
  max
end

p max_sum_subarray_k [2, 1, 5, 1, 3, 2], 3

puts "length of smallest subarray with sum K"

def smallest_sub_with_sum(nums, k)
  first, window_sum = 0, 0
  min = 1.0 / 0
  0.upto(nums.length - 1) do |last|
    window_sum += nums[last]
    while window_sum >= k && first <= last
      min = last - first + 1 if last - first < min
      window_sum -= nums[first]
      first += 1
    end
  end
  min
end

p smallest_sub_with_sum [2, 1, 5, 2, 3, 2], 7
p smallest_sub_with_sum [2, 1, 5, 2, 8], 7
p smallest_sub_with_sum [3, 4, 1, 1, 6], 8
p smallest_sub_with_sum [3, 4, 1, 1, 6], -8

puts "Longest substring with at most k distinct chars"

def longest_subtring_with_atmost_k_chars(s, k)
  map = Hash.new(0)
  first, last, max = 0, 0, 0
  while first < s.length
    if map.length <= k && last < s.length
      map[s[last]] += 1
      last += 1
    else
      map[s[first]] -= 1
      map.delete(s[first]) if map[s[first]].zero?
      first += 1
    end
    max = last - first if map.size <= k && last - first > max
  end
  max
end

def longest_subtring_with_atmost_k_chars(s, k)
  map = Hash.new(0)
  first, max = 0, 0
  0.upto(s.length - 1) do |last|
    map[s[last]] += 1
    if map.size > k
      map[s[first]] -= 1
      map.delete(s[first]) if map[s[first]].zero?
      first += 1
    end
    max = last - first + 1 if map.size == k && last - first + 1 > max
  end
  max
end

p longest_subtring_with_atmost_k_chars "araaci", 2
p longest_subtring_with_atmost_k_chars "araaci", 1
p longest_subtring_with_atmost_k_chars "cbbebi", 3

puts "fruits in basket"

def max_fruits_in_basket(fruits)
  map = Hash.new(0)
  first, last, count, max = 0, 0, 0, 0
  while first < fruits.length
    if map.size <= 2 && last < fruits.length
      map[fruits[last]] += 1
      last += 1
    else
      map[fruits[first]] -= 1
      map.delete(fruits[first]) if map[fruits[first]].zero?
      first += 1
    end
    max = last - first if map.size <= 2 && last - first > max
  end
  max
end

def max_fruits_in_basket(fruits)
  map = Hash.new(0)
  first, max = 0, 0
  1.upto(fruits.length) do |last|
    map[fruits[last - 1]] += 1
    while map.size > 2
      map[fruits[first]] -= 1
      map.delete(fruits[first]) if map[fruits[first]].zero?
      first += 1
    end
    max = last - first if last - first > max
  end
  max
end

p max_fruits_in_basket ["A", "B", "C", "A", "C"]
p max_fruits_in_basket ["A", "B", "C", "B", "B", "C"]

puts "longest substring with no repeating characters"

def longest_subtring_with_no_repeating(str)
  set = Set.new
  first, last, max = 0, 0, 0
  while first < str.length
    if last < str.length && !set.include?(str[last])
      set.add(str[last])
      last += 1
      max = last - first if last - first > max
    else
      set.delete(str[first])
      first += 1
    end
  end
  max
end

def longest_subtring_with_no_repeating(str)
  set = Set.new
  first, max = 0, 0
  1.upto(str.length) do |last|
    while set.include?(str[last - 1])
      set.delete(str[first])
      first += 1
    end
    set.add(str[last - 1])
    max = last - first if last - first > max
  end
  max
end

p longest_subtring_with_no_repeating "aabccbb"
p longest_subtring_with_no_repeating "abbbb"
p longest_subtring_with_no_repeating "abccde"

puts "Longest repeating substring with k replacements"

def longest_repeating_subtring_with_k_replacements(str, k)
  window = Hash.new(0)
  first, last, max, max_occuring = 0, 0, 0, ""
  while first < str.length
    if last < str.length && window[str[last]] >= window[max_occuring]
      max_occuring = str[last]
      replacements = last - first - window[max_occuring]
    else
      replacements = last - first - window[max_occuring] + 1
    end
    if last < str.length && replacements <= k
      window[str[last]] += 1
      last += 1
      max = last - first if last - first > max
    else
      window[str[first]] -= 1
      first += 1
    end
  end
  max
end

def longest_repeating_subtring_with_k_replacements(str, k)
  window = Hash.new(0)
  first, max, max_occuring = 0, 0, ""
  1.upto(str.length) do |last|
    window[str[last - 1]] += 1
    max_occuring = str[last - 1] if window[str[last - 1]] > window[max_occuring]
    while last - first - window[max_occuring] > k && first < last
      window[str[first]] -= 1
      first += 1
      max_occuring = str[first] if window[str[first]] > window[max_occuring]
    end
    max = last - first if last - first > max
  end
  max
end

def longest_repeating_subtring_with_k_replacements(str, k)
  window = Hash.new(0)
  first, max, max_occuring = 0, 0, 0
  1.upto(str.length) do |last|
    window[str[last - 1]] += 1
    max_occuring = [window[str[last - 1]], max_occuring].max
    if last - first - max_occuring > k
      window[str[first]] -= 1
      first += 1
    end
    max = last - first if last - first > max
  end
  max
end

p longest_repeating_subtring_with_k_replacements "aabccbb", 2
p longest_repeating_subtring_with_k_replacements "abbcb", 1
p longest_repeating_subtring_with_k_replacements "abccde", 1
p longest_repeating_subtring_with_k_replacements "AABABBA", 1
p longest_repeating_subtring_with_k_replacements "AABABBA", 0
p longest_repeating_subtring_with_k_replacements "KRSCDCSONAJNHLBMDQGIFCPEKPOHQIHLTDIQGEKLRLCQNBOHNDQGHJPNDQPERNFSSSRDEQLFPCCCARFMDLHADJADAGNNSBNCJQOF", 4
p longest_repeating_subtring_with_k_replacements "EQQEJDOBDPDPFPEIAQLQGDNIRDDGEHJIORMJPKGPLCPDFMIGHJNIIRSDSBRNJNROBALNSHCRFBASTLRMENCCIBJLGAITBFCSMPRO", 2

puts "Longest subarray with ones after replacement"

def longest_subarray_with_ones(arr, k)
  sum, first, max = 0, 0, 0
  0.upto(arr.length - 1) do |last|
    sum += arr[last]
    while (last - first + 1) - sum > k
      sum -= arr[first]
      first += 1
    end
    max = last - first + 1 if last - first + 1 > max
  end
  max
end

p longest_subarray_with_ones [0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1], k = 2
p longest_subarray_with_ones [0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1], k = 3

puts "find permutaion of a pattern in a  string"
puts "Approach 1"

def has_permutation(str, p)
  match = Hash.new(0)
  p.each_char { |c| match[c] += 1 }
  first, seen = 0, Hash.new(0)
  0.upto(str.length - 1) do |last|
    seen[str[last]] += 1
    while seen[str[last]] > match[str[last]] && first <= last
      seen[str[first]] -= 1
      seen.delete(str[first]) if seen[str[first]].zero?
      first += 1
    end
    return true if seen.size == match.size && last - first + 1 == p.length
  end
  false
end

p has_permutation "oidbcaaf", "abbc"
p has_permutation "oidbcaf", "abc"
p has_permutation "odicf", "dc"
p has_permutation "bcdxabcdy", "bcdyabcdx"
p has_permutation "aaacb", "abc"

puts "Approach 2"

def has_permutation(str, pattern)
  char_freq = Hash.new(0)
  pattern.each_char { |c| char_freq[c] += 1 }
  char_set = Set.new(char_freq.keys)
  first, matched = 0, 0
  0.upto(str.length - 1) do |last|
    if char_set.include?(str[last])
      char_freq[str[last]] -= 1
      matched += 1 if char_freq[str[last]].zero?
    end
    while last - first + 1 > pattern.length && first <= last
      if char_set.include?(str[first])
        matched -= 1 if char_freq[str[first]].zero?
        char_freq[str[first]] += 1
      end
      first += 1
    end
    return true if matched == char_set.length
  end
  false
end

p has_permutation "oidbcaaf", "abbc"
p has_permutation "oidbcaf", "abc"
p has_permutation "odicf", "dc"
p has_permutation "bcdxabcdy", "bcdyabcdx"
p has_permutation "aaacb", "abc"

puts "find all anagrams of a string"

def find_anagrams(str, p)
  res = []
  match = Hash.new(0)
  p.each_char { |c| match[c] += 1 }
  first, seen = 0, Hash.new(0)
  1.upto(str.length) do |last|
    seen[str[last - 1]] += 1
    while seen[str[last - 1]] > match[str[last - 1]] && first < last
      seen[str[first]] -= 1
      seen.delete(str[first]) if seen[str[first]].zero?
      first += 1
    end
    res.push(first) if seen.size == match.size && last - first == p.length
  end
  res
end

p find_anagrams "ppqp", "pq"
p find_anagrams "abbcabc", "abc"
p find_anagrams "cbaebabacd", "abc"

puts "Smallest substring with all letters of pattern"

def smallest_substring_with_letters(str, p)
  seen, match = Hash.new(0), Hash.new(0)
  min_first, first, min_last, found = 0, 0, str.length, false
  p.each_char { |c| match[c] += 1 }
  match_len = 0
  1.upto(str.length) do |last|
    first += 1 while !match.key?(str[first]) && first < last
    if match.key?(str[last - 1])
      seen[str[last - 1]] += 1
      if seen[str[last - 1]] == match[str[last - 1]]
        match_len += 1
      end
      while match_len == match.length && first < last
        found = true
        min_last, min_first = last, first if last - first <= min_last - min_first
        if match.key?(str[first])
          seen[str[first]] -= 1
          match_len -= 1 if seen[str[first]] == match[str[first]] - 1
          seen.delete(str[first]) if seen[str[first]].zero?
        end
        first += 1
      end
    end
  end
  found ? str[min_first..(min_last - 1)] : ""
end

def smallest_substring_with_letters(str, p)
  seen, match = Hash.new(0), Hash.new(0)
  first, min_last, min_first = 0, -1, -1.0 / 0
  p.each_char do |c|
    match[c] += 1
    match["#{c}#{match[c]}"] = 1
  end
  1.upto(str.length) do |last|
    first += 1 while !match.key?(str[first]) && first < last
    if match.key?(str[last - 1])
      seen[str[last - 1]] += 1
      if seen[str[last - 1]] <= match[str[last - 1]]
        seen["#{str[last - 1]}#{seen[str[last - 1]]}"] = 1
      end
      while seen.length == match.length && first < last
        min_last, min_first = last, first if last - first <= min_last - min_first
        if match.key?(str[first])
          seen.delete("#{str[first]}#{seen[str[first]]}")
          seen[str[first]] -= 1
          seen.delete(str[first]) if seen[str[first]].zero?
        end
        first += 1
      end
    end
  end
  min_last > 0 ? str[min_first..(min_last - 1)] : ""
end

p smallest_substring_with_letters "aabdec", "abc"
p smallest_substring_with_letters "ADOBECODEBANC", "ABC"
p smallest_substring_with_letters "a", "a"
p smallest_substring_with_letters "abc", "b"
p smallest_substring_with_letters "acbbaca", "aba"
p smallest_substring_with_letters "aaaaaaaaaaaabbbbbcdd", "abcdd"

def smallest_substring_with_letters(str, pattern)
  char_freq = Hash.new(0)
  pattern.each_char { |c| char_freq[c] += 1 }
  char_set, matched, first = Set.new(char_freq.keys), 0, 0
  match_first, match_last = -1, -1
  0.upto(str.length - 1) do |last|
    if char_set.include?(str[last])
      char_freq[str[last]] -= 1
      matched += 1 if char_freq[str[last]].zero?
    end
    while matched == char_set.length && first <= last
      match_first, match_last = first, last if match_first == -1 || match_last - match_first > last - first
      if char_set.include?(str[first])
        matched -= 1 if char_freq[str[first]].zero?
        char_freq[str[first]] += 1
      end
      first += 1
    end
  end
  match_first < 0 ? "" : str[match_first..match_last]
end

puts "Second implementation"
p smallest_substring_with_letters "aabdec", "abc"
p smallest_substring_with_letters "ADOBECODEBANC", "ABC"
p smallest_substring_with_letters "a", "a"
p smallest_substring_with_letters "abc", "b"
p smallest_substring_with_letters "acbbaca", "aba"
p smallest_substring_with_letters "aaaaaaaaaaaabbbbbcdd", "abcdd"

puts "words concatenation"

class Trie
  class Node
    attr_accessor :children, :idx

    def initialize
      self.children = {}
    end
  end

  attr_accessor :root

  def initialize()
    self.root = Node.new
  end

  def add(word, idx)
    node = root
    word.each_char do |c|
      node.children[c] ||= Node.new
      node = node.children[c]
    end
    node.idx = idx
  end

  def search(str, idx)
    node = root
    while node && !node.idx
      node = node.children[str[idx]]
      idx += 1
    end
    return node&.idx || -1
  end
end

def concatenated_words(str, words)
  return [] if str.empty? || words.empty?
  match, word_len, res = Hash.new(0), words[0].length, []
  words.each_with_index do |word, idx|
    match[word] += 1
  end
  0.upto(str.length - words.length * words[0].length) do |first|
    seen = Hash.new(0)
    0.upto(words.length - 1) do |j|
      start = first + j * word_len
      word = str[start..(start + word_len - 1)]
      seen[word] += 1
      break if seen[word] > match[word]
      res << first if j == words.length - 1
    end
  end
  res
end

p concatenated_words "catfoxcat", ["cat", "fox"]
p concatenated_words "catcatfoxfox", ["cat", "fox"]

def concatenated_words(str, words)
  return [] if str.empty? || words.empty?
  word_freq = Hash.new(0)
  words.each { |word| word_freq[word] += 1 }
  word_len, res = words[0].length, []
  0.upto(str.length - words.length * word_len) do |first|
    match_len, seen = 0, Hash.new(0)
    last = first + words.length * word_len - 1
    first.step(last, word_len) do |idx|
      word = str[idx, word_len]
      if word_freq.key?(word)
        seen[word] += 1
        match_len += 1 if seen[word] == word_freq[word]
      else
        break
      end
    end
    res << first if match_len == word_freq.length
  end
  res
end

p concatenated_words "catfoxcat", ["cat", "fox"]
p concatenated_words "catcatfoxfox", ["cat", "fox"]
