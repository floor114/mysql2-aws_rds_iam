# frozen_string_literal: true

require 'aws-sdk-rds'
require 'mysql2'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem_extension(Mysql2)
loader.setup

module Mysql2
  module AwsRdsIam
    def self.auth_token_registry
      @auth_token_registry ||= AuthToken::Registry.new
    end

    def self.apply_patch
      const = begin
        Object.const_get('Mysql2::Client')
      rescue StandardError
        raise Errors::Mysql2ClientNotFoundError
      end

      begin
        const.instance_method(:initialize)
      rescue StandardError
        raise Errors::Mysql2ClientNotFoundError
      end

      const.prepend(ClientExtension)
    end
  end

  AwsRdsIam.apply_patch
end
