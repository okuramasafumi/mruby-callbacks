[![CI](https://github.com/okuramasafumi/mruby-callbacks/actions/workflows/main.yml/badge.svg)](https://github.com/okuramasafumi/mruby-callbacks/actions/workflows/main.yml)

# mruby-callbacks

Callback implementation for mruby.

## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'okuramasafumi/mruby-callbacks'
end
```

## example

`include Callbacks` in your class/module and you're all set to use `define_callback`!

```ruby
class MyClass
  include Callbacks

  def my_method
    puts 'my method'
  end

  define_callback :before, :my_method do
    puts 'my before hook'
  end
end

MyClass.new.my_method
# => "my before hook\nmy method\n"
```

## Halting

You can halt hook and method body execution by returning `false`.

```ruby
class MyClass
  include Callbacks

  def my_method
    puts 'my method'
  end

  define_hook :before, :my_method do
    false
  end
end

MyClass.new.my_method
# => ""
```

## License
under the MIT License:
- see LICENSE file
