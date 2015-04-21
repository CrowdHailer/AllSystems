require_relative '../test_config'

module Usecase
  class InteractorReportHelperTest < MiniTest::Test
    def interactor_klass
      @interactor_klass ||= Class.new(Usecase::Interactor) do
        def initialize(pass)
          @pass = pass
        end

        def outcomes
          [:success, :failure]
        end

        def run!
          report_success :item if @pass
          report_failure
        end
      end
    end

    def test_reports_outcome_as_success_for_pass
      interactor = interactor_klass.new true
      assert_equal :success, interactor.outcome
    end

    def test_reports_outoutput_for_pass
      interactor = interactor_klass.new true
      assert_equal [:item], interactor.output
    end

    def test_reports_outcome_as_failure_for_no_pass
      interactor = interactor_klass.new false
      assert_equal :failure, interactor.outcome
    end
  end
end
