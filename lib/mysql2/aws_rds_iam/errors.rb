# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module Errors
      class Error < StandardError; end

      class Mysql2ClientNotFoundError < Error
        def initialize
          super('Could not find class or method when patching Mysql2::Client. Please investigate.')
        end
      end

      class ReconnectConfigEnabledError < Error
        def initialize
          super('reconnect config must be false if using AWS RDS IAM authentication.')
        end
      end

      class UsernameNotFoundError < Error
        def initialize
          super('username must be present.')
        end
      end

      class HostNotFoundError < Error
        def initialize
          super('host must be present.')
        end
      end
    end
  end
end
