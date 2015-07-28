# `@beta`

This tag marks the API or an endpoint as *beta* informing the user that it is subject to change.

Example:

```ruby
# @API Reorder quiz items
# @beta
#
# Change order of the quiz questions or groups within the quiz
def reorder
end
```

The UI can display either a non-obtrusive "BETA" marker next to the endpoint's API text, or can display a full banner below the endpoint's route that is more clear but is obviously obtrusive.

See the options `use_beta_flag` and `use_beta_banner`.