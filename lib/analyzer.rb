require 'benchmark'
require_relative 'analyzer/kendall_tau'
require_relative 'analyzer/mann_whitney'
require_relative 'analyzer/phi_coefficient'
require_relative 'analyzer/diagnostics'

module Analyzer

  def self.build(set_x, set_y)
    if both_sets_dichotomous?(set_x, set_y)
      PhiCoefficient.new(set_x, set_y)
    elsif one_set_dichotomous?(set_x, set_y)
      MannWhitney.new(set_x, set_y)
    else
      KendallTau.new(set_x, set_y)
    end
  end

  def self.both_sets_dichotomous?(set_x, set_y)
    set_x.uniq.size == 2 && set_y.uniq.size == 2
  end

  def self.one_set_dichotomous?(set_x, set_y)
    set_x.uniq.size == 2 || set_y.uniq.size == 2
  end

  def self.correlation(set_x, set_y)
    self.build(set_x, set_y).correlation
  end

  def self.benchmarks
    KendallTau.benchmark
    MannWhitney.benchmark
  end
end
