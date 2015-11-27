### Omnimutant

Mutation testing for any project (ultimately)

For now, it can mutate ruby projects.

Requires Ruby 2.1+

### Background

Mutation testing goes a step beyond code coverage tools.  Instead of simply
knowing that a line of code was run by your test suite, it provides
insight into whether the line is tested correctly.

A mutation testing tool alters your source code, introducing logical errors,
then runs your test suite, expecting at least one of your tests to fail because
of the errors it introduced.

If the tests do not fail, then the code is not correctly tested.

### Example

Assuming you have a project called 'mdpg' and you want to test its models,
create a file called 'mutant\_for\_mdpg.rb'.  Note: all 'mutant\_for\_\*' files
are ignored by git.

The contents of the file would be:

```ruby
# Run this file with:
# ruby -Ilib ./mutant_for_mdpg.rb

require "omnimutant"

base_dir = "/Path/to/mdpg/project"
source_dir = base_dir + "/lib/models"

test_passing_regex =
  %r{[1-9][0-9]* (runs|tests), [1-9][0-9]* assertions, 0 failures, 0 errors, 0 skips}

runner = Omnimutant::Runner.new(
  dirs_and_matchers:[[source_dir, %r{\.rb$}]],
  timeout:5,
  test_command:"cd #{base_dir}; rake 2>&1",
  test_passing_regex:test_passing_regex,
  verbose:1
)

runner.run()

puts runner.get_report()
```

The report will tell you all the lines it could alter or remove without the
tests failing.
