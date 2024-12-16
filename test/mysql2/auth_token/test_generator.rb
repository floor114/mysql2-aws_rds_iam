# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    module AuthToken
      class TestGenerator < Minitest::Test
        def setup
          with_env(
            'AWS_ACCESS_KEY_ID' => 'AKIAIOSFODNN7EXAMPLE',
            'AWS_SECRET_ACCESS_KEY' => 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
            'AWS_REGION' => 'region'
          ) do
            @aws_rds_client_config = stub(credentials: { at: :at, st: :st }, region: 'region')
            @aws_rds_client = stub(config: @aws_rds_client_config)
            @auth_token_generator = Mysql2::AwsRdsIam::AuthToken::Generator.new
          end
        end

        def with_env(variables)
          env = ENV.to_h
          ENV.update variables
          yield
        ensure
          ENV.clear
          ENV.update env
        end

        def assert_token(token, host:, port:, username:)
          uri = URI.parse("https://#{token}")

          assert_equal host, uri.host
          assert_equal Integer(port, 10), uri.port
          query = URI.decode_www_form(uri.query).to_h

          assert_equal 'connect', query['Action']
          assert_equal username, query['DBUser']
          assert_equal 'AKIAIOSFODNN7EXAMPLE/20010203/region/rds-db/aws4_request', query['X-Amz-Credential']
          refute_empty query['X-Amz-Signature']
        end

        def test_that_it_calls_aws_libraries_and_generates_token
          aws_generator = mock('generator')
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host:port', user_name: 'username')

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          Mysql2::AwsRdsIam::AuthToken::Generator.new.call(host: 'host', port: 'port', username: 'username')
        end

        def test_that_it_calls_aws_libraries_and_generates_reusable_token
          Timecop.freeze '2001-02-03T04:05:06.789Z' do
            tokens = [
              { host: 'localhost', port: '3306', username: 'example_user' },
              { host: 'localhost', port: '3306', username: 'another_user' },
              { host: 'localhost', port: '4321', username: 'example_user' },
              { host: '127.0.0.1', port: '3306', username: 'example_user' }
            ].map do |params|
              [params, @auth_token_generator.call(**params)]
            end

            tokens.each do |params, token|
              assert_token token, **params
              Timecop.freeze 839.9 do
                assert_equal token, @auth_token_generator.call(**params)
              end
              Timecop.freeze 840.1 do
                new_token = @auth_token_generator.call(**params)

                refute_equal token, new_token
                assert_token token, **params
              end
            end
          end
        end

        def test_that_when_username_passed_as_symbol
          aws_generator = mock('generator')
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host:port', user_name: 'username')

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          Mysql2::AwsRdsIam::AuthToken::Generator.new.call(host: 'host', port: 'port', username: :username)
        end
      end
    end
  end
end
