require 'find'
require 'fileutils'

module Omnimutant

  class SourceFilesFinder

    def initialize(dirs_and_matchers:, exclude_dirs_and_matchers:[])
      @dirs_and_matchers = dirs_and_matchers
      @exclude_dirs_and_matchers = exclude_dirs_and_matchers
      @index = nil
    end

    def get_all_files
      all_files = []
      @dirs_and_matchers.each do |dir_and_matcher|
        files = files_for_dir_and_matcher(dir_and_matcher[0],
                                          dir_and_matcher[1])
        all_files << files
      end
      all_files.flatten.sort.uniq
    end

    def remove_excluded(all_files)
      return all_files if @exclude_dirs_and_matchers.size == 0
      result = []
      all_files.each do |file|
        matched_any = false
        @exclude_dirs_and_matchers.each do |dir_and_matcher|
          dir = dir_and_matcher[0]
          file_regex = dir_and_matcher[1]
          if file[0..(dir.size - 1)] == dir
            if file[dir.size..-1].match(file_regex)
              matched_any = true
            end
          end
        end
        if ! matched_any
          result << file
        end
      end
      result
    end

    def get_files
      @files_list = []
      all_files = get_all_files()
      files_minus_excluded = remove_excluded(all_files)
      @files_list = files_minus_excluded
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
