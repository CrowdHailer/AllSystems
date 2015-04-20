module Usecase
  class Interactor
    def outcome
      result.first
    end

    def output
      result[1..-1]
    end

    def result
      catch(:report) do
        run!
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
