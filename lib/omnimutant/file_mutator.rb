module Omnimutant

  class FileMutator

    def initialize(filepath:, verbose:0)
      @filepath = filepath
      @file_original_data = File.read(@filepath)
      @total_lines = @file_original_data.lines.size

      @current_line_number = 0
      @current_mutation_number = -1
      @verbose = verbose
    end

    def do_next_mutation
      reset_to_original()
      if has_more_mutations_to_try_on_current_line?
        @current_mutation_number += 1
      elsif has_more_lines_to_try?
        @current_line_number += 1
        @current_mutation_number = 0
      else
        return false
      end

      line = @file_original_data.lines[get_current_line_number]
      if line.chomp.size > 0
        run_current_mutation()
        return true
      else
        return do_next_mutation()
      end
    end

    def report
      puts get_current_line_number
      puts @current_mutation_number
      puts
    end

    def is_done_mutating?
      return false if has_more_mutations_to_try_on_current_line?
      return false if has_more_lines_to_try?
      reset_to_original()
      true
    end

    private def run_current_mutation
      replace_line filepath:@filepath,
        line_number:get_current_line_number, new_content:get_mutated_line
    end

    def reset_to_original
      write_file @filepath, @file_original_data
    end

    def get_original_line
      @file_original_data.lines[get_current_line_number]
    end

    def get_current_line_number
      @current_line_number
    end

    def get_mutated_line
      current_line_mutations[@current_mutation_number]
    end

    private def has_more_mutations_to_try_on_current_line?
      mutations = current_line_mutations
      if @current_mutation_number < mutations.size - 1
        return true
      end
      false
    end

    private def current_line_mutations
      line = get_original_line()
      StringMutator.new(line).get_all_mutations()
    end

    private def has_more_lines_to_try?
      get_current_line_number < @total_lines - 1
    end

    private def replace_line(filepath:, line_number:, new_content:)
      new_file_data = ""
      file_data = File.read(filepath)
      file_data.lines.each_with_index do |line, index|
        if index == line_number
          vputs(2, "replace_line - before: " + line)
          vputs(2, "replace_line - after : " + new_content)
          new_file_data << new_content
        else
          new_file_data << line
        end
      end
      write_file filepath, new_file_data
    end

    private def write_file(filepath, data)
      File.open(filepath, 'w') { |file| file.write(data) }
    end

    private def vputs(level, message)
      if @verbose >= level
        puts message
      end
    end

  end

end
