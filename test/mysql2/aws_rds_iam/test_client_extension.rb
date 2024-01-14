# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    class TestClientExtension < Minitest::Test
      def setup
        @client_class = Class.new do
          prepend Mysql2::AwsRdsIam::ClientExtension

          def initialize(opts = {})
            connect(opts)
          end

          def connect(_opts); end
        end
      end

      def test_when_config_aws_rds_iam_auth_is_not_set
        @client_class.any_instance.expects(:connect).with(
          {
            host: 'host',
            port: 'port',
            username: 'username',
            password: 'password',
            database: 'database'
          }
        )
        AuthToken::Factory.expects(:call).never

        @client_class.new(host: 'host', port: 'port', username: 'username', password: 'password', database: 'database')
      end

      def test_when_config_aws_rds_iam_auth_is_set_to_true
        AuthToken::Factory.expects(:call).once.with(nil, 'host', 'port', 'username').returns('generator_password')
        @client_class.any_instance.expects(:connect).with(
          {
            host: 'host',
            port: 'port',
            username: 'username',
            database: 'database',
            password: 'generator_password',
            enable_cleartext_plugin: true
          }
        )

        @client_class.new(host: 'host', port: 'port', username: 'username', database: 'database',
                          aws_rds_iam_auth: true)
      end

      def test_when_config_aws_rds_iam_auth_and_reconnect_are_set_to_true
        AuthToken::Factory.expects(:call).never
        @client_class.any_instance.expects(:connect).never

        assert_raises(
          Mysql2::AwsRdsIam::Errors::ReconnectConfigEnabledError,
          'reconnect config must be false if using AWS RDS IAM authentication.'
        ) do
          @client_class.new(
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
        AuthToken::Factory.expects(:call).never
        @client_class.any_instance.expects(:connect).never

        assert_raises(Mysql2::AwsRdsIam::Errors::UsernameNotFoundError, 'username must be present.') do
          @client_class.new(host: 'host', port: 'port', database: 'database', aws_rds_iam_auth: true)
        end
      end

      def test_when_host_is_not_set
        AuthToken::Factory.expects(:call).never
        @client_class.any_instance.expects(:connect).never

        assert_raises(Mysql2::AwsRdsIam::Errors::HostNotFoundError, 'host must be present.') do
          @client_class.new(port: 'port', username: 'username', database: 'database', aws_rds_iam_auth: true)
        end
      end

      def test_that_it_removes_provided_password_and_connects_with_the_generated_one
        AuthToken::Factory.expects(:call).once.with(nil, 'host', 'port', 'username').returns('generator_password')
        @client_class.any_instance.expects(:connect).with(
          {
            host: 'host',
            port: 'port',
            username: 'username',
            database: 'database',
            password: 'generator_password',
            enable_cleartext_plugin: true
          }
        )

        @client_class.new(
          host: 'host',
          port: 'port',
          username: 'username',
          password: 'password',
          database: 'database',
          aws_rds_iam_auth: true
        )
      end

      def test_that_it_removes_provided_password_and_connects_with_the_generated_one_using_custom_token_generator
        AuthToken::Factory.expects(:call).once.with(:custom, 'host', 'port', 'username').returns('generator_password')
        @client_class.any_instance.expects(:connect).with(
          {
            host: 'host',
            port: 'port',
            username: 'username',
            database: 'database',
            password: 'generator_password',
            enable_cleartext_plugin: true
          }
        )

        @client_class.new(
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
end
