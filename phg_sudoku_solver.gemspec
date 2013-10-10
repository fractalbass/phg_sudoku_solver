# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'phg_sudoku_solver/version'

Gem::Specification.new do |gem|
  gem.name          = "phg_sudoku_solver"
  gem.version       = PhgSudokuSolver::VERSION
  gem.authors       = ["Miles Porter"]
  gem.email         = ["mporter@paintedharmony.com"]
  gem.description   = "A simple sudoku solving utility that uses two dimensional arrays and recursion."
  gem.summary       = "A simple sudoku solving utility"
  gem.homepage      = "http://rubygems.org/gems/phg_sudoku_solver"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license       = 'MIT'
end
