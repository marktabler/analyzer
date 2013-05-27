require 'benchmark'
require_relative 'analyzer/kendall_tau'
require_relative 'analyzer/mann_whitney'
require_relative 'analyzer/phi_coefficient'
require_relative 'analyzer/diagnostics'

module Analyzer

  def self.build(set_x, set_y)
    if both_sets_dichotomous?
      PhiCoefficient.new(set_x, set_y)
    elsif one_set_ordinal?
      MannWhitney.new(set_x, set_y)
    else
      KendallTau.new(set_x, set_y)
    end
  end

  def self.correlation(set_x, set_y)
    self.build(set_x, set_y).correlation
  end
end
