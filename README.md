# yard-api

[![Build Status](https://travis-ci.org/amireh/yard-api.png)](https://travis-ci.org/amireh/yard-api)

## Usage

See [https://amireh.github.io/yard-api].

### Compatibility options

#### `@argument` tags with names specified before types

For tags that have a type and a name such as the YARD `@attr` tag, or the yard-api `@argument` tag, the "correct" syntax is to specify the types *before* the name. For example:

```ruby
# @argument [String] name
#   This is compliant with YARD syntax.
#
# @argument name [String]
#   This is not compliant with YARD syntax.
```

If your project already uses the (incorrect) second syntax and you would like to keep things that way, then you can use the compatibility option `leading_argument_name_fix` to have yard-api correctify this and understand both flavors.

## Configuration

`yard-api` will look for a file in `config/yard_api.yml` in the Rails root for customizations. Configuration fields not specified in that file will be filled with the default values found in [config/yard_api.yml](https://github.com/amireh/yard-api/blob/master/config/yard_api.yml).

Read that file to view all the available options.

## Notes

- can only document classes and class methods; modules, root objects, and constants are ignored

## Generating the docs for YARD-API

1. go to the `gh-pages` branch, check it out if you haven't
2. run `bin/generate-docs`
3. browse `index.html`

## Changelog

See CHANGES.md.

## License

Released under the [AGPLv3](http://www.gnu.org/licenses/agpl-3.0.html) license.
