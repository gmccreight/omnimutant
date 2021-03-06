module Omnimutant

  class StringMutator

    def initialize line
      @line = line
    end

    def get_all_mutations
      MutationStrategyBase.mutation_classes.map{|klass|
        klass.new(@line).get_mutations()
      }.flatten
    end

  end

  class MutationStrategyBase

    class << self
      attr_reader :mutation_classes
    end

    def initialize line
      @line = line
    end

    @mutation_classes = []

    def self.inherited(subclass)
      MutationStrategyBase.mutation_classes << subclass
    end

    def get_mutations
      results = []
      occurrence = 0
      while result = search_replace_occurrence_in_data(data: @line,
      search: _search(), replace: _replace(), occurrence: occurrence) do
        modified_string = result[0]
        occurrence_existed = result[1]
        break if !occurrence_existed
        results << modified_string
        occurrence += 1
      end
      results
    end

    def search_replace_occurrence_in_data data:, search:, replace:, occurrence:

      occurrence_existed = false
      index = -1

      data = data.gsub(search) { |match|
        index += 1
        if index == occurrence
          occurrence_existed = true
          replace
        else
          match
        end
      }
      [data, occurrence_existed]

    end

  end

  class MutationStrategyDeleteLine < MutationStrategyBase

    def _search
      %r{.+}
    end

    def _replace
      ""
    end

  end

  class MutationStrategySwithAndForOr < MutationStrategyBase

    def _search
      %r{&&}
    end

    def _replace
      "||"
    end

  end

  class MutationStrategySwitchOrForAnd < MutationStrategyBase

    # || but not ||=
    def _search
      %r{\|\|(?!=)}
    end

    def _replace
      "&&"
    end

  end

  class MutationStrategySwitchEqualsToNotEquals < MutationStrategyBase

    def _search
      %r{==}
    end

    def _replace
      "!="
    end

  end

  class MutationStrategySwitchNotEqualsToEquals < MutationStrategyBase

    def _search
      %r{!=}
    end

    def _replace
      "=="
    end

  end

  class MutationStrategyChangeMethodName < MutationStrategyBase

    def _search
      %r{(?<=def )\w+}
    end

    def _replace
      "mutated_method_name_that_should_not_exist"
    end

  end

  class MutationStrategyChangeSymbolName < MutationStrategyBase

    def _search
      %r{:[a-z_][a-z0-9_]*}
    end

    def _replace
      ":mutated_symbol_name_that_should_not_exist"
    end

  end

end
