module AllSystems
  class Interactor
    def run!
      raise AbstractMethodError, "please define #{__method__} for #{name} interactor"
    end

    def outcomes
      # TODO throw error on abstract
      []
    end

    def name
      self.class.name || 'Anonymous'
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
      case method_symbol
      when *outcomes
        return on method_symbol, &block
      when /report_([^?]+)/
        report $1.to_sym, *args
      when /([^?]+)\?/
        super unless outcomes.include? $1.to_sym
        outcome? $1.to_sym
      else
        super
      end
    end
  end
end
