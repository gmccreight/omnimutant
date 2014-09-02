module Omnimutant

  class FileIterator

    def initialize(files:)
      @files = files
      @index = 0
    end

    def get_current_file
      if @files.size > 0
        @files[@index]
      end
    end

    def move_next
      if ! is_at_end?
        @index += 1
      end
    end

    def is_at_end?
      @index == @files.size - 1
    end

  end

end
