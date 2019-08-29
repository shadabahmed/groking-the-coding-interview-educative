class LinkedList < Struct.new(:val, :next)
end

puts "Is linked list cyclic"
def is_cyclic(head)
  return false if head.nil?
  slow, fast = head, head.next
  while fast && fast.next && slow != fast
    fast = fast.next.next
    slow = slow.next
  end
  fast == slow
end

head = LinkedList.new(1)

tail = 2.upto(6).reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end
tail.next = head.next.next
puts is_cyclic head

puts "Length of the cycle"

def find_cycle_length(head)
  return nil if head.nil?
  slow, fast = head, head.next
  while fast && fast.next && slow != fast
    fast = fast.next.next
    slow = slow.next
  end
  return 0 if fast != slow
  len = 1
  nxt = slow.next
  while nxt != slow
    len += 1
    nxt = nxt.next
  end
  len
end

head = LinkedList.new(1)

tail = 2.upto(6).reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end
tail.next = head.next.next
puts find_cycle_length head

puts "Find Cycle Beginning"
def find_cycle_beginning(head)
  return head if head.nil?
  slow, fast = head, head.next
  while fast && fast.next && slow != fast
    fast = fast.next.next
    slow = slow.next
  end
  return nil? if slow != fast
  nxt, len = slow.next, 1
  while nxt != slow
    len += 1
    nxt = nxt.next
  end
  behind, ahead = head, head
  len.times { ahead = ahead.next}
  while behind != ahead
    behind = behind.next
    ahead = ahead.next
  end
  behind
end

head = LinkedList.new(1)

tail = 2.upto(6).reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end
tail.next = head.next.next
puts find_cycle_beginning head

puts "Find Cyclic linked list length"
def find_cyclic_list_length(head)
  return 0 if head.nil?
  slow, fast, len = head, head.next, 1
  while fast && fast.next && slow != fast
    fast = fast.next.next
    slow = slow.next
    len += 2
  end
  return fast.nil? ? len : len + 1 if slow != fast
  nxt, len = slow.next, 1
  while nxt != slow
    len += 1 
    nxt = nxt.next
  end
  behind, ahead = head, head
  len.times { ahead = ahead.next}
  while behind != ahead
    behind = behind.next
    ahead = ahead.next
    len += 1 
  end
  len
end

head = LinkedList.new(1)

tail = 2.upto(6).reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end
tail.next = head.next.next
puts find_cyclic_list_length head

=begin
puts "New Password: BeepBoop3005"
puts "Disk Recovery Password: M7H73AB46MVAKKRBBG48HDFK"
puts "Recovery password: 12a1d571"
puts 'rsync -a --progress --stats "/Volumes/Macintosh HD 1/Users/shadab_ahmed/Work" "/Volumes/Macintosh HD 1/Users/shadab_ahmed/Programming" "/Volumes/Macintosh HD 1/Users/shadab_ahmed/Desktop" "/Volumes/Macintosh HD 1/Users/shadab_ahmed/Documents" "/Volumes/Macintosh HD 1/Users/shadab_ahmed/Pictures" ~/'
=end

puts "Happy Number"

def is_happy_number(num)
  return true if num == 1
  slow, fast = num, next_num(num)
  while slow != fast
    fast = next_num(next_num(fast))
    slow = next_num(slow)
  end
  slow == 1
end

def next_num(num)
  sum = 0
  while num > 0
    sum += (num % 10) ** 2
    num /= 10
  end
  sum
end

p is_happy_number 23
p is_happy_number 12

puts "Middle of linked list"

def get_middle(head)
  return nil if head.nil?
  slow, fast = head, head.next
  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
  end
  slow
end


head = LinkedList.new(1)

tail = 2.upto(5).reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end

p get_middle head

puts "Find out if linked list is a palindrome"
def is_palindrome(head)
  return true if head.nil?
  mid = find_middle(head)
  nxt_half_head = mid.next = reverse_linked_list(mid.next)
  while nxt_half_head
    break if head.val != nxt_half_head.val
    head = head.next
    nxt_half_head = nxt_half_head.next
  end
  mid.next = reverse_linked_list(mid.next)
  nxt_half_head.nil?
end

def find_middle(head)
  slow, fast = head, head.next
  while fast && fast.next
    fast = fast.next.next
    slow = slow.next
  end
  slow
end

def reverse_linked_list(head)
  prev, current = nil, head
  while current
    nxt = current.next    
    current.next = prev
    prev = current
    current = nxt
  end
  prev
end

head = LinkedList.new(1)

tail = [2, 2, 1].reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end

p is_palindrome(head)

head = LinkedList.new(1)

tail = [2, 2, 2,1].reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end

p is_palindrome(head)

puts "Rearrange linked list"
def rearrange_list(head)
  return nil if head.nil?
  mid = find_middle(head)
  orig_head = head
  other_head = reverse_linked_list(mid.next)
  mid.next = nil
  while other_head
    nxt = head.next
    other_nxt = other_head.next
    head.next = other_head
    head.next.next = nxt
    head = nxt
    other_head = other_nxt
  end
  orig_head
end

def find_middle(head)
  slow, fast = head, head.next
  while fast && fast.next
    fast = fast.next.next
    slow = slow.next
  end
  slow
end

def reverse_linked_list(head)
  prev, current = nil, head
  while current
    nxt = current.next
    current.next = prev
    prev = current
    current = nxt
  end
  prev
end

head = LinkedList.new(1)

tail = 2.upto(5).reduce(head) do |head, num|
  head.next = LinkedList.new(num)
end

p rearrange_list head

puts "Cycle in circular array"

def has_cycle(nums)
  slow, fast = 0, get_next(nums, 0)
  while fast != slow
    slow = get_next(nums, slow)
    fast = get_next(nums, get_next(nums, fast))
  end
  nxt = get_next(nums, slow)
  while nxt != slow
    return false if nums[nxt] * nums[slow] < 0
    nxt = get_next(nums, nxt)
  end
  slow != get_next(nums, slow)
end

def get_next(nums, idx)
  (idx + nums[idx]) % nums.length
end


def has_cycle(nums)
  cache = {}
  0.upto(nums.length - 1) do |first|
    if get_cycle_length(nums, first, cache) > 1
      p cache
      return true  
    end
  end
  p cache
  false
end

def get_cycle_length(nums, idx, cache)
  return cache[idx] if cache.key?(idx)
  first, slow, fast = idx, idx, get_next(nums, idx, idx)
  while slow != fast
    return cache[idx] = cache[slow] if cache.key?(slow)
    return cache[idx] = cache[fast] if cache.key?(fast)
    return cache[idx] = 0 if slow < 0 || fast < 0
    slow = get_next(nums, slow, idx)
    fast = get_next(nums, get_next(nums, fast, idx), idx)
  end
  nxt, len = get_next(nums, slow, idx), 1
  while nxt != slow
    return cache[idx] = 0 if nxt < 0 || nums[slow] * nums[nxt] < 0
    nxt = get_next(nums, nxt, idx)
    len += 1
  end
  cache[idx] = len
end

def get_next(nums, idx, first)
  nxt_idx = (idx + nums[idx]) % nums.length
  nums[nxt_idx] * nums[first] < 0 ? -1 : nxt_idx
end
p has_cycle [1, 2, -1, 2, 2]
p has_cycle [2, 2, -1, 2]
p has_cycle [2, 1, -1, -2]
p has_cycle [3,1,2]