# yard-api

[![Build Status](https://travis-ci.org/amireh/yard-api.png)](https://travis-ci.org/amireh/yard-api)

TODO

## Usage

TODO

## Notes

- can only document classes and class methods; modules, root objects, and constants are ignored

## Changelog

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