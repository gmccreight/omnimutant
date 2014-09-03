module Omnimutant

  class Results

    def initialize()
      reset()
    end

    def reset
      @unexpected_passes = []
    end

    def log_pass(filepath:, line_number:, original_line:, mutated_line:)
      @unexpected_passes << {filepath:filepath,
                             line_number:line_number,
                             original_line:original_line,
                             mutated_line:mutated_line}
    end

    def report
      @unexpected_passes
    end

  end

end
