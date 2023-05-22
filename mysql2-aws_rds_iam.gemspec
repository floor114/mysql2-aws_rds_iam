# frozen_string_literal: true

require_relative 'lib/mysql2/aws_rds_iam/version'

Gem::Specification.new do |spec|
  spec.name = 'mysql2-aws_rds_iam'
  spec.version = Mysql2::AwsRdsIam::VERSION
  spec.authors = ['Taras Shpachenko']
  spec.email = ['taras.shpachenko@gmail.com']

  spec.summary = 'AWS RDS IAM authentication for MySQL'
  spec.description = 'Mysql2::AwsRdsIam is an extension of mysql2 gem that adds support ' \
                     'of IAM authentication when connecting to MySQL in Amazon RDS.'
  spec.homepage = 'https://github.com/floor114/mysql2-aws_rds_iam'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['documentation_uri'] = "https://rubydoc.info/gems/mysql2-aws_rds_iam/#{Mysql2::AwsRdsIam::VERSION}"

  spec.files = Dir[
    'lib/**/*.rb',
    '.yardopts',
    'CHANGELOG.md',
    'LICENSE.txt',
    'mysql2-aws_rds_iam.gemspec',
    'README.md'
  ]
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'aws-sdk-rds', '~> 1'
  spec.add_dependency 'mysql2'
  spec.add_dependency 'zeitwerk', '~> 2'
end
