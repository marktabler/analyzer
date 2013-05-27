module Analyzer
  class KendallTau
    include Math

    # Confidence tables from Oxford Dictionary of Statistics via
    # http://www.answers.com/topic/critical-values-for-kendall-s
    # Numbers greater than 1 indicate no possibility of confidence
    # for the given size of the data set

    SIG_P5 =  [2, 
               2, 2, 2, 2, 1, 0.867, 0.714, 0.643, 0.556, 0.511,
               0.491, 0.455, 0.436, 0.407, 0.390, 0.383, 0.368, 0.346, 0.333, 0.326, 
               0.314, 0.307, 0.296, 0.290, 0.287, 0.280, 0.271, 0.265, 0.261, 0.255]

    SIG_P1 =  [2,
               2, 2, 2, 2, 2, 1, 0.905, 0.786, 0.722, 0.644,
               0.6, 0.576, 0.564, 0.516, 0.505, 0.483, 0.471, 0.451, 0.439, 0.421,
               0.410, 0.394, 0.391, 0.377, 0.367, 0.360, 0.356, 0.344, 0.340, 0.333]

    SIG_P5_40 = 0.218
    SIG_P1_40 = 0.285

    X = 0
    Y = 1

    def initialize(set_x, set_y)
      @x = set_x
      @y = set_y
      raise "Sets X (#{x.size} elements) and Y (#{y.size} elements) do not form a square table" unless @x.size == @y.size
    end

    def correlation
      return @correlation if @correlation
      examine_pairs
      @correlation = (nc - na) / Math.sqrt((nc + na + nx) * (nc + na + ny))
    end

    def to_s
      relationship
    end

    def to_f
      correlation.round(4)
    end

    def p1?
      return false unless sufficient_data?
      if @x.size <= 30
        correlation.abs >= SIG_P1[@x.size]
      else
        correlation.abs >= SIG_P1_40
      end
    end

    def p5?
      return false unless sufficient_data?
      if @x.size <= 30
        correlation.abs >= SIG_P5[@x.size]
      else
        correlation.abs >= SIG_P5_40
      end
    end

    def significant?
      p5?
    end

    def direct?
      significant? && correlation > 0
    end

    def inverse?
      significant? && correlation < 0
    end

    def independent?
      !significant?
    end

    def sufficient_data?
      @x.size >= 5
    end

    def relationship
      return "Insufficient Data" unless sufficient_data?
      return "Independent" if independent?
      "#{direction}, p <= #{confidence}"
    end

    private

    def examine_pairs
      pairs = @x.zip(@y)
      @nc, @na, @nx, @ny = 0, 0, 0, 0
      pairs.each_with_index do |pair, index|
        pairs[(index + 1)..-1].each do |comp_pair|
          compare(pair, comp_pair)
        end
      end
    end

    def compare(pair, comp_pair)
      if pairs_concordant?(pair, comp_pair)
        @nc += 1
      elsif pair[Y] == comp_pair[Y]
        @ny += 1
      elsif pair[X] == comp_pair[X]
        @nx += 1
      else
        @na += 1
      end
    end

    def pairs_concordant?(pair, comp_pair)
      ((pair[X] > comp_pair[X]) && (pair[Y] > comp_pair[Y])) ||
      ((pair[X] < comp_pair[X]) && (pair[Y] < comp_pair[Y]))
    end

    def direction
      if correlation > 0
        "Direct"
      else
        "Inverse"
      end
    end

    def confidence
      if p1?
        "0.01"
      elsif p5?
        "0.05"
      else
        "None"
      end
    end

    # Concordant pairs
    def nc
      @nc
    end

    # Discordant pairs
    def na
      @na
    end

    # Ties on X value
    def nx
      @nx
    end

    # Ties on Y value
    def ny
      @ny
    end
  end
end