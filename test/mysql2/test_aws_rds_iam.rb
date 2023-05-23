# frozen_string_literal: true

require 'test_helper'

module Mysql2
  class TestAwsRdsIam < Minitest::Test
    def teardown
      Mysql2::AwsRdsIam.instance_variable_set(:@auth_token_registry, nil)
    end

    def test_that_it_has_an_auth_token_registry
      Mysql2::AwsRdsIam::AuthToken::Registry.expects(:new).returns('test')

      assert_equal 'test', Mysql2::AwsRdsIam.auth_token_registry
    end

    def test_that_it_raises_error_when_there_is_no_mysql2
      Object.stub :const_get, -> { raise ArgumentError } do
        assert_raises(
          Mysql2::AwsRdsIam::Errors::Mysql2ClientNotFoundError,
          'Could not find class or method when patching Mysql2::Client. Please investigate.'
        ) do
          Mysql2::AwsRdsIam.apply_patch
        end
      end
    end

    def test_that_it_raises_error_when_there_is_no_method
      Mysql2::Client.stub :instance_method, -> { raise ArgumentError } do
        assert_raises(
          Mysql2::AwsRdsIam::Errors::Mysql2ClientNotFoundError,
          'Could not find class or method when patching Mysql2::Client. Please investigate.'
        ) do
          Mysql2::AwsRdsIam.apply_patch
        end
      end
    end

    def test_that_mysql2_client_receives_prepend
      Mysql2::Client.expects(:prepend).with(Mysql2::AwsRdsIam::ClientExtension)

      Mysql2::AwsRdsIam.apply_patch
    end
  end
end
