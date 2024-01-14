# Mysql2::AwsRdsIam

[![Gem](https://img.shields.io/gem/v/mysql2-aws_rds_iam)](https://rubygems.org/gems/mysql2-aws_rds_iam)
&ensp;
![CI](https://img.shields.io/github/actions/workflow/status/floor114/mysql2-aws_rds_iam/ci.yml)

`Mysql2::AwsRdsIam` is an extension of [mysql2](https://github.com/brianmario/mysql2) gem that adds support of [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) when connecting to MySQL in Amazon RDS.

This gem is a powerful tool that enables seamless connection to MySQL databases using the [mysql2](https://github.com/brianmario/mysql2) gem. It leverages the dynamic password generation feature of AWS RDS [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) for enhanced security and easy password management.


## Installation

Install manually:

```console
$ gem install mysql2-aws_rds_iam
```

or with Bundler:

```console
$ bundle add mysql2-aws_rds_iam
```

## Usage

To leverage [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) for your database connections, follow these steps:

1. Enable [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) for your database through AWS 
2. Add IAM credentials to your application.
3. Set up your application to generate authentication tokens.


### Application configurations

The default algorithm is `Mysql2::AwsRdsIam`'s [default authentication token generator](https://github.com/floor114/mysql2-aws_rds_iam/blob/main/lib/mysql2/aws_rds_iam/auth_token/generator.rb). Credentials and region are extracted using [aws-sdk-rds](https://github.com/aws/aws-sdk-ruby/tree/version-3/gems/aws-sdk-rds) configurations.


#### Apply msql2 patch
To connect to your MySQL database, you need to create initializer file that applies the patch:

  ```ruby
  # config/initializers/tcc_rds_iam_auth.rb

  Tcc::RdsIamAuth.apply_patch

  ```

#### Configure `database.yml`
New rds_iam_auth_host parameter must be added to the database.yml file:

  ```yaml
  production:
    # ...
    aws_rds_iam_auth: true
  ```

#### Custom token generator
If the default generator doesn't meet your needs, you can create a custom one

  ```ruby
  # config/initializers/tcc_rds_iam_auth.rb

  Mysql2::AwsRdsIam.auth_token_registry.add(:custom, ->(host, port, username) { 'your custom logic' })

  ```

and specify it in `database.yml`

  ```yaml
  production:
    # ...
    aws_rds_iam_auth: true
    aws_rds_iam_auth_token_generator: custom
  ```

`Mysql2::AwsRdsIam.auth_token_registry` accepts two parameters:
1. Generator name. The same name should be specified in `database.yml`
2. Object that responds to `call` method and accepts 3 arguments (`host, port, username`) specified in `database.yml`.

##### Possible generator types
* Lambda
  ```ruby
  Mysql2::AwsRdsIam.auth_token_registry.add(:custom, ->(host, port, username) { 'your custom logic' })

  ```
* Generator instance
  ```ruby
  class CustomGenerator
    def call(host, port, username)
      GenerateMyCode
    end
  end

  Mysql2::AwsRdsIam.auth_token_registry.add(:custom, CustomGenerator.new)

  ```
* Generator class
  ```ruby
  class CustomGenerator
    def self.call(host, port, username)
      GenerateMyCode
    end
  end

  Mysql2::AwsRdsIam.auth_token_registry.add(:custom, CustomGenerator)

  ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the tests and linter. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/floor114/mysql2-aws_rds_iam. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/mysql2-aws_rds_iam/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Special Thanks

Inspired by [Andrew Haines'](https://github.com/haines) PG version [pg-aws_rds_iam](https://github.com/haines/pg-aws_rds_iam)
