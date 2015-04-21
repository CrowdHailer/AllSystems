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
      predicate == outcome
    end

    def output
      result.drop 1
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
      throw :report, result
    end

    def method_missing(method_symbol, *args, &block)
      if capture = method_symbol[/([^?]+)\?/, 1]
        capture.to_sym == outcome
      else
        yield *output if method_symbol == outcome
      end
    end
  end
end
