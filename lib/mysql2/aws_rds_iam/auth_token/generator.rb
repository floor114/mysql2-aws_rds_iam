# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module AuthToken
      class Generator
        def initialize
          aws_config = Aws::RDS::Client.new.config

          @generator = Aws::RDS::AuthTokenGenerator.new(credentials: aws_config.credentials)
          @region = aws_config.region
          @mutex = Mutex.new
          @cache = {}
        end

        def call(host:, port:, username:)
          endpoint = "#{host}:#{port}"
          key = "#{username}@#{endpoint}"

          token = cached_token(key)
          return token if token

          @mutex.synchronize do
            token = cached_token(key)
            # :nocov:   # This is only hit if a parallel thread just created a token before we got into our block
            break token if token

            # :nocov:
            generator.auth_token(
              region: region,
              endpoint: "#{host}:#{port}",
              user_name: username.to_s
            ).tap do |new_token|
              @cache[key] = AuthenticationToken.new(new_token)
            end
          end
        end

        private

        def cached_token(key)
          token = @cache[key]
          token.to_str if token&.valid?
        end

        attr_reader :generator, :region
      end
    end
  end
end
