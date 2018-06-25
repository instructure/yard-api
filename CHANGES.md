# Changelog

## 0.3.7

- Corrected LICENSE file to include the AGPL 3.0 copy.
- Cleaned up a few gemspec warnings

## 0.3.5

- In JSON format, an API resource endpoint now contains the name as well.
- Changed the `topicize()` helper in a way that makes the IDs (and URLs of
  some sections) much more readable

## 0.3.4

- Fixed an issue that prevented overriding the Rake task's options at runtime.
- Updated `config/yard_api.yml` to reflect the recently added options.

## 0.3.3

- Improved the JSON format's output to be more concise and consistent.

## 0.3.1

- Fixed a bug that was listing all the endpoints of a certain controller even if they do not have a route defined. Now, YARD-API will warn about endpoints that have an `@API` tag but could not be routed.
- Greatly improved the performance of generating the Quicklinks table.

## 0.3.0

- major rework of the linking logic, much improvements but some stuff is broken now

## 0.2.3]

- dropped the `@argument_scope` tag
- JSON is available as an output format now
- added usage documentation, found at [http://amireh.github.io/yard-api]
- added an example app
- various style improvements
- `@example_request` is now able to output a sample cURL command.

## 0.1.7

- new compatibility option `leading_argument_name_fix`

## 0.1.1

- `@argument` tags can now be formatted in a table by setting the `tabular_arguments` option to true
- `@argument_scope`: a new tag that improves the formatting of endpoint arguments that are scoped by a common prefix (e.g, nested inside a json object), like `user[name]` => `name`
- `@argument` can now parse accepted values in two formats; inline within the types array, or by explicitly writing it in the tag text using any of `Accepted values: [...]`, `Accepts: [...]`, or `Possible values: [...]`
- A new option: `strict_arguments` that provides a default for the `is_required` property of `@argument` tags. This default is used if the tag does not explicitly state `Optional` or `Required` in its type specifier.
- Support for dynamic javascript and style code based on options. See `templates/layout/setup.rb#inline_{javascripts,stylesheets}`
- A new set of options for customizing layout: `content_width`, `sidebar_width` and `spacer`
- `github_url` and `github_branch` options for tuning api endpoint source links

## 0.1.0

- Support for single-page output through the `one_file` option
- Support for resource index generation ("All Resources") through the `resource_index` option
- Support for github-flavored markdown when you're using Markdown as a markup, and `redcarpet` as the provider
- Syntax highlighting for multiple languages (with auto-detection) using [highlight.js](https://highlightjs.org/)
- `@example_response` and `@example_request` tags now support a title for the response
- A new option: `copyright` for displaying a copyright in the footer of every page
- A new option: `footer_note` for displaying a custom note, like linking to the project's source code, in the footer of every page
