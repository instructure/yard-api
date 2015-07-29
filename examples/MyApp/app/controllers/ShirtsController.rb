# @API Shirts
#
# @object Shirt
#   {
#     "id": "Shirt",
#     "description": "A real T-Shirt.",
#     "properties": {
#       "id": {
#         "type": "String"
#       },
#       "color": {
#         "type": "String",
#         "description": "Color of the shirt."
#       },
#       "size": {
#         "required": true,
#         "type": "String",
#         "accepted_values": [ "S", "M", "L", "XL" ],
#         "description": "Size of the shirt."
#       }
#     }
#   }
#
class ShirtsController < ApplicationController
	def index
	end

	# @API Create a new shirt
	#
	# @argument [Required, String, ["S","M","L","XL"]] shirts[size]
	#  The size of shirts you wear.
	#
	# @argument [Optional, String] shirts[color]
	#  The color of the shirt.
	#
	# @example_request
	#  {
	#    "shirts": [{
	#      "color": "red",
	#      "size": "M"
	#    }]
	#  }
	#
	# @example_request Order a randomly colored shirt!
	#  {
	#    "shirts": [{
	#      "size": "XL"
	#    }]
	#  }
	#
	# @example_response
	#  {
	#    "shirts": [{
	#      "id": "1"
	#    }]
	#  }
	def create
	end

	# @API Return a shirt
	# @beta
	#
	# Return a shirt, probably 'cause you don't like it. See {API::Author-Slides::SlideAttributes}.
	#
	# @argument [Integer] shirt_id
	#  ID of the shirt you want to return.
	#
	# @argument [API::SlideAttributes] test
	# 	Foobar.
	#
	def return
	end
end