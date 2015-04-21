require_relative '../test_config'

module Usecase
  class InteractorErrorTest < MiniTest::Test
    NoRunInteractor = Class.new(Usecase::Interactor)

    def test_raises_error_for_no_run_bang_method
      interactor = NoRunInteractor.new
      err = assert_raises AbstractMethodError do
        interactor.outcome
      end
      assert_includes err.message, 'run!'
    end

    NoOutcomeInteractor = Class.new(Usecase::Interactor) do
      def run! ; end
    end

    def test_raises_error_if_run_does_not_report_outcome
      interactor = NoOutcomeInteractor.new
      err = assert_raises NoOutcomeError do
        interactor.outcome
      end
      assert_includes err.message, 'NoOutcomeInteractor'
    end
  end
end
