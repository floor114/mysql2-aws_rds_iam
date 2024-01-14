# frozen_string_literal: true

require 'test_helper'

module Mysql2
  module AwsRdsIam
    module AuthToken
      class TestRegistry < Minitest::Test
        def setup
          @default_generator = ->(host:, port:, username:) { "default(#{username}@#{host}:#{port})" }

          Mysql2::AwsRdsIam::AuthToken::Generator.expects(:new).once.returns(@default_generator)

          @registry = Mysql2::AwsRdsIam::AuthToken::Registry.new
        end

        def test_that_it_initializes_with_default_generator
          assert_equal @default_generator, @registry[:default]
        end

        def test_that_it_adds_custom_generator
          custom_generator = ->(host:, port:, username:) { "custom(#{username}@#{host}:#{port})" }

          @registry.add(:custom, custom_generator)

          assert_equal custom_generator, @registry[:custom]
        end

        def test_that_it_removes_generator
          @registry.delete(:default)

          assert_nil @registry[:default]
        end
      end
    end
  end
end
