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
          aws_generator.expects(:auth_token).with(region: 'region', endpoint: 'host:port', user_name: 'username')

          Aws::RDS::Client.expects(:new).once.returns(@aws_rds_client)
          Aws::RDS::AuthTokenGenerator.expects(:new).with(credentials: { at: :at, st: :st }).once.returns(aws_generator)

          Mysql2::AwsRdsIam::AuthToken::Generator.new.call(host: 'host', port: 'port', username: 'username')
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
