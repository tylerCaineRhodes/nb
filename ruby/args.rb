# array splat operator

def sum(*numbers) # when defining, turns into an array
  numbers.reduce(0, :+)
end

sum(1, 2, 3) # => 6
array = [4, 5, 6]

# when calling, splits the array into separate args
sum(*array) # => 15


# double splat operator


def greet(name:, greeting:) # when defining, turns into n kwargs - def greet(**kwargs); end
  "#{greeting}, #{name}!"
end

opts = { name: "Alice", greeting: "Hello" }

# when calling, converts hash to kwargs
greet(**opts) # => "Hello, Alice!"


# passing through multiple functions

def foo(*args)
  bar(*args)
end

def bar(*args)
  args.sum
end

foo(1, 2, 3) # => 6


def foo(**kwargs)
  bar(**kwargs)
end

def bar(name:, greeting:)
  "#{greeting}, #{name}!"
end

foo(name: "Alice", greeting: "Hello") # => "Hello, Alice!"

