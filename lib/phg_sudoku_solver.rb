require 'phg_sudoku_solver/version'
require 'phg_sudoku_solver/cell'
#
# Sudoku.rb
#
# Created on September 23, 2013
#
#

class Sudoku

  def set_max_iterations(iterations)
    @max_iterations=iterations
  end

  def set_total_iterations(iterations)
    @total_iterations = iterations
  end

  def initialize (*args)
    @total_iterations = 0
    @max_iterations = 100000
    @debug = false
    @cells = Array.new(9) { Array.new(9) }

    if args.size==1
      (0..8).each { |row|
        if args[0][row].is_a?(String)
          (0..8).each { |col|
            val = args[0][row][col]
            if /[0-9]/.match(val)
              @cells[row][col] = Cell.new(val.to_i)
            else
              @cells[row][col] = Cell.new()
            end
          }
        end
      }
    elsif args.size==0
      (0..8).each { |row|
        (0..8).each { |col|
          @cells[row][col] = Cell.new()
        }
      }
    end
  end

  def get_cells
    @cells
  end

  def set_cells(row, col, cell)
    @cells[row][col]=cell
  end

  def get_fixed_value(row, col)
    @cells[row][col].get_fixed_value()
  end

  def set_fixed_value(row, col, val)
    @cells[row][col].set_fixed_value(val)
  end

  def set_possible_values(row, col, vals)
    @cells[row][col].set_possible_values(vals)
  end

  def add_possible_value(row, col, val)
    @cells[row][col].add_possible_value(val)
  end

  def get_possible_values(row, col)
    @cells[row][col].get_possible_values
  end

  def get_total_iterations
    @total_iterations
  end

  def solve
    iteration=0
    no_progress_count = 0

    while @solved_cell_count!=81
      iteration+=1
      @total_iterations+=1
      print_debug 'Iteration: %s   SolvedCells: %s\n' % [iteration, @solved_cell_count]
      compute_possible_values()

      begin
        if validate_sudoku()
          find_row_implied_values()
          find_col_implied_values()
          find_matrix_implied_values()
        else
          return nil
        end
      rescue Exception => error
        print_debug '\nValidation Error: %s\n' % error
        @solved_cell_count=count_fixed_cells()
        return nil
      end


      if @solved_cell_count==count_fixed_cells()
        no_progress_count+=1
        if no_progress_count>9
          print_debug ('We''re not making progress here!')
          if @total_iterations > @max_iterations
            print 'Total Iterations... %s\n' % @total_iterations
            print 'This is just taking too long\n'
            raise Exception.new('Solution taking too long!\n\n')
          end
          solution = recurse()
          return solution
        end
      else
        no_progress_count=0
        @solved_cell_count=count_fixed_cells()
      end
    end
    self
  end

  def count_fixed_cells
    fixed_cell_count=0

    @cells.each() do |row|
      row.each() do |cell|
        fixed_cell_count = fixed_cell_count + 1 if cell.get_fixed_value != -1
      end
    end
    fixed_cell_count
  end

  def find_row_implied_values

    (1..9).each { |i|
      (0..8).each { |r|
        fixed_count = 0
        variable_count = 0
        temp_row = -1
        temp_col = -1
        (0..8).each { |c|
          # Start by counting up fixed values for the given number i.  (e.g. How many of i do we have?)
          if @cells[r][c].get_fixed_value()==i
            fixed_count+=1
          end

          #  We are checking to see if there is only one i in the possible values for this row.
          #  If so, then we will set the fixed value in the cell contains it.
          (0..@cells[r][c].get_possible_values().count).each { |j|
            if @cells[r][c].get_possible_values()[j]==i
              variable_count+=1
              temp_row = r
              temp_col = c
            end
          }

        }
        if (fixed_count==0) and (variable_count==1)
          @cells[temp_row][temp_col].set_fixed_value(i)
        end

        if fixed_count>1
          raise('Duplicate fixed values in row check.  Make sure you entered correct values.')
        end
      }
    }
  end

  def find_col_implied_values
    (1..9).each { |i|
      (0..8).each { |c|
        fixed_count = 0
        variable_count = 0
        temp_row = -1
        temp_col = -1
        (0..8).each { |r|
          if @cells[r][c].get_fixed_value()==i
            fixed_count+=1
          end

          (0..@cells[r][c].get_possible_values().count).each { |j|
            if @cells[r][c].get_possible_values()[j]==i
              variable_count+=1
              temp_row = r
              temp_col = c
            end
          }

        }
        if (fixed_count==0) and (variable_count==1)
          @cells[temp_row][temp_col].set_fixed_value(i)
        end

        if fixed_count>1
          raise('Duplicate fixed value in column check.  Make sure you entered correct values.')
        end
      }
    }
  end

  def find_matrix_implied_values
    # In each sub-matrix we check for implied values (i) one at a time...
    [0, 3, 6].each { |row_start|
      [0, 3, 6].each { |col_start|
        (1..9).each { |i|
          temp_row = 0
          temp_col = 0
          fixed_count = 0
          variable_count = 0
          (row_start..row_start+2).each { |r|
            (col_start..col_start+2).each { |c|

              if @cells[r][c].get_fixed_value()==i
                fixed_count+=1
              end

              (0..@cells[r][c].get_possible_values().count).each { |j|
                if @cells[r][c].get_possible_values()[j]==i
                  variable_count+=1
                  temp_row = r
                  temp_col = c
                end
              }
            }
          }

          if (fixed_count==0) and (variable_count==1)
            @cells[temp_row][temp_col].set_fixed_value(i)
          end

          if fixed_count>1
            raise('Duplicate fixed value in matrix check.  Make sure you entered correct values.')
          end
        }
      }
    }
  end


  def compute_possible_values

    (0..8).each { |r|
      (0..8).each { |c|
        if @cells[r][c].get_fixed_value()<=0
          @cells[r][c].reset_possible_values()

          (1..9).each { |possible_value|
            if check_row_value(r, c, possible_value) and check_col_value(r, c, possible_value) and check_matrix_value(r, c, possible_value)
              add_possible_value(r, c, possible_value)
            end

          }
          if @cells[r][c].get_possible_values().count==1
            fixed_val = @cells[r][c].get_possible_values()[0]
            @cells[r][c].set_fixed_value(fixed_val)
            print_debug 'Resetting possible values...'
            @cells[r][c].reset_possible_values()
          elsif @cells[r][c].get_possible_values().count>1
            @cells[r][c].set_fixed_value(-1)
          end
        end
      }
    }
  end

  def check_row_value(row, col, val)
    result = true
    (0..8).each { |current_column|
      if current_column!=col
        if @cells[row][current_column].get_fixed_value()==val
          result = false
        end
      end
    }
    result
  end

  def check_col_value(row, col, val)
    result = true
    (0..8).each { |r|
      if r!=row
        if @cells[r][col].get_fixed_value()==val
          result = false
        end
      end
    }
    result
  end

  def check_matrix_value(row, col, val)
    result = true
    row_start = (row/3).floor * 3
    col_start = (col/3).floor * 3
    (row_start..row_start+2).each { |y|
      (col_start..col_start+2).each { |x|
        unless row==y and col==x
          if @cells[y][x].get_fixed_value()==val
            result = false
          end
        end
      }
    }
    result
  end

  def recurse
    recurse = copy()
    (0..8).each { |r|
      (0..8).each { |c|
        if (recurse.get_fixed_value(r, c)<=0) and (recurse.get_possible_values(r, c).count>0)
          (0..recurse.get_possible_values(r, c).count).each { |j|
            unless recurse.get_possible_values(r, c)[j].nil?
              print_debug '\nStarting recursion with (%s,%s) set to %s\n' % [r, c, recurse.get_possible_values(r, c)[j]]
              recurse.set_fixed_value(r, c, recurse.get_possible_values(r, c)[j])
              print_debug('Recursion starting...')
              recurse = recurse.solve
              if recurse!=nil
                return recurse
              else
                recurse = copy()
              end
            end
          }
        end
      }
    }
    print_debug('Dead end found.\n')
    nil
  end

  def copy
    s = Sudoku.new()
    (0..8).each { |r|
      (0..8).each { |c|
        copied_cell = @cells[r][c].copy
        s.set_cells(r, c, copied_cell)
      }
    }
    s.set_max_iterations(@max_iterations)
    s.set_total_iterations(@total_iterations)
    s
  end

  def validate_sudoku
    results = true
    begin
      (0..8).each { |r|
        validate_row(r)
      }

      (0..8).each { |c|
        validate_column(c)
      }

      [0, 3, 6].each { |r|
        [0, 3, 6].each { |c|
          validate_matrix(r, c)
        }
      }
    rescue Exception => error
      print_debug '\nValidation Error: %s\n' % error
      results = false
    end
    results
  end

  def validate_row(r)
    
    (1..9).each { |i|
      found_count=0
      (0..8).each { |c|
        if @cells[r][c].get_fixed_value()==i
          found_count+=1
        end
      }
      if found_count>1
        raise Exception.new('Row invalid.  Canceling')
      end
    }
    true
  end


  def validate_column(c)

    (1..9).each { |i|
      found_count = 0
      (0..8).each { |r|
        if @cells[r][c].get_fixed_value()==i
          found_count+=1
        end
      }
      if found_count>1
        raise Exception.new('Row invalid.  Canceling')
      end
    }
    true
  end


  def validate_matrix(r, c)
    (1..9).each { |i|
      found_count=0
      row_start = (r/3).floor * 3
      col_start = (c/3).floor * 3
      (row_start..row_start+2).each { |y|
        (col_start..col_start+2).each { |x|
          if @cells[y][x].get_fixed_value()==i
            found_count+=1
          end

        }
      }
      if found_count>1
        raise Exception.new('Matrix invalid! Canceling.')
      end
    }
    true
  end


  def set_debug(b)
    @debug = b
  end

  def dump_to_str
    if @debug
      print '\n'
      (0..8).each { |row|
        (0..8).each { |col|
          printf('   %3s     | ' % @cells[row][col].get_fixed_value())
          if col == 2 or col == 5
            print '| '
          end

        }
        print '\n'
        (0..8).each { |col|
          array = @cells[row][col].get_possible_values()
          if array==[]
            array = '--'
          end
          printf(' %10s  ' % array)
          if col == 2 or col == 5
            print '| '
          end
        }
        print '\n\n'
      }
    end
  end

  def dump_known_cells_str

    result = '\n'
    for row in (0..8)
      (0..8).each do |col|
        if @cells[row][col].get_fixed_value() > 0
          val = @cells[row][col].get_fixed_value()
        else
          val = ' '
        end
        result+='%3s ' % val
        if col == 2 or col == 5
          result+= '| '
        end
      end
      if row==2 or row==5
        result+= '\n----------------------------------------\n'
      else
        result+= '\n'
      end
    end
    result
  end

  def print_debug(message)
    if @debug
      print message
    end
  end

end

