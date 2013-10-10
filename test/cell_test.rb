require 'test/unit'
require './app/extras/cell.rb'


class MyTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Cell initialize
  def test_initialize_fixed_value
    c = Cell.new(1)
    assert(c.get_fixed_value == 1, message="Fixed value not correctly initialized")
  end

  def test_initialize_possible_values
    c = Cell.new([1,2,3,4])
    assert(c.get_possible_values==[1,2,3,4], message="Possible values not correctly initialized")
  end

  def test_reset_possible_values
    c = Cell.new()
    c.add_possible_value(1)
    c.reset_possible_values
    self.assert(c.get_possible_values==[], message="Possible values not reset.")
  end

  def test_add_possible_value
    c = Cell.new()
    c.add_possible_value(1)
    self.assert(c.get_possible_values==[1])
    c.add_possible_value(2)
    self.assert(c.get_possible_values==[1,2])
  end

  def test_contains_candidate
    c = Cell.new([1,2,3,4])
    self.assert(c.contains_possible_value(2), message="Contains candidate returns false when should be true.")
    self.assert(not(c.contains_possible_value(9)), message="Contains candidate returns true when should be false.")
  end


  def test_copy
    c = Cell.new([1,2,3,4])
    d = c.copy
    self.assert(c.get_possible_values==d.get_possible_values, message="Copied cell contains incorrect possible values")
    self.assert(c.get_fixed_value==d.get_fixed_value, message="Copied cell contains incorrect fixed values")
    c.set_fixed_value(1)
    self.assert(c.get_possible_values!=d.get_possible_values, message="Source cell changes corrupt copied cell.")
    self.assert(c.get_fixed_value!=d.get_fixed_value, message="Source cell changes corrupt copied cell.")
  end

end