module Omnimutant

  class Results

    def initialize()
      @unexpected_passes = []
    end

    def log_pass(filepath:, line_number:, original_line:, mutated_line:)
      @unexpected_passes << {filepath:filepath,
                             line_number:line_number,
                             original_line:original_line,
                             mutated_line:mutated_line}
    end

    def report
      @unexpected_passes.each do |pass|
        puts "filepath: #{pass[:filepath]}"
        puts "line_number: #{pass[:line_number]}"
        puts "original_line: #{pass[:original_line]}"
        puts "mutated_line: #{pass[:mutated_line]}"
        puts ""
        puts ""
      end
    end

  end

end
