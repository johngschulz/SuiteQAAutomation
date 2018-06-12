# Boundless Server QA

This module contains QA procedures, test cases, and scripts for testing Boundless Server and Boundless Server Enterprise as a whole (on top of the regular unit tests run by each subcomponent).

*The following content is currently under construction, and subject to change at any time.*

## Katalon

[Katalon](https://www.katalon.com/) is used for integration testing Web UI and Web API components in Boundless Server. For more details, refer to [katalon/README.md](./katalon/README.md).

## Robot
`robot` contains robot framework integration tests, primarily a holdover from the previous test suite and in particular
the backup/restore integration test that hasn't been ported to Katalon so far. These tests require robot 3.

## Test Data

The [test_data](./test_data) directory contains test data that is used by various integration tests. It should be copied into the GeoServer data directory before you run any tests.