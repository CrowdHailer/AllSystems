require 'usecase'
require 'minitest/autorun'
require 'minitest/reporters'

reporter_options = {color: true, slow_count: 5}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
