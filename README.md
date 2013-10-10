# PhgSudokuSolver

##A simple little gem for solving sudoku puzzles.##

**Miles Porter**<br>
**Senior Software Consultant**<br>
**Painted Harmony Group, Inc.**<br>
**mporter@paintedharmony.com**<br>


# Background:
I first started doing Sudoku puzzles a few years ago while on a 3 hour plane flight. I was hooked. Eventually, I came
across a Sudoku that I could not do. I was completely frustrated, and the puzzle that I was working on was printed in a
weekly newspaper and I didn't want to wait an entire week to see the solution. So, I did what any good software engineer
would do... I decided to write a program/algorithm to solve the puzzle. At first, I tried the brute-force method of
plugging in random numbers. I quickly discovered that would never work because there are just too many combinations...
I continued to think about how to write code to solve Sudoku puzzles. There are, of course, countless sites and free
software that provide solutions to the problem. I wanted, however, to see if I could do it myself. The result of that
effort is what you see in front fo you. The code uses a number of different techniques to try and deduce what values
can be inferred by the puzzle. After all the inferred cells are set, the program uses recursion to complete the puzzle.
## Installation

Add this line to your application's Gemfile:

    gem 'phg_sudoku_solver'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phg_sudoku_solver

## Usage

The following snipit illustrates show to use this gem (taken from tests, mind you.)


Create a new Sudoku instance by passing in an array of 9 strings.  Each string needs to be 9 characters.  Any non-
numeric character (1-9) is considered to be an unsolved cell.  You can use spaces, Xs or whatever you like.

Call the `.solve` method on the sudoku instance that you create.

To get the results of the solved sudoku, you can
1)  Call the '.dump_known_cells_str' method, which will return a formatted string that represents the solved puzzle.
2)  Iterate over the '.get_fixed_value(r,c)' method, where r and c represent the row and column.  The data returned
    will be the value found for that cell.


Example from irb...

<pre>
require 'phg_sudoku_solver'
a = [  "5xx4x67xx",
       "xxx5xx9xx",
       "2xxx17x4x",
       "xxx72xx1x",
       "9xxxxxxx8",
       "x7xx68xxx",
       "x3x27xxx5",
       "xx4xx3xxx",
       "xx26x4xx3"]

s = Sudoku.new(a)

x = s.solve

x.dump_known_cells_str

  5   1   8 |   4   9   6 |   7   3   2
  6   4   7 |   5   3   2 |   9   8   1
  2   9   3 |   8   1   7 |   5   4   6
 ----------------------------------------
  3   8   5 |   7   2   9 |   6   1   4
  9   2   6 |   1   4   5 |   3   7   8
  4   7   1 |   3   6   8 |   2   5   9
 ----------------------------------------
  8   3   9 |   2   7   1 |   4   6   5
  1   6   4 |   9   5   3 |   8   2   7
  7   5   2 |   6   8   4 |   1   9   3
</pre>
Note:  The display has been cleaned up a bit above.

## WHEN SOMETHING GOES WRONG...  AND SOMETHING ALWAYS GOES WRONG...

1.  If the sudoku entered is invalid, the solve method will return an error.

<pre>
a = ['123123123']
s = Sudoku.new(a)
Exception: Sudoku entered appears to be invalid.
...
</pre>

2.  Some sudoku are just to complex for the engine to compute a solution in the given maximum iterations

<pre>
a = ["123456789","xxxxxxxxx","xxxxxxxxx","xxxxxxxxx","xxxxxxxxx","xxxxxxxxx","xxxxxxxxx","xxxxxxxxx","xxxxxxxxx"]
s = Sudoku.new(a)
x = s.solve
Exception: Solution taking too long!
</pre>



Note:  The number of iterations are checked after each recursion, so there total iterations may exceed the max
iterations set.  You can set the max iterations like this:

`s.set_max_iterations(500)`

I have created a sample app running on Heroku (that includes a link to source code) that uses the gem...

[Sample App Running On Heroku](http://serene-brook-6810.heroku.com/)

More features will be released at some point.  Enjoy!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
