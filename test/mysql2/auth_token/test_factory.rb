# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    module AuthToken
      class TestFactory < Minitest::Test
        def setup
          @default_generator = ->(host:, port:, username:) { "default(#{username}@#{host}:#{port})" }
          @custom_generator = ->(host:, port:, username:) { "custom(#{username}@#{host}:#{port})" }

          Mysql2::AwsRdsIam.expects(:auth_token_registry).once.returns(
            {
              default: @default_generator,
              custom: @custom_generator
            }
          )
        end

        def test_that_default_generator_is_called_when_nothing_passed
          @default_generator.expects(:call).with(
            host: 'host',
            port: 'port',
            username: 'username'
          )

          Mysql2::AwsRdsIam::AuthToken::Factory.call(nil, 'host', 'port', 'username')
        end

        def test_that_default_generator_is_called_when_string_is_passed
          @default_generator.expects(:call).with(
            host: 'host',
            port: 'port',
            username: 'username'
          )

          Mysql2::AwsRdsIam::AuthToken::Factory.call('default', 'host', 'port', 'username')
        end

        def test_that_custom_generator_is_called_when_it_is_passed
          @custom_generator.expects(:call).with(
            host: 'host',
            port: 'port',
            username: 'username'
          )

          Mysql2::AwsRdsIam::AuthToken::Factory.call(:custom, 'host', 'port', 'username')
        end

        def test_that_custom_generator_is_called_when_it_is_passed_as_string
          @custom_generator.expects(:call).with(
            host: 'host',
            port: 'port',
            username: 'username'
          )

          Mysql2::AwsRdsIam::AuthToken::Factory.call('custom', 'host', 'port', 'username')
        end
      end
    end
  end
end
