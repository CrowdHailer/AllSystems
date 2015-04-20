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

    def report(status, *output)
      result = [status, *output]
      throw :report, result
    end

    # TODO custom define methods
    def success?
      outcome == :success
    end

    def failure?
      outcome == :failure
    end

  end
end
