# `@API`

The `@API` tag is what tells YARD-API that this object (controller or method) is relevant.

> **Warning**
> 
> This tag *MUST* be present on the API controller's `class` tag for it and 
> any of its methods to be parsed.

## Examples

### Documenting an API

```ruby
# @API Quizzes
# 
class Quizzes::QuizzesApiController < ApplicationController
  # ...
end
```

### Documenting an API endpoint

```ruby
# @API List quizzes in a course
#
# Returns the list of Quizzes in this course.
#
# @argument search_term [String]
#   The partial title of the quizzes to match and return.
#
# @example_request
#     curl https://<canvas>/api/v1/courses/<course_id>/quizzes \ 
#          -H 'Authorization: Bearer <token>'
#
# @returns [Quiz]
def index
  # ...
end
```