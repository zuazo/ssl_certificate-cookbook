ssl_certificate CHANGELOG
=========================

This file is used to list changes made in each version of the `ssl_certificate` cookbook.

## v0.4.0 (2014-11-19)

* Add Apache 2.4 support ([issue #4](https://github.com/onddo/ssl_certificate-cookbook/pull/4), thanks [Djuri Baars](https://github.com/dsbaars)).
* Add supported platform list.
* kitchen.yml completed and updated.

## v0.3.0 (2014-11-03)

Special thanks to [Steve Meinel](https://github.com/smeinel) for his great contributions.

* Add Subject Alternate Names support for certs ([issue #2](https://github.com/onddo/ssl_certificate-cookbook/pull/2), thanks [Steve Meinel](https://github.com/smeinel)).
* Add support for deploying an intermediate cert chain file ([issue #3](https://github.com/onddo/ssl_certificate-cookbook/pull/3), thanks [Steve Meinel](https://github.com/smeinel)).
* ChefSpec matchers: add helper methods to locate LWRP resources.
* README: Chef `11.14.2` required.
* TODO: complete it with more tasks and use checkboxes.

## v0.2.1 (2014-09-14)

* `ssl_certificate` resource notifications fixed (issue [#1](https://github.com/onddo/ssl_certificate-cookbook/pull/1), thanks [Matt Graham](https://github.com/gadgetmg) for reporting)

## v0.2.0 (2014-08-13)

* Added ChefSpec ssl_certificate matcher
* Fixed: undefined method "key_path" for nil:NilClass
* README: fixed ruby syntax highlighting in one example

## v0.1.0 (2014-04-15)

* Initial release of `ssl_certificate`
