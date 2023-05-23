# frozen_string_literal: true

module Mysql2
  module AwsRdsIam
    module AuthToken
      class Registry < Hash
        def initialize
          add(:default, Generator.new)

          super
        end

        def add(name, generator)
          self[name] = generator
        end
      end
    end
  end
end
