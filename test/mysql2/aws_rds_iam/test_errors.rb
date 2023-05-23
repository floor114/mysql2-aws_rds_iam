# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    module Errors
      class TestError < Minitest::Test
        def setup
          @error = Mysql2::AwsRdsIam::Errors::Error.new
        end

        def test_that_it_has_correct_inheritance
          assert_equal StandardError, @error.class.superclass
        end

        def test_that_it_has_correct_error_message
          assert_equal 'Mysql2::AwsRdsIam::Errors::Error', @error.message
        end
      end

      class TestMysql2ClientNotFoundError < Minitest::Test
        def setup
          @error = Mysql2::AwsRdsIam::Errors::Mysql2ClientNotFoundError.new
        end

        def test_that_it_has_correct_inheritance
          assert_equal Mysql2::AwsRdsIam::Errors::Error, @error.class.superclass
        end

        def test_that_it_has_correct_error_message
          assert_equal 'Could not find class or method when patching Mysql2::Client. Please investigate.',
                       @error.message
        end
      end

      class TestReconnectConfigEnabledError < Minitest::Test
        def setup
          @error = Mysql2::AwsRdsIam::Errors::ReconnectConfigEnabledError.new
        end

        def test_that_it_has_correct_inheritance
          assert_equal Mysql2::AwsRdsIam::Errors::Error, @error.class.superclass
        end

        def test_that_it_has_correct_error_message
          assert_equal 'reconnect config must be false if using AWS RDS IAM authentication.',
                       @error.message
        end
      end

      class TestUsernameNotFoundError < Minitest::Test
        def setup
          @error = Mysql2::AwsRdsIam::Errors::UsernameNotFoundError.new
        end

        def test_that_it_has_correct_inheritance
          assert_equal Mysql2::AwsRdsIam::Errors::Error, @error.class.superclass
        end

        def test_that_it_has_correct_error_message
          assert_equal 'username must be present.',
                       @error.message
        end
      end

      class TestHostNotFoundError < Minitest::Test
        def setup
          @error = Mysql2::AwsRdsIam::Errors::HostNotFoundError.new
        end

        def test_that_it_has_correct_inheritance
          assert_equal Mysql2::AwsRdsIam::Errors::Error, @error.class.superclass
        end

        def test_that_it_has_correct_error_message
          assert_equal 'host must be present.',
                       @error.message
        end
      end
    end
  end
end
