# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased

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

