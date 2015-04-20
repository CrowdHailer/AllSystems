require_relative '../test_config'

module Usecase
  class InteractorReportingTest < MiniTest::Test
    def interactor_klass
      @interactor_klass ||= Class.new(Usecase::Interactor) do
        def initialize(pass)
          @pass = pass
        end

        def available_outcome
          [:success, :failure]
        end

        def run!
          report :success if @pass
          report :failure
        end
      end
    end

    def test_reports_outcome_as_success_for_pass
      interactor = interactor_klass.new true
      assert_equal :success, interactor.outcome
    end

    def test_reports_outcome_as_failure_for_no_pass
      interactor = interactor_klass.new false
      assert_equal :failure, interactor.outcome
    end

    def test_success_query_is_true_for_pass
      interactor = interactor_klass.new true
      assert_equal true, interactor.success?
    end

    def test_success_query_is_false_for_no_pass
      interactor = interactor_klass.new false
      assert_equal false, interactor.success?
    end

    def test_failure_query_is_true_for_no_pass
      interactor = interactor_klass.new false
      assert_equal true, interactor.failure?
    end

    def test_failure_query_is_false_for_pass
      interactor = interactor_klass.new true
      assert_equal false, interactor.failure?
    end
  end

end
