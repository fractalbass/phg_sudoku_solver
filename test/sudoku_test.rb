require 'test/unit'
require '../lib/phg_sudoku_solver'
require '../lib/phg_sudoku_solver/cell'

class PhgSudokuSolverTest < Test::Unit::TestCase

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
  def test_initialize_sudoku
    a = ['123456789',
         '123456789',
         '123456789',
         '123456789',
         '123456789',
         '123456789',
         '123456789',
         '123456789',
         '123456789']

    s = Sudoku.new(a)
    #print "\n\n"
    #for row in (0..8)
    #  for col in (0..8)
    #    print s.getFixedValue(row,col)
    #  end
    #  print "\n"
    #end
    #print "\n\n"

    self.assert(s.get_fixed_value(0,0)==1, message="Incorrect value returned")
    self.assert(s.get_fixed_value(0,8)==9, message="Incorrect value returned")
    self.assert(s.get_fixed_value(8,0)==1, message="Incorrect value returned")
    self.assert(s.get_fixed_value(8,8)==9, message="Incorrect value returned")
    self.assert(s.get_fixed_value(4,5)==6, message="Incorrect value returned")
  end

  def test_initialize_sparse_sudoku
    a = [ "5xx4x67xx",
          "xxx5xx9xx",
          "2xxx17x4x",
          "xxx72xx1x",
          "9xxxxxxx8",
          "x7xx68xxx",
          "x3x27xxx5",
          "xx4xx3xxx",
          "xx26x4xx3"]

    s = Sudoku.new(a)
    x=s.get_fixed_value(0,0)
    self.assert(x==5, message="Incorrect value returned. Expected %s but got %s" % [5, x])

    x=s.get_fixed_value(0,8)
    self.assert(x==-1, message="Incorrect value returned.  Expected %s but got %s" % [-1, x])

    x=s.get_fixed_value(8,0)
    self.assert(x==-1, message="Incorrect value returned.  Expected %s but got %s" % [-1, x])

    x=s.get_fixed_value(8,8)
    self.assert(x==3, message="Incorrect value returned.  Expected %s but got %s" % [3, x])

    x=s.get_fixed_value(5,5)
    self.assert(x==8, message="Incorrect value returned. Expected %s but got %s" % [8, x])
  end

  def test_count_fixed_values
    a = [ "5xx4x67xx",  #4
          "xxx5xx9xx",  #2
          "2xxx17x4x",  #4
          "xxx72xx1x",  #3
          "9xxxxxxx8",  #2
          "x7xx68xxx",  #3
          "x3x27xxx5",  #4
          "xx4xx3xxx",  #2
          "xx26x4xx3"]  #4

    s = Sudoku.new(a)
    self.assert(s.count_fixed_cells==28, message="Expected 18 fixed cells, but got  %s" % s.count_fixed_cells)
  end

  def test_set_and_get_possible_values
    s = Sudoku.new()
    s.set_possible_values(5,5,[1,2,3])
    self.assert(s.get_possible_values(5,5)==[1,2,3])
  end

  def test_find_row_implied_values
    a = [ "51849673x",
          "647532981", 
          "293817546", 
          "385729614",
          "926145378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]

    s = Sudoku.new(a)
    s.set_possible_values(0,8,[2])
    s.find_row_implied_values()
    self.assert(s.get_fixed_value(0,8)==2, message="Expected fixed value of 2, got %s" % s.get_fixed_value(0,8))
  end

  def test_find_col_implied_values
    a = [ "518496732",
          "647532981",
          "293817546",
          "385729614",
          "926145378",
          "4713x8259",
          "839271465",
          "164953827",
          "752684193"]

    s = Sudoku.new(a)
    s.set_possible_values(5,4,[6])
    s.find_col_implied_values()
    self.assert(s.get_fixed_value(5,4)==6, message="Expected fixed value of 6 in (5,4), got %s" % s.get_fixed_value(0,8))
  end

  def test_find_matrix_implied_values
          #012345678
    a = [ "518496732", #0
          "6 75 29 1", #1
          "293817546", #2
          "385729614", #3
          "9 61 53 8", #4
          "471368259", #5
          "839271465", #6
          "1 49 38 7", #7
          "752684192"] #8

    s = Sudoku.new(a)
    s.set_possible_values(1,1,[4])
    s.set_possible_values(1,4,[3])
    s.set_possible_values(1,7,[8])
    s.set_possible_values(4,1,[2])
    s.set_possible_values(4,4,[4])
    s.set_possible_values(4,7,[7])
    s.set_possible_values(7,1,[6])
    s.set_possible_values(7,4,[5])
    s.set_possible_values(7,7,[3])

    s.find_matrix_implied_values()
    self.assert(s.get_fixed_value(1,1)==4, message="Expected fixed value of 4 in (1,1), got %s" % s.get_fixed_value(1,1))
    self.assert(s.get_fixed_value(1,4)==3, message="Expected fixed value of 3 in (1,4), got %s" % s.get_fixed_value(1,4))
    self.assert(s.get_fixed_value(1,7)==8, message="Expected fixed value of 8 in (1,7), got %s" % s.get_fixed_value(1,7))
    self.assert(s.get_fixed_value(4,1)==2, message="Expected fixed value of 2 in (4,1), got %s" % s.get_fixed_value(4,1))
    self.assert(s.get_fixed_value(4,4)==4, message="Expected fixed value of 4 in (4,4), got %s" % s.get_fixed_value(4,4))
    self.assert(s.get_fixed_value(4,7)==7, message="Expected fixed value of 7 in (4,7), got %s" % s.get_fixed_value(4,7))
    self.assert(s.get_fixed_value(7,1)==6, message="Expected fixed value of 6 in (7,1), got %s" % s.get_fixed_value(7,1))
    self.assert(s.get_fixed_value(7,4)==5, message="Expected fixed value of 5 in (7,4), got %s" % s.get_fixed_value(7,4))
    self.assert(s.get_fixed_value(7,7)==3, message="Expected fixed value of 2 in (7,7), got %s" % s.get_fixed_value(7,7))
  end

  def test_row_ok
       a = [ "51849673x",
             "647532981",
             "293817546",
             "385729614",
             "926145378",
             "471368259",
             "839271465",
             "164953827",
             "752684193"]
    s=Sudoku.new(a)
    self.assert(s.check_row_value(0,8,2), message="Row Ok Test Failed.")
  end

  def test_row_NOT_ok
    a = [ "51849673x",
          "647532981",
          "293817546",
          "385729614",
          "926145378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
    self.assert(not(s.check_row_value(0,8,3)), message="Row Ok and should not have been.")
  end

  def test_col_ok
    a = [ "51849673x",
          "647532981",
          "293817546",
          "385729614",
          "926145378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
    self.assert(s.check_col_value(0,8,2), message="Row Ok Test Failed.")
  end

  def test_col_NOT_ok
    a = [ "51849673x",
          "647532981",
          "293817546",
          "385729614",
          "926145378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
    self.assert(not(s.check_col_value(0,8,3)), message="Row Ok and should not have been.")
  end

  def test_matrix_ok
    a = [ "51849673x",
          "647532981",
          "293817546",
          "385729614",
          "926145378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
    self.assert(s.check_matrix_value(4,4,4), message="Matrix Ok Test Failed.")
  end

  def test_matrix_NOT_ok
    a = [ "51849673x",
          "647532981",
          "293817546",
          "385729614",
          "9261x5378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
    self.assert(not(s.check_matrix_value(4,4,5)), message="Matrix Ok and should not have been.")
  end

  def test_comput_possible_values_1
    a = [ "51849673x",
          "647532981",
          "293817546",
          "385729614",
          "9261x5378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
    s.compute_possible_values
    self.assert(s.get_fixed_value(0,8)==2)

  end

  def test_compute_possible_values_1
          #012345678
    a = [ "1!xxxxxxx",#0
          "x2xx!xxxx",#1
          "xx3xxxx!x",#2

          "!xx4xxxxx",#3
          "xxxx5!xxx",#4
          "xxxxx6xx!",#5

          "xx!xxx7xx",#6
          "xxx!xxx8x",#7
          "xxxxxx!x9"]#8
          #012345678

    s=Sudoku.new(a)
    s.compute_possible_values
    s.dump_to_str
    val = s.get_possible_values(0,1)
    self.assert(s.get_possible_values(0,1)==[4,5,6,7,8,9], message="Cell 0,1 failed. %s" % s.get_possible_values(0,1))
    self.assert(s.get_possible_values(1,4)==[1,3,4,6,7,8,9])
    self.assert(s.get_possible_values(2,7)==[1,2,4,5,6,7,9])
    self.assert(s.get_possible_values(3,0)==[2,3,5,6,7,8,9])

    self.assert(s.get_possible_values(4,5)==[1,2,3,7,8,9])
    self.assert(s.get_possible_values(5,8)==[1,2,3,4,5,7,8])
    self.assert(s.get_possible_values(6,2)==[1,2,4,5,6,8,9])
    self.assert(s.get_possible_values(7,3)==[1,2,3,5,6,7,9])
    self.assert(s.get_possible_values(8,6)==[1,2,3,4,5,6])
  end

  def test_validate
    a = [ "518496732",
          "647532981",
          "293817546",
          "385729614",
          "9261x5378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
    self.assert(s.validate_row(0))
    self.assert(s.validate_column(3))
    self.assert(s.validate_matrix(4,4))
  end

  def test_invalid_raises_exception
    a = [ "518496733",
          "647532981",
          "293817546",
          "385729614",
          "926125378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)

    self.assert_raise(Exception) {
      s.validate_row(0) }

    self.assert_raise(Exception) {
      s.validate_column(8) }

    self.assert_raise(Exception) {
      s.validate_matrix(4,4)
    }
  end

  def test_validate_sudoku
    a = [ "518496732",
          "647532981",
          "293817546",
          "385729614",
          "926145378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)

    self.assert(s.validate_sudoku, "A perfectly good sudoku fails to validate.  Boo.")

  end

  def test_invalid_validate_sudoku
    a = [ "518496732",
          "647532981",
          "293817546",
          "385729614",
          "926185378",
          "471368259",
          "839271465",
          "164953827",
          "752684193"]
    s=Sudoku.new(a)
      self.assert(not(s.validate_sudoku), "A perfectly good sudoku fails to validate.  Boo.")

  end

  def test_solve
    a = [ "5xx4x67xx",
          "xxx5xx9xx",
          "2xxx17x4x",
          "xxx72xx1x",
          "9xxxxxxx8",
          "x7xx68xxx",
          "x3x27xxx5",
          "xx4xx3xxx",
          "xx26x4xx3"]

    s = Sudoku.new(a)
    s.set_debug(true)
    s.set_debug(false)
    solved = s.solve()
    solved.set_debug(true)
    self.assert(solved.validate_sudoku, "Solved sudoku is invalid!!!")
    self.assert(solved.count_fixed_cells==81, "Sudoku is incomplete!!!")

  end

  def test_copy
    a = [ "5xx4x67xx",
          "xxx5xx9xx",
          "2xxx17x4x",
          "xxx72xx1x",
          "9xxxxxxx8",
          "x7xx68xxx",
          "x3x27xxx5",
          "xx4xx3xxx",
          "xx26x4xx3"]
    s1 = Sudoku.new(a)
    s2 = s1.copy
    for r in (0..8)
      for c in (0..8)
        self.assert(s1.get_fixed_value(r,c) == s2.get_fixed_value(r,c))
        self.assert(s1.get_possible_values(r,c)==s2.get_possible_values(r,c))
      end
    end

  end

  def test_too_long_solve
    a = [ "123 789 456",
          "456 123 789",
          "789 456 123",

          "xxx xxx xxx",
          "xxx xxx xxx",
          "xxx xxx 231",

          "xxx xxx xxx",
          "xxx xxx xxx",
          "xxx xxx xxx"]
    s1 = Sudoku.new(a)
    s1.set_max_iterations(100)
    self.assert_raise(Exception) {
      s1.solve() }
  end


end