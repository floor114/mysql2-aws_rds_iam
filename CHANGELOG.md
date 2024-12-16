# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/floor114/mysql2-aws_rds_iam/compare/v0.1.0...HEAD)

No notable changes.

## [0.2.0](https://github.com/floor114/mysql2-aws_rds_iam/compare/v0.1.0...v0.2.0) - 2024-12-16

### Added
* Cache and reuse generated tokens ([#5](https://github.com/floor114/mysql2-aws_rds_iam/pull/5))

## [0.1.0](https://github.com/floor114/mysql2-aws_rds_iam/compare/f7035d3fea3ac90e6c1b8193f8befe797a425179...v0.1.0) - 2024-01-14

### Added
* `Mysql2::AwsRdsIam` is an extension of [mysql2](https://github.com/brianmario/mysql2) gem that adds support of [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) when connecting to MySQL in Amazon RDS.
