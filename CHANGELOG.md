# Change Log
All notable changes to the `ssl_certificate` cookbook will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed
- CHANGELOG: Follow "Keep a CHANGELOG".

## [2.1.0] - 2017-02-10
### Added
- Adds certificate chain to PKCS12 file ([issue #32](https://github.com/zuazo/ssl_certificate-cookbook/pull/32), thanks [Andrew J. Brown](https://github.com/andrewjamesbrown)).

### Removed
- Metadata: Remove grouping ([RFC-85](https://github.com/chef/chef-rfc/blob/master/rfc085-remove-unused-metadata.md)).

## [2.0.0] - 2016-11-28
### Added
- Support for extendedKeyUsage and RSA key length ([issue #28](https://github.com/zuazo/ssl_certificate-cookbook/pull/28), thanks [Ali Ardestani](https://github.com/alisade) and [HawkAndBaby](https://github.com/hawkandbaby)).
- Make resolver changeable on Nginx ([issue #29](https://github.com/zuazo/ssl_certificate-cookbook/pull/29), thanks [@runningman84](https://github.com/runningman84) for reporting).

### Changed
- Require Chef `12` and Ruby `2.2` or higher (**breaking change**).

## [1.12.0] - 2016-06-06
### Added
- Add support for CA with passphrase ([issue #16](https://github.com/zuazo/ssl_certificate-cookbook/pull/16), thanks [Baptiste Courtois](https://github.com/Annih)).
- Fallback to unencrypted data bag with `node['chef-vault']['databag_fallback']` ([issue #25](https://github.com/zuazo/ssl_certificate-cookbook/pull/25), thanks [Alexey Demidov](https://github.com/AlexeyDemidov)).
- Add custom file mode for key file ([issue #26](https://github.com/zuazo/ssl_certificate-cookbook/pull/26), thanks [Alexey Demidov](https://github.com/AlexeyDemidov)).

### Changed
- Update RuboCop to `0.40`.
- Documentation:
 - Improve `chain_name` parameter requirement documentation ([issue #24](https://github.com/zuazo/ssl_certificate-cookbook/issues/24), thanks [Alexey Demidov](https://github.com/AlexeyDemidov)).
 - Improve TESTING documentation.
 - README: Add license badge.

### Removed
- Remove useless test attributes ([issue #16](https://github.com/zuazo/ssl_certificate-cookbook/pull/16), thanks [Baptiste Courtois](https://github.com/Annih)).

## [1.11.0] - 2015-12-10
### Changed
- Fix some RuboCop offenses.

### Fixed
- Only add internal file resources to the collection when running tests ([issue #23](https://github.com/zuazo/ssl_certificate-cookbook/pull/23), thanks [Karl Svec](https://github.com/karlsvec)).
- Fix sending notifications from the `ssl_certificate` resource ([issue #21](https://github.com/zuazo/ssl_certificate-cookbook/pull/21), thanks [Karl Svec](https://github.com/karlsvec)).

## [1.10.0] - 2015-11-23
### Changed
- README: Some typos and improvements.
- RuboCop `~> `0.35.0`.

### Fixed
- Fix some certificate errors on Windows due to CRLF conversion ([issue #19](https://github.com/zuazo/ssl_certificate-cookbook/pull/19), thanks [Taliesin Sisson](https://github.com/taliesins)).
- Fix *undefined method pkcs12_path for Chef::Resource::File* error.

## [1.9.0] - 2015-09-06
### Added
- Add support for [PKCS12](https://en.wikipedia.org/wiki/PKCS_12) ([issue #17](https://github.com/zuazo/ssl_certificate-cookbook/pull/17), thanks [Baptiste Courtois](https://github.com/Annih)).
- metadata: Add `source_url` and `issues_url` links.
- README: Add *Real-world Examples* section.

### Changed
- Gemfile: Update RuboCop to `0.34.0`.

## [1.8.1] - 2015-09-03
### Fixed
- README: Fix title.

## [1.8.0] - 2015-09-03
### Added
- Add Windows support ([issue #15](https://github.com/zuazo/ssl_certificate-cookbook/pull/15), thanks [Baptiste Courtois](https://github.com/Annih)).
- Add Oracle Linux and Scientific Linux support.
- README: Add ca path documentation to the namespace attributes.

### Changed
- Improve platforms support using `node['platform_family']` attribute.
- README: Improve description.

### Fixed
- Fix Chef Supermarket cookbook links.

## [1.7.0] - 2015-08-12
### Changed
- Update contact information and links after migration.
- Update chef links to use *chef.io*.
- Gemfile: Update RuboCop to `0.33.0`.

### Fixed
- Fix README tables.

## [1.6.0] - 2015-08-02
### Added
- README: Add GitHub badge.

### Changed
- Update RuboCop to `0.32.1`.
- README: Use markdown tables.

### Fixed
- Load encrypted secret before passing to the `EncryptedDataBagItem.load` ([issue #14](https://github.com/zuazo/ssl_certificate-cookbook/pull/14), thanks [Nikita Borzykh](https://github.com/sample)).

## [1.5.0] - 2015-04-25
### Added
- Add sensitive true to the created files ([issue #12](https://github.com/zuazo/ssl_certificate-cookbook/issues/12), thanks [Jonathan Chauncey](https://github.com/jchauncey) for reporting).
- Add support for different types in Subject Alternative Names ([issue #13](https://github.com/zuazo/ssl_certificate-cookbook/issues/13), thanks [Jonathan Chauncey](https://github.com/jchauncey) for reporting).

### Changed
- README: Fix all RuboCop offenses in examples.
- Gemfile: Update RuboCop to `0.30.1`.

## [1.4.0] - 2015-04-05
### Added
- Add `attr_apply` recipe: Create a certificate list from attributes ([issue #10](https://github.com/zuazo/ssl_certificate-cookbook/pull/10), thanks [Stanislav Bogatyrev](https://github.com/realloc)).

### Changed
- Update RuboCop to `0.29.1` (fix some new offenses).

### Fixed
- Fix invalid metadata ([issue #11](https://github.com/zuazo/ssl_certificate-cookbook/pull/11), thanks [Karl Svec](https://github.com/karlsvec)).

## [1.3.0] - 2015-02-03
### Added
- Add `namespace['source']` common attribute.

### Fixed
- Fix chef vault source: `chef_gem` method not found error.
- Fix `#data_bag_read_fail` method name.
- README: Fix *item_key* attribute name.

## [1.2.2] - 2015-01-16
### Fixed
- Fix unit tests: Run the tests agains Chef 11 and Chef 12.

## [1.2.1] - 2015-01-16
### Fixed
- Fix *key content* when using `'file'` source.

## [1.2.0] - 2015-01-07
### Added
- Document the *ServiceHelpers* methods.

### Changed
- Rename template helpers to service helpers.

### Fixed
- Fix file source path in attributes.
- Fix *"stack level too deep"* error with CA certificates.
- Nginx template: Add `ssl on;` directive.
- README: Some small fixes.

### Removed
- Remove setting CA in apache template (bad idea).

## [1.1.0] - 2015-01-02
### Added
- Allow to change the certificate file owner.
- Web server template improvements:
 - Add partial templates for Apache and nginx.
 - Add CA certificate file support.
 - Add adjustable SSL compatibility level.
 - Add OCSP stapling support.
 - Enable HSTS and stapling by default.

### Fixed
- Fix FreeBSD support.
- Fix all integration tests.
- Fix Apache 2.4 support.

## [1.0.0] - 2014-12-30
### Added
- Add CA support for self signed certificates ([issue #8](https://github.com/zuazo/ssl_certificate-cookbook/pull/8), thanks [Jeremy MAURO](https://github.com/jmauro)).

### Changed
- Apache template:
  - Disable `SSLv3` by default (**breaking change**).
  - Add chained certificate support.
  - Allow to change the cipher suite and protocol in the apache template.
- Big code clean up:
  - Split resource code in multiple files.
  - Remove duplicated code.
  - Integrate with foodcritic.
  - Integrate with RuboCop.
  - Homogenize license headers.
- README:
  - Multiple fixes and improvements ([issue #9](https://github.com/zuazo/ssl_certificate-cookbook/pull/9), thanks [Benjamin Nørgaard](https://github.com/blacksails)).
  - Split in multiple files.
  - Add TOC.
  - Add badges.

### Fixed
- Bugfix: Cannot read SSL intermediary chain from data bag.
- Fix Directory Permissions for Apache `2.4` ([issue #7](https://github.com/zuazo/ssl_certificate-cookbook/pull/7), thanks [Elliott Davis](https://github.com/elliott-davis)).

## [0.4.0] - 2014-11-19
### Added
- Add Apache 2.4 support ([issue #4](https://github.com/zuazo/ssl_certificate-cookbook/pull/4), thanks [Djuri Baars](https://github.com/dsbaars)).
- Add supported platform list.

## [0.3.0] - 2014-11-03
Special thanks to [Steve Meinel](https://github.com/smeinel) for his great contributions.

### Added
- Add Subject Alternate Names support for certs ([issue #2](https://github.com/zuazo/ssl_certificate-cookbook/pull/2), thanks [Steve Meinel](https://github.com/smeinel)).
- Add support for deploying an intermediate cert chain file ([issue #3](https://github.com/zuazo/ssl_certificate-cookbook/pull/3), thanks [Steve Meinel](https://github.com/smeinel)).
- ChefSpec matchers: add helper methods to locate LWRP resources.

## [0.2.1] - 2014-09-14
### Fixed
- `ssl_certificate` resource notifications fixed (issue [#1](https://github.com/zuazo/ssl_certificate-cookbook/pull/1), thanks [Matt Graham](https://github.com/gadgetmg) for reporting)

## [0.2.0] - 2014-08-13
### Added
- Added ChefSpec ssl_certificate matcher

### Fixed
- Fixed: undefined method "key_path" for nil:NilClass
- README: fixed ruby syntax highlighting in one example

## 0.1.0 - 2014-04-15
- Initial release of `ssl_certificate`

[Unreleased]: https://github.com/zuazo/ssl_certificate-cookbook/compare/2.1.0...HEAD
[2.1.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.12.0...2.0.0
[1.12.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.11.0...1.12.0
[1.11.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.10.0...1.11.0
[1.10.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.9.0...1.10.0
[1.9.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.8.1...1.9.0
[1.8.1]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.8.0...1.8.1
[1.8.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.7.0...1.8.0
[1.7.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.6.0...1.7.0
[1.6.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.5.0...1.6.0
[1.5.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.4.0...1.5.0
[1.4.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.2.2...1.3.0
[1.2.2]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.2.1...1.2.2
[1.2.1]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/0.4.0...1.0.0
[0.4.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/0.3.0...0.4.0
[0.3.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/0.2.1...0.3.0
[0.2.1]: https://github.com/zuazo/ssl_certificate-cookbook/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/zuazo/ssl_certificate-cookbook/compare/0.1.0...0.2.0
