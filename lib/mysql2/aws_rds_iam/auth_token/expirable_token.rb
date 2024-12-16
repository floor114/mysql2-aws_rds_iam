# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module AuthToken
      class ExpirableToken
        # By default token is valid for up to 15 minutes, here we expire it after 14 minutes
        DEFAULT_EXPIRE_AT = (15 * 60) # 15 minutes
        EXPIRATION_THRESHOLD = (1 * 60) # 1 minute
        EXPIRE_HEADER = 'x-amz-expires'

        def initialize(token)
          @token = token
          @created_at = now
          @expire_at = parse_expiration || DEFAULT_EXPIRE_AT
        end

        def value
          token unless expired?
        end

        private

        attr_reader :token, :created_at, :expire_at

        def expired?
          (now - created_at) > (expire_at - EXPIRATION_THRESHOLD)
        end

        def now
          Process.clock_gettime(Process::CLOCK_MONOTONIC)
        end

        def parse_expiration
          query = URI.parse("https://#{token}").query

          return nil unless query

          URI.decode_www_form(query)
             .filter_map { |(key, value)| Integer(value) if key.downcase == EXPIRE_HEADER }
             .first
        rescue StandardError
          nil
        end
      end
    end
  end
end
