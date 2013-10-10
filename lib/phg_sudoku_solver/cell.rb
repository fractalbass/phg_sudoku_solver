#
# Cell.rb
#
# Created on September 23, 2013
#
# A class that contains the logic for a single cell in a sudoku puzzle.
#

class Cell

  def initialize *args
    @fixed_value = -1
    @possible_values = []
    if args.size==1
      case args[0].class.to_s
        when "Array"
          @possible_values = args[0]
        when "Fixnum"
          @fixed_value = args[0]
      end
    end
  end


  def reset_possible_values()
    @possible_values = []
  end

  def add_possible_value(val)
    @possible_values.push(val)
    if @possible_values.count > 1
      @fixed_value = -1
    end
  end

  def set_possible_values(val)
    @possible_values = val
  end

  def set_fixed_value(val)
    @fixed_value = val
    if val>0
      @possible_values = []
    end
  end

  def get_fixed_value()
    @fixed_value
  end

  def get_possible_values()
    @possible_values
  end

  def contains_possible_value(x)
    @possible_values.include?(x)
  end

  def copy()
    c = Cell.new()
    c.set_fixed_value(@fixed_value)
    c.set_possible_values(@possible_values)
    c
  end
end
