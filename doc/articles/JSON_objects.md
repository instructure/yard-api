# JSON Objects

When a tag supports embedding any JSON object, it *has* to be valid JSON. You can use tools like [JSONEditor](http://jsoneditoronline.org/) to validate your JSON blobs, or any JSON linter really.

YARD-API will not accept invalid JSON; it will either bail if `strict` mode is turned on, or will simply ignore the object otherwise. The output will include a warning in either case.

## Linking to JSON objects

It is possible to link to other API objects (defined by the [`@object`](#Tags/doc/tags/object.md) tag) by using the following notation:

`{api:CONTROLLER_ID:OBJECT_ID}`

For example, to link to the object defined in the example below, we'll use `{api:Quizzes:QuizPermissions}`:

```ruby
# @API Quizzes
#
# @object QuizPermissions
#   {
#     "read": {
#       "description": "whether the user can view the quiz",
#       "example": true,
#       "type": "boolean"
#     },
#     "submit": {
#       "description": "whether the user may submit a submission for the quiz",
#       "example": true,
#       "type": "boolean"
#     }
#   }
#
class QuizzesController < ApplicationController
  # @API Retrieve your active permissions
  # 
  # @returns {QuizPermissions}
  def get_permissions
  end
end
```

And if you want to reference an object defined in a different controller:

```ruby
class QuizExtensionsController < ApplicationController
  # @API Retrieve all available permissions
  # 
  # @returns {api:Quizzes:QuizPermissions[]}
  def index
  end
end
```