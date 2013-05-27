module Analyzer

    MW_TEST_A = [[true, true, false, false, true, false, true, false],
                 [1, 2, 3, 4, 5, 6, 7, 8]]

    MW_TEST_B = [[1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8],
                 [true, true, false, false, true, false, true, false, true, true, false, false, true, false, true, false]]

    MW_TEST_C = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                 [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 7, 8, 9, 7, 8, 9, 7, 8, 9, 1]]

    MW_TEST_D = [[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                 [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 7, 8, 9, 7, 8, 9, 7, 8, 9, 1]]
   
    MW_TEST_E = [[1, 2, 3],
                 [4, 5, 6]]
    MW_TEST_F = [[1, 0, 1, 0, 1, 1, 1, 0],
                 [0, 1, 0, 1, 1, 1, 0, 1]]

    KT_TEST_A = [[4, 2, 5, 0.5, 1.5, 2, 0, 1, 0, 1.5, 0],
              [7, 8, 4, 5.5, 4.5, 4, 5, 3, 2, 0.5, 1]]
    KT_TEST_B = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
              [12, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 1]]
    KT_TEST_C = [[5, 2, 5],
              [3, 4, 4]]
    KT_TEST_D = [[1, 2],
              [3, 4]]
    KT_TEST_E = [[5, 10, 15, 20],
              [4, 20, 16, 12]]
    KT_TEST_F = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              [2, 3, 4, 5, 6, 7, 6, 9, 10, 11]]
    KT_TEST_G = [[16, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
              [45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 55]]

  def self.test
    kt_sets = [KT_TEST_A, KT_TEST_B, KT_TEST_C, KT_TEST_D, KT_TEST_E, KT_TEST_F, KT_TEST_G]
    mw_sets = [MW_TEST_A, MW_TEST_B, MW_TEST_C, MW_TEST_D, MW_TEST_E, MW_TEST_F]
    (kt_sets + mw_sets).each do |set|
      a = self.build(*set)
      a.display_diagnostics
    end
    puts "Analyzer self test complete"
  end

  class KendallTau
  
    def self.test
      puts "Confidence charts"
      puts "\np <= 0.05:"
      SIG_P5.each_with_index do |p, n|
        puts "#{n} : #{p}" unless p > 1
      end
      puts "\np <= 0.01:"
      SIG_P1.each_with_index do |p, n|
        puts "#{n} : #{p}" unless p > 1
      end
      sets = TEST_KA, TEST_KB, TEST_KC, TEST_KD, TEST_KE, TEST_KF, TEST_KG
      sets.each do |set|
        taub = self.new(*set)
        taub.send(:display_diagnostics)
      end
      puts "\nKendall Tau Test Complete."
    end

    def self.benchmark
      year_set = [[], []]
      month_set = [[], []]
      365.times do
        year_set.first << rand(100)
        year_set.last << rand(100)
      end
      31.times do
        month_set.first << rand(100)
        month_set.last << rand(100)
      end
      Benchmark.bm(19) do |x|
        x.report("KT Year Set x 100:    ") { 100.times { KendallTau.new(*year_set).correlation } }
        x.report("KT Month set x 10000: ") { 10000.times { KendallTau.new(*month_set).correlation } }
      end
    end
    
    def display_diagnostics
      puts "\n---------------------"
      puts "Analyzer: #{self.class}"
      puts "---------------------"
      puts "Correlation: #{correlation} "
      puts "Relationship: #{relationship}"
      puts "---------------------"
      puts "Set X:      #{@x}"
      puts "Set Y:      #{@y}"
      puts "---------------------"
      puts "Concordant: #{@nc}"
      puts "Discordant: #{@na}"
      puts "Tied X:     #{@nx}"
      puts "Tied Y:     #{@ny}"
      puts "---------------------\n"
    end
  end

  class MannWhitney


    def self.test
      invert_b = [MW_TEST_B.last.map(&:!), MW_TEST_B.first]
      [MW_TEST_A, MW_TEST_B, invert_b, MW_TEST_C, MW_TEST_D, MW_TEST_E, MW_TEST_F].each do |set|
        begin
          mw_test = self.new(*set)
          mw_test.display_diagnostics
        rescue Exception => e
          puts "Error caught in test set:"
          puts e.message
        end
      end
      puts "\nMann-Whitney Test Complete"
    end

    def self.benchmark
      year_set = [[], []]
      month_set = [[], []]
      365.times do
        year_set.first << [true, false].sample
        year_set.last << rand(100)
      end
      31.times do
        month_set.first << [true, false].sample
        month_set.last << rand(100)
      end
      Benchmark.bm(19) do |x|
        x.report("MW-U Year Set x 100:    ") { 100.times { MannWhitney.new(*year_set).correlation } }
        x.report("MW-U Month set x 10000: ") { 10000.times { MannWhitney.new(*month_set).correlation } }
      end
    end

    def display_diagnostics
      puts "\n---------------------"
      puts "Analyzer: #{self.class}"
      puts "---------------------"
      puts "Correlation (z): #{correlation}"
      puts "Ordinal set: #{@ordinal}"
      puts "Dichotomous set: #{@dichotomous}"
      puts "Ranks: #{@ranks}"
      puts "Keys: #{@keys}"
      puts "n1: #{n1}"
      puts "n2: #{n2}"
      puts "u: #{@u}"
      puts "z: #{@z}"
      puts "relationship: #{relationship}"
      puts "--------------------------------\n\n"
    end
  end
end