module Usecase
  class Interactor
    def outcome
      catch(:report) do
        run!
      end
    end

    def report(status)
      throw :report, status
    end

    def success?
      outcome == :success
    end

    def failure?
      outcome == :failure
    end

  end
end
