# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module ClientExtension
      def initialize(opts = {})
        opts = opts.dup
        aws_rds_iam_auth = opts.delete(:aws_rds_iam_auth)

        if aws_rds_iam_auth
          raise Errors::ReconnectConfigEnabledError if opts[:reconnect]

          username = opts[:username]
          host = opts[:host]
          port = opts[:port]

          raise Errors::UsernameNotFoundError if username.nil?
          raise Errors::HostNotFoundError if host.nil?

          opts.delete(:password)

          aws_rds_iam_auth_token_generator = opts.delete(:aws_rds_iam_auth_token_generator)

          opts[:password] = AuthToken::Factory.call(aws_rds_iam_auth_token_generator, host, port, username)
          opts[:enable_cleartext_plugin] = true
        end

        super(opts)
      end
    end
  end
end
