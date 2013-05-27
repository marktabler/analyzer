module Analyzer
  class MannWhitney
    include Math

    def initialize(set_x, set_y)
      @dichotomous, @ordinal = identify_dichotomous_set(set_x, set_y)
      @keys = [@dichotomous.uniq.first, @dichotomous.uniq.last]
    end

    def correlation
      return @z if @z
      examine_rankings
      @u = @ranks.values.max
      @z = ((@u - mu) / ou).abs
    end

    def significant?
      @z >= 1.96 && sufficient_data?
    end

    def sufficient_data?
      (n1 >= 4 || n2 >= 4) && n1 + n2 >= 12
    end

    def to_f
      correlation.round(4)
    end

    def to_s
      relationship
    end

    def relationship
      if significant?
        if @ranks[@keys.first] > @ranks[@keys.last]
          "Direct for #{@keys.first}, z = #{@z}"
        else
          "Direct for #{@keys.last}, z = #{@z}"
        end
      elsif sufficient_data?
        "Independent"
      else
        "Insufficient Data"
      end
    end

    private

    def identify_dichotomous_set(set_x, set_y)
      set_x_dichotomous = set_x.uniq.size == 2
      set_y_dichotomous = set_y.uniq.size == 2
      if set_x_dichotomous == set_y_dichotomous
        raise "Exactly one set must contain 2 discrete terms. X: #{set_x.uniq.size} terms; Y: #{set_y.uniq.size} terms. "
      elsif set_x_dichotomous
        [set_x, set_y]
      else
        [set_y, set_x]
      end
    end

    def examine_rankings
      @ranks = Hash.new(0)
      pairs = @dichotomous.zip(@ordinal)
      pairs.each do |pair|
        pairs.each do |comp_pair|
          compare(pair, comp_pair)
        end
      end
    end

    def compare(pair, comp_pair)
      return if pair.first == comp_pair.first
      if pair.last.to_f > comp_pair.last.to_f
        @ranks[pair.first] += 1
      elsif pair.last == comp_pair.last
        @ranks.keys.each do |key|
          @ranks[key] += 0.5
        end
      end
    end

    def mu
      (n1 * n2) / 2.0
    end

    def ou
      Math.sqrt((n1 * n2 * (n1 + n2 + 1)) / 12.0)
    end

    def n1
      @dichotomous.select{|n| n == @keys.first}.size
    end

    def n2
      @dichotomous.size - n1
    end
  end
end