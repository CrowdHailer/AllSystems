require_relative '../test_config'

module Usecase
  class InteractorOutputTest < MiniTest::Test
    def interactor_klass
      @interactor_klass ||= Class.new(Usecase::Interactor) do
        def initialize(value)
          @value = value
        end

        def available_outcome
          [:none, :one, :two]
        end

        def run!
          case @value
          when 0
            report :none
          when 1
            report :one, 1
          when 2
            report :two, 1, 2
          end
        end
      end
    end

    def test_empty_out_put_array_when_none_given
      interactor = interactor_klass.new 0
      assert_equal [], interactor.output
    end
  end
end
