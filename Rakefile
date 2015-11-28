require 'rake/testtask'

require 'tempfile'
require 'fileutils'

task :default => [:test]

Rake::TestTask.new do |t|
  t.pattern = "spec/{[!examples/]**/*,*}_spec.rb"
end

desc "copy this project to a temporary directory and mutation scripts on it"
task :mutate do
  source_dir = File.expand_path(File.dirname(__FILE__))
  dest_dir = Dir.mktmpdir

  FileUtils.cp_r(source_dir, dest_dir)

  mutate_script = <<-END.gsub(/^ {4}/, '')
    require "omnimutant"
    
    base_dir = "#{dest_dir}"
    source_dir = base_dir + "/lib"
    
    test_passing_regex =
      %r{[1-9][0-9]* (runs|tests), [1-9][0-9]* assertions, 0 failures, 0 errors, 0 skips}
    
    runner = Omnimutant::Runner.new(
      dirs_and_matchers: [[source_dir, %r{\.rb$}]],
      timeout: 10,
      test_command: "cd \#{base_dir}; rake 2>&1",
      test_passing_regex: test_passing_regex,
      verbose: 0
    )
    runner.run()
    puts runner.get_report()
  END

  File.write(dest_dir + "/mutate_script", mutate_script)
  exec 'ruby -Ilib #{dest_dir}/mutate_script'
end
