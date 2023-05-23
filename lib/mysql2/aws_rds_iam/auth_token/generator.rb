# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module AuthToken
      class Generator
        def initialize
          aws_config = Aws::RDS::Client.new.config

          @generator = Aws::RDS::AuthTokenGenerator.new(credentials: aws_config.credentials)
          @region = aws_config.region
        end

        def call(host:, port:, username:)
          generator.auth_token(
            region: region,
            endpoint: "#{host}:#{port}",
            user_name: username.to_s
          )
        end

        private

        attr_reader :generator, :region
      end
    end
  end
end
