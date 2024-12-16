# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module AuthToken
      class Generator
        def initialize
          aws_config = Aws::RDS::Client.new.config

          @generator = Aws::RDS::AuthTokenGenerator.new(credentials: aws_config.credentials)
          @region = aws_config.region

          @cache = {}
          @cache_mutex = Mutex.new
        end

        def call(host:, port:, username:)
          cache_key = "#{host}:#{port}:#{username}"

          cached_token = @cache[cache_key]&.value
          return cached_token if cached_token

          @cache_mutex.synchronize do
            # :nocov: Executed only when parallel thread just created token
            cached_token = @cache[cache_key]&.value
            return cached_token if cached_token

            # :nocov:

            generator.auth_token(
              region: region,
              endpoint: "#{host}:#{port}",
              user_name: username.to_s
            ).tap do |token|
              @cache[cache_key] = ExpirableToken.new(token)
            end
          end
        end

        private

        attr_reader :generator, :region
      end
    end
  end
end
