module Omnimutant

  class FileMutator

    def initialize(filepath)
      @filepath = filepath
      @file_original_data = File.read(@filepath)
      @total_lines = @file_original_data.lines.size

      @current_line_number = 0
      @current_mutation_number = -1
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

      run_mutation()
    end

    def report
      puts @current_line_number
      puts @current_mutation_number
      puts
    end

    def is_done_mutating?
      return false if has_more_mutations_to_try_on_current_line?
      return false if has_more_lines_to_try?
      true
    end

    def run_mutation
      line = @file_original_data.lines[@current_line_number]
      if line.chomp.size > 0
        mutated_line = current_line_mutations[@current_mutation_number]
        replace_line filepath:@filepath,
          line_number:@current_line_number, new_content:mutated_line
      end
    end

    def reset_to_original
      write_file @filepath, @file_original_data
    end

    private def current_line_content
      @file_original_data.lines[@current_line_number]
    end

    private def has_more_mutations_to_try_on_current_line?
      mutations = current_line_mutations
      if @current_mutation_number < mutations.size - 1
        return true
      end
      false
    end

    private def current_line_mutations
      line = current_line_content()
      StringMutator.new(line).get_all_mutations()
    end

    private def has_more_lines_to_try?
      @current_line_number < @total_lines - 1
    end

    private def replace_line(filepath:, line_number:, new_content:)
      new_file_data = ""
      file_data = File.read(filepath)
      file_data.lines.each_with_index do |line, index|
        if index == line_number
          new_file_data << new_content
        else
          new_file_data << line
        end
      end
      write_file filepath, file_data
    end

    private def say message
      puts message
    end

    private def write_file(filepath, data)
      File.open(filepath, 'w') { |file| file.write(data) }
    end

  end

end
