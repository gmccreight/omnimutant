require 'find'
require 'fileutils'

module Omnimutant

  class SourceFilesFinder

    def initialize(dirs:, matchers:)
      @dirs = dirs
      @matchers = matchers
      @files_list = []
      @index = nil
    end

    def load
      all_files = []
      @dirs.each_with_index do |dir, i|
        files = files_for_dir_and_matcher(dir, @matchers[i])
        all_files << files
      end
      @files_list = all_files.flatten.sort.uniq
    end

    def get_files
      load()
      @files_list
    end

    def get_current_file
      if @files_list.size > 0
        @files_list[@index]
      end
    end

    def move_next

    end

    def files_for_dir_and_matcher(dir, matcher)
      results = []
      Find.find(dir) do |path|
        if FileTest.directory?(path)
          if File.basename(path)[0] == ?. and File.basename(path) != '.'
            Find.prune
          else
            next
          end
        else
          if File.basename(path) != ".DS_Store"
            if path.match(matcher)
              results << path
            end
          end
        end
      end
      results
    end

  end

end
