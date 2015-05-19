require_relative '../test_config'

module AllSystems
  class InteractorErrorTest < MiniTest::Test
    NoRunInteractor = Class.new(AllSystems::Interactor)

    def test_raises_error_for_no_run_bang_method
      interactor = NoRunInteractor.new
      err = assert_raises AbstractMethodError do
        interactor.outcome
      end
      assert_includes err.message, 'run!'
    end

    NoOutcomeInteractor = Class.new(AllSystems::Interactor) do
      def run! ; end
    end

    def test_raises_error_if_run_does_not_report_outcome
      interactor = NoOutcomeInteractor.new
      err = assert_raises NoOutcomeError do
        interactor.outcome
      end
      assert_includes err.message, 'NoOutcomeInteractor'
    end

    def test_raises_correct_error_for_unnamed_interactor
      interactor = Class.new(AllSystems::Interactor).new
      err = assert_raises AbstractMethodError do
        interactor.outcome
      end
      assert_includes err.message, 'Anonymous interactor'
    end
  end
end
