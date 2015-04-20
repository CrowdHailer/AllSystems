require_relative '../test_config'

module Usecase
  class InteractorTest < MiniTest::Test
    def interactor_klass
      @interactor_klass ||= Class.new(Usecase::Interactor) do
        def available_outcome
          [:success, :failure]
        end

        def run!
          report :success
        end
      end
    end

    def interactor
      @interactor ||= interactor_klass.new
    end

    def teardown
      @interactor = nil
    end

    def test_reports_outcome_as_success
      assert_equal :success, interactor.outcome
    end
  end

end
