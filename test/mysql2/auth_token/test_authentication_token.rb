# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    module AuthToken
      class TestAuthenticationToken < Minitest::Test
        def setup
          @simple_token = URI.encode_www_form('x-amz-expires' => '900')
        end

        def test_init_token_is_valid
          authentication_token = AuthenticationToken.new(@simple_token)

          assert_equal @simple_token, authentication_token.to_str

          Timecop.freeze '2001-02-03T04:05:06.789Z' do
            Timecop.freeze 839.9 do
              assert_predicate(authentication_token, :valid?)
            end
            Timecop.freeze 840.1 do
              refute_predicate(authentication_token, :valid?)
            end
          end
        end
      end
    end
  end
end
