# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    module AuthToken
      class TestGenerator < Minitest::Test
        def setup
          @aws_rds_client_config = stub(credentials: { at: :at, st: :st }, region: 'region')
          @aws_rds_client = stub(config: @aws_rds_client_config)
        end

        def test_that_it_calls_aws_libraries_and_generates_token
          aws_generator = mock('generator')
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host:port',
                                                  user_name: 'username').returns('aws_generated_token')

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          token = Mysql2::AwsRdsIam::AuthToken::Generator.new.call(host: 'host', port: 'port', username: 'username')

          assert_equal 'aws_generated_token', token
        end

        def test_that_when_username_passed_as_symbol
          aws_generator = mock('generator')
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host:port', user_name: 'username')

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          Mysql2::AwsRdsIam::AuthToken::Generator.new.call(host: 'host', port: 'port', username: :username)
        end

        def test_that_it_uses_cached_token
          aws_generator = mock('generator')
          aws_generator.expects(:auth_token).never

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          generator = Mysql2::AwsRdsIam::AuthToken::Generator.new
          cached_token = mock('ExpirableToken', value: 'cached-token')
          generator.instance_variable_get(:@cache)['host:port:username'] = cached_token

          token = generator.call(host: 'host', port: 'port', username: 'username')

          assert_equal 'cached-token', token
        end

        def test_that_it_refreshes_token_when_cache_is_invalid
          aws_generator = mock('generator')
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host:port',
                                                  user_name: 'username').returns('aws_generated_token')

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          generator = Mysql2::AwsRdsIam::AuthToken::Generator.new
          expired_token = mock('ExpirableToken')
          expired_token.expects(:value).twice.returns(nil)
          generator.instance_variable_get(:@cache)['host:port:username'] = expired_token

          token = generator.call(host: 'host', port: 'port', username: 'username')

          assert_equal 'aws_generated_token', token
        end

        def test_thread_safety_with_cache_access
          token1 = mock('ExpirableToken', value: 'token1')
          token2 = mock('ExpirableToken', value: 'token2')
          aws_generator = mock('generator')
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host1:port1',
                                                  user_name: 'username1').returns('aws_generated_token1')
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host2:port2',
                                                  user_name: 'username2').returns('aws_generated_token2')

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          generator = Mysql2::AwsRdsIam::AuthToken::Generator.new
          ExpirableToken.stubs(:new).returns(token1, token2)

          threads = []
          threads << Thread.new { generator.call(host: 'host1', port: 'port1', username: 'username1') }
          threads << Thread.new { generator.call(host: 'host2', port: 'port2', username: 'username2') }

          threads.each(&:join)

          assert_equal 'token1', generator.instance_variable_get(:@cache)['host1:port1:username1'].value
          assert_equal 'token2', generator.instance_variable_get(:@cache)['host2:port2:username2'].value
        end
      end
    end
  end
end
