require_relative '../test_config'

module Usecase
  class InteractorOutcomeTest < MiniTest::Test
    def interactor_klass
      @interactor_klass ||= Class.new(Usecase::Interactor) do
        def initialize(pass)
          @pass = pass
        end

        def outcomes
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

    def test_confirms_outcome_success_for_pass
      interactor = interactor_klass.new true
      assert_equal true, interactor.outcome?(:success)
    end

    def test_denys_outcome_success_for_no_pass
      interactor = interactor_klass.new false
      assert_equal false, interactor.outcome?(:success)
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

    def test_calls_on_success_action_for_pass
      interactor = interactor_klass.new true
      mock = MiniTest::Mock.new
      mock.expect :report, true
      interactor.on :success do
        mock.report
      end
      mock.verify
    end

    # TODO decide
    # def test_calls_on_either_action_for_pass
    #   interactor = interactor_klass.new true
    #   mock = MiniTest::Mock.new
    #   mock.expect :report, true
    #   interactor.on :success, :failue do
    #     mock.report
    #   end
    #   mock.verify
    # end
    #
    # def test_calls_on_either_action_for_no_pass
    #   interactor = interactor_klass.new false
    #   mock = MiniTest::Mock.new
    #   mock.expect :report, true
    #   interactor.on :success, :failure do
    #     mock.report
    #   end
    #   mock.verify
    # end

    def test_doesnt_call_on_success_action_for_no_pass
      interactor = interactor_klass.new false
      interactor.on :success do
        flunk 'Should not process'
      end
    end

    def test_calls_success_action_for_pass
      interactor = interactor_klass.new true
      mock = MiniTest::Mock.new
      mock.expect :report, true
      interactor.success do
        mock.report
      end
      mock.verify
    end

    def test_doesnt_call_success_for_no_pass
      interactor = interactor_klass.new false
      interactor.success do
        flunk 'Should not be a success'
      end
    end

    def test_calls_failure_action_for_no_pass
      interactor = interactor_klass.new false
      mock = MiniTest::Mock.new
      mock.expect :report, true
      interactor.failure do
        mock.report
      end
      mock.verify
    end

    def test_doesnt_call_failure_for_pass
      interactor = interactor_klass.new true
      interactor.failure do
        flunk 'Should not be a failure'
      end
    end
  end

end
