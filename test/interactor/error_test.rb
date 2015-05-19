require_relative '../test_config'

module AllSystems
  class InteractorErrorTest < MiniTest::Test
    NoGoInteractor = Class.new(AllSystems::Interactor)

    def test_raises_error_for_no_go_bang_method
      interactor = NoGoInteractor.new
      err = assert_raises AbstractMethodError do
        interactor.outcome
      end
      assert_includes err.message, 'go!'
    end

    NoOutcomeInteractor = Class.new(AllSystems::Interactor) do
      def go! ; end
    end

    def test_raises_error_if_go_does_not_report_outcome
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
