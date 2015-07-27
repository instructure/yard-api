# `@argument`

The `@argument` tag lets you describe a parameter your API endpoint accepts.

## Basic

### Syntax

```ruby
# @argument [TYPE_SPECIFIER] NAME
#  Description.
```

### Example

```ruby
class ShirtOrdersController < ApplicationController
    # @argument [String] color
    #  The color of the shirt.
    def create()
    end
end
```

## With an "allowed values" enum

It is possible to specify what values are valid for this argument - this enum will be rendered in a special manner in the output.

### Syntax

```ruby
# @argument [TYPE_SPECIFIER, [ALLOWED_VALUES]] NAME
#  Description.
```

`ALLOWED_VALUES` should be a list of quoted strings, delimited by `,` or `|`.

### Example

```ruby
class ShirtOrdersController < ApplicationController
    # @argument [String, ["S", "M", "L", "XL"]] size
    #  The size of the shirt.
    def create()
    end
end
```

## Specifying required/optional parameters

Prepend the type specifier by either `Required` or `Optional` to mark the parameter as such.

For example, marking the `color` argument as required:

```ruby
class ShirtOrdersController < ApplicationController
    # @argument [Required, String] color
    #  The color of the shirt.
    def create()
    end
end
```

Conversely, to mark that parameter as optional:

```ruby
class ShirtOrdersController < ApplicationController
    # @argument [Optional, String] color
    #  The color of the shirt.
    def create()
    end
end
```

This functionality is affected by the `strict_arguments` option; if it is enabled, all arguments are assumed to be required, and you don't need to explicitly write `Required` in the `@argument` tag docstring. However, in that case, you must explicitly write `Optional` in the docstring to mark the parameter otherwise. And vice versa.