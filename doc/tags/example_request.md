# `@example_request`

This is an endpoint-only tag. This tag lets you write the (usually JSON) payload that the endpoint accepts. YARD-API will generate example requests that use this payload and hit this endpoint that the user can use (or at least, start with.)

## Synopsis

```ruby
# @example_request [optional brief title]
#  [PAYLOAD]
```

## Basic usage example

This shows an example request that highlights how the objects are passed.

```ruby
# @API Quiz session extensions
class Quizzes::QuizExtensionsController < ApplicationController
  # @API Set extensions for student quiz submissions
  #
  # @example_request
  #  {
  #    "quiz_extensions": [{
  #      "user_id": 3,
  #      "extra_attempts": 2,
  #      "extra_time": 20,
  #      "manually_unlocked": true
  #    },{
  #      "user_id": 2,
  #      "extra_attempts": 2,
  #      "extra_time": 20,
  #      "manually_unlocked": false
  #    }]
  #  }
  #
  # @example_request Extending the student's session by 30 more minutes.
  #  {
  #    "quiz_extensions": [{
  #      "user_id": 3,
  #      "extend_from_now": 20
  #    }]
  #  }
  #
  def create
  end
```

It is sometimes useful to provide a short title that describes what the example request does. This is particularly so when you have more than one example request provided.

Building upon the previous example, we'll add another example and this time we'll title both requests:

```ruby
# @API Quiz session extensions
class Quizzes::QuizExtensionsController < ApplicationController
  # @API Set extensions for student quiz submissions
  #
  # @example_request Managing multiple student sessions and unlocking one of them.
  #  {
  #    "quiz_extensions": [{
  #      "user_id": 3,
  #      "extra_attempts": 2,
  #      "extra_time": 20,
  #      "manually_unlocked": true
  #    },{
  #      "user_id": 2,
  #      "extra_attempts": 2,
  #      "extra_time": 20,
  #      "manually_unlocked": false
  #    }]
  #  }
  #
  # @example_request Extending the student's session by 30 more minutes.
  #  {
  #    "quiz_extensions": [{
  #      "user_id": 3,
  #      "extend_from_now": 20
  #    }]
  #  }
  #
  def create
  end
```
