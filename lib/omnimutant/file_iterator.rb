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
      if ! is_beyond_end?
        @index += 1
      end
    end

    def is_at_end?
      @index == @files.size - 1
    end

    def is_beyond_end?
      @index >= @files.size
    end

  end

end
