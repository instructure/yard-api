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

**29/7/2015 [0.3.0]**

- major rework of the linking logic, much improvements but some stuff is broken now

**28/7/2015 [0.2.3]**

- dropped the `@argument_scope` tag
- JSON is available as an output format now
- added usage documentation, found at [http://amireh.github.io/yard-api]
- added an example app
- various style improvements
- `@example_request` is now able to output a sample cURL command.

**0.1.7**

- new compatibility option `leading_argument_name_fix`

**15/9/2014**

- `@argument` tags can now be formatted in a table by setting the `tabular_arguments` option to true
- `@argument_scope`: a new tag that improves the formatting of endpoint arguments that are scoped by a common prefix (e.g, nested inside a json object), like `user[name]` => `name`
- `@argument` can now parse accepted values in two formats; inline within the types array, or by explicitly writing it in the tag text using any of `Accepted values: [...]`, `Accepts: [...]`, or `Possible values: [...]`
- A new option: `strict_arguments` that provides a default for the `is_required` property of `@argument` tags. This default is used if the tag does not explicitly state `Optional` or `Required` in its type specifier.
- Support for dynamic javascript and style code based on options. See `templates/layout/setup.rb#inline_{javascripts,stylesheets}`
- A new set of options for customizing layout: `content_width`, `sidebar_width` and `spacer`
- `github_url` and `github_branch` options for tuning api endpoint source links

**14/9/2014**

- Support for single-page output through the `one_file` option
- Support for resource index generation ("All Resources") through the `resource_index` option

**10/9/2014**

- Support for github-flavored markdown when you're using Markdown as a markup, and `redcarpet` as the provider
- Syntax highlighting for multiple languages (with auto-detection) using [highlight.js](https://highlightjs.org/)
- `@example_response` and `@example_request` tags now support a title for the response
- A new option: `copyright` for displaying a copyright in the footer of every page
- A new option: `footer_note` for displaying a custom note, like linking to the project's source code, in the footer of every page

## License

Released under the [AGPLv3](http://www.gnu.org/licenses/agpl-3.0.html) license.