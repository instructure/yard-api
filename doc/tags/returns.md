# `@returns`

This tag describes an [*API data object*](#Tags/doc/tags/object.md) that it outputs on successful response.

## Syntax

```ruby
# @returns {API::OBJECT_PATH}   ||
# @returns {API::OBJECT_PATH[]}
```

The former denotes returning a single object, while the latter an array of them.

## Examples

```ruby
# @API Quiz Permissions
# 
# Manage and update an author's quiz permissions.
# 
# @object PermissionSet
#   {
#     "read": {
#       "description": "whether the user can view the quiz",
#       "example": true,
#       "type": "boolean"
#     },
#     "update": {
#       "description": "whether the user may update the quiz",
#       "example": true,
#       "type": "boolean"
#     }
#   }
#
class QuizzesController < ApplicationController
  # @API Retrieve your active permissions
  # 
  # @returns {API::QuizPermissions::PermissionSet[]}
  def index
  end

  # @API Retrieve a single permission record
  # 
  # @returns {API::QuizPermissions::PermissionSet}
  def show
  end
```