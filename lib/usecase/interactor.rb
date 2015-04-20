module Usecase
  class Interactor
    def outcome
      catch(:report) do
        run!
      end
    end

    def output
      []
    end

    def report(status)
      throw :report, status
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
