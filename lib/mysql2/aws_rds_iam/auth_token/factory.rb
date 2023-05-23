# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module AuthToken
      class Factory
        DEFAULT_GENERATOR = :default

        def self.call(generator, host, port, username)
          AwsRdsIam.auth_token_registry.fetch(generator&.to_sym || DEFAULT_GENERATOR).call(
            host: host,
            port: port,
            username: username
          )
        end
      end
    end
  end
end
