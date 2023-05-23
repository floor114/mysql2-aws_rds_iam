# frozen_string_literal: true

require 'test_helper'

module Mysql2
  class TestMysql2Client < Minitest::Test
    def setup
      Mysql2::AwsRdsIam::AuthToken::Generator.expects(:new).once.returns(
        ->(host:, port:, username:) { "default(#{username}@#{host}:#{port})" }
      )
      Mysql2::AwsRdsIam.auth_token_registry.add(
        :custom,
        ->(host:, port:, username:) { "custom(#{username}@#{host}:#{port})" }
      )
    end

    def teardown
      Mysql2::AwsRdsIam.instance_variable_set(:@auth_token_registry, nil)
    end

    def test_when_config_aws_rds_iam_auth_is_not_set
      Mysql2::Client.any_instance.expects(:connect).with(
        'username', 'password', 'host', 0, 'database', nil, anything, anything
      )

      Mysql2::Client.new(host: 'host', port: 'port', username: 'username', password: 'password', database: 'database')
    end

    def test_when_config_aws_rds_iam_auth_is_set_to_true
      Mysql2::Client.any_instance.expects(:connect).with(
        'username', 'default(username@host:port)', 'host', 0, 'database', nil, anything, anything
      )

      Mysql2::Client.new(host: 'host', port: 'port', username: 'username', database: 'database', aws_rds_iam_auth: true)
    end

    def test_when_config_aws_rds_iam_auth_and_reconnect_are_set_to_true
      Mysql2::Client.any_instance.expects(:connect).never

      assert_raises(
        Mysql2::AwsRdsIam::Errors::ReconnectConfigEnabledError,
        'reconnect config must be false if using AWS RDS IAM authentication.'
      ) do
        Mysql2::Client.new(
          host: 'host',
          port: 'port',
          username: 'username',
          database: 'database',
          aws_rds_iam_auth: true,
          reconnect: true
        )
      end
    end

    def test_when_username_is_not_set
      Mysql2::Client.any_instance.expects(:connect).never

      assert_raises(Mysql2::AwsRdsIam::Errors::UsernameNotFoundError, 'username must be present.') do
        Mysql2::Client.new(host: 'host', port: 'port', database: 'database', aws_rds_iam_auth: true)
      end
    end

    def test_when_host_is_not_set
      Mysql2::Client.any_instance.expects(:connect).never

      assert_raises(Mysql2::AwsRdsIam::Errors::HostNotFoundError, 'host must be present.') do
        Mysql2::Client.new(port: 'port', username: 'username', database: 'database', aws_rds_iam_auth: true)
      end
    end

    def test_that_it_removes_provided_password_and_connects_with_the_generated_one
      Mysql2::Client.any_instance.expects(:connect).with(
        'username', 'default(username@host:port)', 'host', 0, 'database', nil, anything, anything
      )

      Mysql2::Client.new(
        host: 'host',
        port: 'port',
        username: 'username',
        password: 'password',
        database: 'database',
        aws_rds_iam_auth: true
      )
    end

    def test_that_it_removes_provided_password_and_connects_with_the_generated_one_using_custom_token_generator
      Mysql2::Client.any_instance.expects(:connect).with(
        'username', 'custom(username@host:port)', 'host', 0, 'database', nil, anything, anything
      )

      Mysql2::Client.new(
        host: 'host',
        port: 'port',
        username: 'username',
        password: 'password',
        database: 'database',
        aws_rds_iam_auth: true,
        aws_rds_iam_auth_token_generator: :custom
      )
    end
  end
end
