# `@internal`

Mark an object to be _internal_ so that it does not show up in the API docs. This is equivalent to not defining an `@API` tag on the object.

You can set the Boolean config `include_internal` to `true` if you want objects marked as _internal_ to show up in the API docs anyway. By that mechanism it is possible to generate "internal use only" documentation sets which include documentation for things that shouldn't be in the publicly-accessible documentation.


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
