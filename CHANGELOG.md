# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased
### Added

- Add ability to serialize most of an item response from the Beta REST API into a usable `Wikidatum::Item` instance.
  - This enables basic functionality like `client.item(id: 'Q123')` and `client.item(id: 'Q123').statements(properties: ['P123'])`.

### Internal

- Add YARD docs and auto-deploy them with GitHub Pages.

## 0.1.0 - 2022-06-20
### Added

- Initial release, nothing is really usable yet.

