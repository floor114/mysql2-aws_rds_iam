# frozen_string_literal: true

require 'pry'
require 'timecop'

Timecop.mock_process_clock = true
Timecop.safe_mode = true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
SimpleCov.start do
  load_profile 'test_frameworks'

  enable_coverage :branch

  add_filter 'lib/mysql2-aws_rds_iam.rb'
  add_filter 'lib/mysql2/aws_rds_iam/version.rb'

  track_files '**/*.rb'

  minimum_coverage line: 100, branch: 100
end

require 'mysql2-aws_rds_iam'

require 'minitest/reporters'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

require 'minitest/autorun'
require 'mocha/minitest'
