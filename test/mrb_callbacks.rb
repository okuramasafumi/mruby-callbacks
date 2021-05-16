##
## Callbacks Test
##

class C
  include Callbacks

  def a
    $A = 'a'
  end
end

class C1 < C
  define_callback :before, :a do
    $BEFORE_A = 'before a'
  end
end

class C2 < C
  define_callback :after, :a do
    $AFTER_A = 'after a'
  end
end

class C3 < C
  define_callback :around, :a do |a|
    $AROUND_A_1 = 'around a 1'
    a.call
    $AROUND_A_2 = 'around a 2'
  end
end

class C4 < C
  define_callback :before, :a do
    $BEFORE_A_1 = 'before a 1'
  end

  define_callback :before, :a do
    $BEFORE_A_2 = 'before a 2'
  end
end

class C5 < C
  define_callback :after, :a do
    $AFTER_A_1 = 'after a 1'
  end

  define_callback :after, :a do
    $AFTER_A_2 = 'after a 2'
  end
end

class C6 < C
  define_callback :around, :a do |a|
    $AROUND_A_1_1 = 'around a 1'
    a.call
    $AROUND_A_2_1 = 'around a 2'
  end

  define_callback :around, :a do |a|
    $AROUND_A_1_2 = 'around a 1'
    a.call
    $AROUND_A_2_2 = 'around a 2'
  end
end

class C9 < C
  define_callback :before, :a do
    nil
  end
end

class C10 < C
  define_callback :before, :a do
    false
  end
end

class C12 < C
  define_callback :around, :a do |original|
    next
    original.call
  end
end

class F
  include Callbacks

  def hook_enabled?
    true
  end

  def a
  end
end

class F1 < F
  define_callback :before, :a, if: proc { true } do
    $BEFORE_A = 'before a'
  end
end

class F2 < F
  define_callback :before, :a, if: proc { false } do
    $BEFORE_A = 'before a'
  end
end

class F3 < F
  define_callback :before, :a, if: proc { hook_enabled? } do
    $BEFORE_A = 'before a'
  end
end

class F4 < F3
  def hook_enabled?
    false
  end

  define_callback :before, :a, if: proc { hook_enabled? } do
    $BEFORE_A = 'before a'
  end
end

class F5 < F
  define_callback :before, :a, if: -> { true } do
    false
  end
end

class F6 < F
  define_callback :before, :a, if: -> { false } do
    false
  end
end

assert("before callback") do
  c = C1.new
  c.a
  assert_equal("before a", $BEFORE_A)
end

assert("after callback") do
  c = C2.new
  c.a
  assert_equal("after a", $AFTER_A)
end

assert("around callback") do
  c = C3.new
  c.a
  assert_equal("around a 1", $AROUND_A_1)
  assert_equal("around a 2", $AROUND_A_2)
end


assert("before callback twice") do
  c = C4.new
  c.a
  assert_equal("before a 1", $BEFORE_A_1)
  assert_equal("before a 2", $BEFORE_A_2)
end

assert("after callback twice") do
  c = C5.new
  c.a
  assert_equal("after a 1", $AFTER_A_1)
  assert_equal("after a 2", $AFTER_A_2)
end

assert("around callback twice") do
  c = C6.new
  c.a
  assert_equal("around a 1", $AROUND_A_1_1)
  assert_equal("around a 2", $AROUND_A_2_1)
  assert_equal("around a 1", $AROUND_A_1_2)
  assert_equal("around a 2", $AROUND_A_2_2)
end

assert("before callback returning nil does not stop execution") do
  $A = nil
  c = C9.new
  c.a
  assert_equal('a', $A)
end

assert("before callback returning false stops execution") do
  $A = nil
  c = C10.new
  c.a
  assert_equal(nil, $A)
end

assert("around callback with next stops execution") do
  $A = nil
  c = C12.new
  c.a
  assert_equal(nil, $A)
end

assert("before callback with if option returning true") do
  $BEFORE_A = nil
  f = F1.new
  f.a
  assert_equal('before a', $BEFORE_A)
end

assert("before callback with if option returning false") do
  $BEFORE_A = nil
  f = F2.new
  f.a
  assert_equal(nil, $BEFORE_A)
end

assert("before callback with if option calling instance method returning true") do
  $BEFORE_A = nil
  f = F3.new
  f.a
  assert_equal('before a', $BEFORE_A)
end

assert("before callback with if option calling instance method returning false") do
  $BEFORE_A = nil
  f = F4.new
  f.a
  assert_equal(nil, $BEFORE_A)
end
