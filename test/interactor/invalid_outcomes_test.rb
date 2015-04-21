require_relative '../test_config'

module Usecase
  class InteractorInvalidOutcomeTest < MiniTest::Test
    def interactor_klass
      @interactor_klass ||= Class.new(Usecase::Interactor) do
        def initialize(pass)
          @pass = pass
        end

        def outcomes
          [:success]
        end

        def run!
          report :success if @pass
          report :random
        end
      end
    end

    def test_cant_report_unknown_outcome
      interactor = interactor_klass.new false
      assert_raises Usecase::UnknownOutcomeReportError do
        interactor.outcome
      end
    end

    def test_cant_check_unknown_outcome
      interactor = interactor_klass.new true
      assert_raises Usecase::UnknownOutcomeError do
        interactor.outcome? :random
      end
    end

    def test_cant_define_callback_for_unknown_outcome
      interactor = interactor_klass.new true
      assert_raises Usecase::UnknownOutcomeError do
        interactor.on :random do
          flunk
        end
      end
    end

    def test_no_method_error_for_invalid_outcomes
      interactor = interactor_klass.new true
      assert_raises NoMethodError do
        interactor.random do
          flunk
        end
      end
    end
  end
end
