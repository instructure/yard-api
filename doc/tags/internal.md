# `@internal`

Mark an object to be _internal_ so that it does not show up in the API docs. This is equivalent to not defining an `@API` tag on the object.


## Example

```ruby
  # @API Quizzes
  class QuizzesController
    # @API Retrieve all quizzes
    # 
    # This will show up.
    def index
    end

    # @API Remove a quiz.
    # @internal
    # 
    # This will NOT show up.
    def destroy
    end
  end
```