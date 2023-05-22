# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'mysql2/aws_rds_iam'

require 'minitest/reporters'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

require 'timecop'
Timecop.safe_mode = true

require 'minitest/autorun'
