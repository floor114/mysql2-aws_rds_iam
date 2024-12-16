# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    module AuthToken
      class TestExpirableToken < Minitest::Test
        def setup
          @valid_token = 'https://example.com?x-amz-expires=900'
          @no_expiration_token = 'https://example.com?other=test'
          @malformed_token = 'https://example.com?x-amz-expires=test'
          @no_query_token = 'https://example.com'
        end

        def test_that_token_is_valid_when_not_expired
          token = ExpirableToken.new(@valid_token)

          Process.stub(:clock_gettime, token.send(:created_at) + 60) do
            assert_equal @valid_token, token.value
          end
        end

        def test_that_tokenis_valid_when_expiry_is_missing
          token = ExpirableToken.new(@no_expiration_token)

          Process.stub(:clock_gettime, token.send(:created_at) + 840) do
            assert_equal @no_expiration_token, token.value
          end
        end

        def test_that_tokenis_valid_when_expiry_is_invalid
          token = ExpirableToken.new(@malformed_token)

          Process.stub(:clock_gettime, token.send(:created_at) + 840) do
            assert_equal @malformed_token, token.value
          end
        end

        def test_that_tokenis_valid_when_no_query
          token = ExpirableToken.new(@no_query_token)

          Process.stub(:clock_gettime, token.send(:created_at) + 840) do
            assert_equal @no_query_token, token.value
          end
        end

        def test_that_token_is_invalid_when_expired
          token = ExpirableToken.new(@valid_token)

          Process.stub(:clock_gettime, token.send(:created_at) + 900) do
            assert_nil token.value
          end
        end
      end
    end
  end
end
