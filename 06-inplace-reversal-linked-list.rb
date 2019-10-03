class ListNode < Struct.new(:val, :next)
  def to_s
    node = self
    str = ""
    while node
      str << "#{node.val} -> "
      node = node.next
    end
    str << "NULL\n"
  end
end

puts "Reverse linked list"

def reverse_list(head)
  prev = nil
  while head
    nxt = head.next
    head.next = prev
    prev = head
    head = nxt
  end
  prev
end

puts "Reverse linked list from P to Q"

def reverse_list_between(head, first, last)
  dummy_head = ListNode.new(0, head)
  head = dummy_head
  while head.next && head.next.val != first
    head = head.next
  end
  if head.next
    tail = head.next
    while tail && tail.val != last
      tail = tail.next
    end
    prev = nil
    if tail
      prev = tail.next
      tail.next = nil
    end
    match_head = head.next
    while match_head
      nxt = match_head.next
      match_head.next = prev
      prev = match_head
      match_head = nxt
    end
    head.next = prev
  end
  dummy_head.next
end

head = ListNode.new(1)

tail = 2.upto(5).reduce(head) do |head, num|
  head.next = ListNode.new(num)
end

puts reverse_list_between(head, 2, 4)

puts "Reverse every k element sublist"

def reverse_every_k_sublist(head, k)
  return head if head.nil? || k == 1
  tail, count = head, 1
  while tail.next && count < k
    tail = tail.next
    count += 1
  end
  rem = tail.next
  tail.next = nil
  prev = reverse_every_k_sublist(rem, k)
  while head
    nxt = head.next
    head.next = prev
    prev = head
    head = nxt
  end
  prev
end

def reverse_every_k_sublist(head, k)
  return head if head.nil? || k == 1
  tail, count = head, 1
  prev_tail = dummy_head = ListNode.new(0, head)
  while tail
    nxt_tail = tail.next
    if count % k == 0 || tail.next.nil?
      tail.next = nil
      prev_tail.next = tail
      prev_tail = head
      prev, cur = nil, head
      while cur
        nxt = cur.next
        cur.next = prev
        prev = cur
        cur = nxt
      end
      head = nxt_tail
    end
    tail = nxt_tail
    count += 1
  end
  dummy_head.next
end

head = ListNode.new(1)

tail = 2.upto(5).reduce(head) do |head, num|
  head.next = ListNode.new(num)
end

puts reverse_every_k_sublist(head, 2)

puts "Reverse every alternating k elements"

def reverse_alternating_k(head, k)
  return head if head.nil? || k <= 1
  kth_tail, count = head, 1
  while kth_tail.next && count < k
    kth_tail = kth_tail.next
    count += 1
  end
  prev = nxt_kth_tail = kth_tail.next
  kth_tail.next = nil
  if nxt_kth_tail
    count = 1
    while nxt_kth_tail.next && count < k
      nxt_kth_tail = nxt_kth_tail.next
      count += 1
    end
    nxt_kth_tail.next = reverse_alternating_k(nxt_kth_tail.next, k)
  end

  while head
    nxt = head.next
    head.next = prev
    prev = head
    head = nxt
  end
  prev
end

head = ListNode.new(1)

tail = 2.upto(9).reduce(head) do |head, num|
  head.next = ListNode.new(num)
end

puts reverse_alternating_k(head, 2)

def reverse_alternating_k(head, k)
  return head if k <= 1 || head.nil?
  prev_tail, cur, cur_head, count = nil, head, head, 1
  while cur
    if count == k || cur.next.nil? && count < k
      if prev_tail
        prev_tail.next = cur
      else
        head = cur
      end
      prev = cur.next
      cur.next = nil
      cur = cur_head
      while cur_head
        nxt = cur_head.next
        cur_head.next = prev
        prev = cur_head
        cur_head = nxt
      end
    elsif count == 2 * k
      prev_tail = cur
      count = 0
      cur_head = cur.next
    end
    cur = cur.next
    count += 1
  end
  head
end

head = ListNode.new(1)

tail = 2.upto(9).reduce(head) do |head, num|
  head.next = ListNode.new(num)
end

puts reverse_alternating_k(head, 2)

puts "Rotate Linked list by number k"

def rotate(head, k)
  return head if head.nil? || k <= 0
  len, tail = 1, head
  while tail.next
    len += 1
    tail = tail.next
  end
  k = k % len
  return head if k.zero?
  tail.next = head
  k = len - k
  while k > 1
    head = head.next
    k -= 1
  end
  new_head = head.next
  head.next = nil
  new_head
end

head = ListNode.new(1)

tail = 2.upto(5).reduce(head) do |head, num|
  head.next = ListNode.new(num)
end

puts rotate head, 1
