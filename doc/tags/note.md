# `@note`

This is similar to the [`@warning`](#Tags/doc/tags/warning.md) tag; it can be used to display text (usually subsidiary) in a specially-formatted box that will not interrupt the user's current reading flow.

## Syntax

```ruby
# @note
#   Your note.
```

## Example

```ruby
# @API Shirts
class ShirtOrdersController < ApplicationController
  # @API Order a new shirt
  # 
  # Create a shirt order and have it delivered to your doorstep.
  # 
  # @note
  #  All our shirts are knit by oragnic-eating knitters.
  #
  def create
  end
end
```
