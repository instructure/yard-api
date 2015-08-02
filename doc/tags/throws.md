# `@throws`

This tag lets you specify **error messages** that could be thrown by this endpoint on failure.

## Syntax

```ruby
# @throws
#   {
#     "message": "the error message that will be output by the API",
#     "reason": "optional explanation of why this error is thrown"
#   }
```

## Example

```ruby
# @API Users
class UsersController < ApplicationController
  # @API Sign up
  #
  # Create a new account.
  #
  # @argument [String] name
  #  Your full name.
  #  
  # @argument [String] email
  #  Your email.
  #  
  # @argument [String] password
  #  Your password.
  #  
  # @throws 
  #   { "message": "We need your name.",
  #     "reason": "Name is blank." }
  #   
  # @throws 
  #   { "message": "We need your email address.",
  #     "reason": "Email is blank." }
  #     
  # @throws 
  #   { "message": "You must provide a password.",
  #     "reason": "Password is blank."
  #   }
  #   
  # @throws
  #   { "message": "Password is too short, it must be at least 7 characters long." }
  # 
  # @throws 
  #   { "message": "There's already an account registered to this email address." }
  #
  def create
  end
```