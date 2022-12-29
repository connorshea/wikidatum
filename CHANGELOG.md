# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased
### Added

- Add a `labels` method on Wikidatum::Client for getting item label data from the new `items/{id}/labels` endpoint.

### Changed

- Move error classes into their own `Wikidatum::Errors` namespace.

## 0.3.2 - 2022-12-29
### Added

- Add support for the `commonsMedia`, `url`, and `external-id` data types.
- Add `humanized_content` method to `Wikidatum::DataType::Base` class, for easier access to a Struct, string, or nil which represents the contents of the given data type.

## 0.3.1 - 2022-12-28
### Added

- Add an error message when attempting to make a bot edit without authentication, as this will always trigger a 403 error from the REST API.

### Fixed

- Fix the creation of WikibaseItem statements, the format used in the previous release was incorrect.

## 0.3.0 - 2022-12-27
### Added

- Add `allow_ip_edits` argument on `Wikidatum::Client.new`. This protects users from making IP address-exposing edits if they haven't explicitly opted-in to doing that. The argument defaults to false.
- Add code to raise errors when various types of invalid input are passed to `Wikidatum::Client#add_statement`.
- Start testing the gem on Ruby 3.2.

### Fixed

- Update the serializers and `add_statement` method to account for various changes that have been made upstream to the Wikibase REST API.

## 0.2.1 - 2022-08-13
### Fixed

- Fix a mistake that broke loading the gem.

## 0.2.0 - 2022-08-13
### Added

- Add ability to serialize most of an item response from the Beta REST API into a usable `Wikidatum::Item` instance.
  - This enables basic functionality like `client.item(id: 'Q123')` and `client.item(id: 'Q123').statements(properties: ['P123'])`.
- Add `Client#add_statement` method for creating new statements on an item.
- Add `Client#delete_statement` method for deleting statements from an item.
- Add support for reading and writing all statement types: `novalue`, `somevalue`, `string`, `time`, `quantity`, `globecoordinate`, `monolingualtext`, and `wikibase-entityid`.

### Internal

- Add YARD docs and auto-deploy them with GitHub Pages.
- Add comprehensive unit tests for the gem.

## 0.1.0 - 2022-06-20
### Added

- Initial release, nothing is really usable yet.
