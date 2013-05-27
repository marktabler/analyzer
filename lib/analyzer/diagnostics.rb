module Analyzer

    MW_TEST_A = [[true, true, false, false, true, false, true, false],
                 [1, 2, 3, 4, 5, 6, 7, 8]]

    MW_TEST_B = [[2, 2, 3, 4, 5, 0, 7, 1],
                 [true, true, true, true, true, false, true, false]]

    MW_TEST_C = [[true, true, false, false, true, false, true, false, true, true, false, false, true, false, true, false],
                 [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8]]

    MW_TEST_D = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
                 [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 7, 8, 9, 7, 8, 9, 7, 8, 9, 1]]

    MW_TEST_E = [[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                 [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 7, 8, 9, 7, 8, 9, 7, 8, 9, 1]]
   
    MW_TEST_F = [[1, 2, 3],
                 [4, 5, 6]]

    TEST_KA = [[4, 2, 5, 0.5, 1.5, 2, 0, 1, 0, 1.5, 0],
              [7, 8, 4, 5.5, 4.5, 4, 5, 3, 2, 0.5, 1]]
    TEST_KB = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
              [12, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 1]]
    TEST_KC = [[5, 2, 5],
              [3, 4, 4]]
    TEST_KD = [[1, 2],
              [3, 4]]
    TEST_KE = [[5, 10, 15, 20],
              [4, 20, 16, 12]]
    TEST_KF = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              [2, 3, 4, 5, 6, 7, 6, 9, 10, 11]]
    TEST_KG = [[16, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
              [45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32, 55]]

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
      puts "\nDiagnostics complete."
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
      puts "\n\n"
      puts "Correlation: #{correlation} "
      puts "Relationship: #{relationship}"
      puts "---------------------"
      puts "Set X:      #{@x}"
      puts "Set Y:      #{@y}"
      puts "Pairs:      #{pairs}"
      puts "---------------------"
      puts "Concordant: #{@nc}"
      puts "Discordant: #{@na}"
      puts "Tied X:     #{@nx}"
      puts "Tied Y:     #{@ny}"
      puts "---------------------"
    end
  end

  class MannWhitney


    def self.test
      invert_c = [MW_TEST_C.first.map(&:!), MW_TEST_C.last] 
      u_test = self.new(*MW_TEST_A)
      u_test.diagnostics
      u_test = self.new(*MW_TEST_B)
      u_test.diagnostics
      u_test = self.new(*MW_TEST_C)
      u_test.diagnostics
      u_test = self.new(*invert_c)
      u_test.diagnostics
      u_test = self.new(*MW_TEST_D)
      u_test.diagnostics
      u_test = self.new(*MW_TEST_E)
      u_test.diagnostics
      begin
      u_test = self.new(*MW_TEST_F)
      u_test.diagnostics
      rescue Exception => e
        puts e.message
      end
      puts "Diagnostics complete"
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
      puts "\n--------------------------------"
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
      puts "--------------------------------"
    end
  end
end