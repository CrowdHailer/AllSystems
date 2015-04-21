module Usecase
  class Interactor
    def run!
      raise AbstractMethodError, "please define #{__method__} for #{name}"
    end

    def name
      self.class.name || 'Anonymous Interactor'
    end

    def outcome
      result.first
    end

    def outcome?(predicate)
      raise UnknownOutcomeError unless outcomes.include? predicate
      predicate == outcome
    end

    def output
      result.drop 1
    end

    def on(conditional_outcome)
      yield *output if outcome? conditional_outcome
    end

    private

    def run
      catch(:report) do
        run!
        raise NoOutcomeError, "#{name} concluded without reporting an outcome"
      end
    end

    def result
      @result ||= run
    end

    def report(*result)
      raise UnknownOutcomeReportError unless outcomes.include? result.first
      throw :report, result
    end

    def method_missing(method_symbol, *args, &block)
      # super
      if capture = method_symbol[/([^?]+)\?/, 1]
        outcome? capture.to_sym
      else
        on method_symbol, &block
      end
    end
  end
end
