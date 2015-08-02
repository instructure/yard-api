# `@warning`

This tag renders as a text block that calls for attention. Use it when there's important information the API user needs to know about.

## Syntax

```ruby
# @warning
#   WARNING_MESSAGE.
```

## Example

```ruby
# @API Shirts
class ShirtOrdersController < ApplicationController
  # @API Order a new shirt
  # 
  # Create a shirt order and have it delivered to your doorstep.
  # 
  # @warning
  #  Please note that according to our fair-usage policy, should you
  #  not be present at the time of delivery, the delivery-man is
  #  hereby authorized to wear it instead.
  #
  def create
  end
end
```
