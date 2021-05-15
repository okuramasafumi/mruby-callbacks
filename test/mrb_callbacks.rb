##
## Callbacks Test
##

assert("Callbacks#hello") do
  t = Callbacks.new "hello"
  assert_equal("hello", t.hello)
end

assert("Callbacks#bye") do
  t = Callbacks.new "hello"
  assert_equal("hello bye", t.bye)
end

assert("Callbacks.hi") do
  assert_equal("hi!!", Callbacks.hi)
end
