# defining-ruby-methods.rb

class Example
  def an_instance_method
    'an instance method'
  end

  def self.a_class_method
    'a class method'
  end

  def self.another_class_method
    'another class method'
  end
end

Example.a_class_method # => a class method
Example.another_class_method # => another class method
Example.methods(false) # => [:a_class_method, :another_class_method]
Example.instance_methods - Object.methods # => [:an_instance_method]

# defining a new class method
Example.define_singleton_method(:a_new_class_method) do
  'a new class method'
end

Example.a_new_class_method # => a new class method

class Example
  def self.a_newer_class_method
    'an even newer class method'
  end
end

Example.a_newer_class_method # => an even newer class method

Example.instance_eval do
  def goodbye
    'hello'
  end
end

Example.goodbye # => hello

# **************** create a new instance of Example ************************

instance = Example.new
instance2 = Example.new

instance.an_instance_method # => an instance method
instance.class # => Example

# viewing an instance's unique instance methods
instance.methods - Object.methods # => [:an_instance_method]
instance.singleton_class.instance_methods - Object.methods # => [:an_instance_method]

def instance.new_thing
  'wow!'
end

instance.new_thing # => wow!

def instance.define_singleton_method(:new_thing) do
  'wowza!'
end

instance.new_thing  # => wowza!

class << instance 
  def new_thing
    'wowza bo bowza!'
  end
end

instance.new_thing # => wowza bo bowza!
instance2.new_thing # => undefined method `new_thing' for #<Example:0x007f8b8b8b8b38>


instance.instance_eval do
  def hello
    'goodbye'
  end
end

instance.methods - Object.methods # => [:hello, :new_thing :an_instance_method]
instance2.methods - Object.methods # => [:an_instance_method]



#applies to all instances 
Example.class_eval do
  def last
    'fin'
  end
end

instance.last # => fin
instance2.last # => fin
