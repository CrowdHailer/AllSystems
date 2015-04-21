require_relative '../test_config'

module Usecase
  class InteractorOutputTest < MiniTest::Test
    def interactor_klass
      @interactor_klass ||= Class.new(Usecase::Interactor) do
        def initialize(value)
          @value = value
        end

        def available_outcome
          [:none, :one, :two, :unique]
        end

        def run!
          case @value
          when 0
            report :none
          when 1
            report :one, 1
          when 2
            report :two, 1, 2
          when :unique
            report :unique, Class.new
          end
        end
      end
    end

    def test_empty_out_put_array_when_none_given
      interactor = interactor_klass.new 0
      assert_equal [], interactor.output
    end

    def test_callback_recives_no_output
      interactor = interactor_klass.new 0
      mock = MiniTest::Mock.new
      mock.expect :report, true, []
      interactor.none do |*args|
        mock.report *args
      end
      mock.verify
    end

    def test_single_item_output
      interactor = interactor_klass.new 1
      assert_equal [1], interactor.output
    end

    def test_callback_recives_single_output
      interactor = interactor_klass.new 1
      mock = MiniTest::Mock.new
      mock.expect :report, true, [1]
      interactor.one do |*args|
        mock.report *args
      end
      mock.verify
    end

    def test_two_item_output
      interactor = interactor_klass.new 2
      assert_equal [1, 2], interactor.output
    end

    def test_callback_recives_double_output
      interactor = interactor_klass.new 2
      mock = MiniTest::Mock.new
      mock.expect :report, true, [1, 2]
      interactor.two do |*args|
        mock.report *args
      end
      mock.verify
    end

    def test_run_is_only_executed_once
      interactor = interactor_klass.new :unique
      assert_equal interactor.output.first, interactor.output.first
    end
  end
end
