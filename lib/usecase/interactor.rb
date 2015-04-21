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

    def output
      result.drop 1
    end

    def result
      catch(:report) do
        run!
        raise NoOutcomeError, "#{name} concluded without reporting an outcome"
      end
    end

    def report(*result)
      throw :report, result
    end

    # TODO custom define methods
    def success
      yield if success?
    end

    def failure
      yield if failure?
    end

    def none
      yield if outcome == :none
    end

    def one
      yield *output if outcome == :one
    end

    def two
      yield *output if outcome == :two
    end

    def success?
      outcome == :success
    end

    def failure?
      outcome == :failure
    end

  end
end
