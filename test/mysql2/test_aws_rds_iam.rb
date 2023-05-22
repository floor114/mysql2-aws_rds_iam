# frozen_string_literal: true

require 'test_helper'

module Mysql2
  class TestAwsRdsIam < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Mysql2::AwsRdsIam::VERSION
    end

    def test_it_does_something_useful
      assert 'false' # rubocop:disable Minitest/UselessAssertion
    end
  end
end
