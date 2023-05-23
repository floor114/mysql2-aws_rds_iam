# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

No notable changes.

## [0.1.0] - 2024-01-14

### Added
* `Mysql2::AwsRdsIam` is an extension of [mysql2](https://github.com/brianmario/mysql2) gem that adds support of [IAM authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) when connecting to MySQL in Amazon RDS.
* ActiveRecord support. ([#3](https://github.com/haines/pg-aws_rds_iam/pull/3))
