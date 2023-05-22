# frozen_string_literal: true

require 'mysql2'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem_extension(Mysql2)
loader.setup

module Mysql2
  module AwsRdsIam
  end
end
