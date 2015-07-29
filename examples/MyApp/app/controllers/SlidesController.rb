module Author
	# @API Author - Slides
	#
	# @object OrderedSlide
	#   {
	#     "id": {
	#       "description": "Slide id.",
	#       "example": 10,
	#       "required": true,
	#       "type": "Integer"
	#     },
	#     "position": {
	#       "description": "Published. Slide position in the course.",
	#       "example": 1,
	#       "required": true,
	#       "type": "Integer"
	#     },
	#     "new_position": {
	#       "description": "Unpublished slide position in the course.",
	#       "example": 1,
	#       "required": true,
	#       "type": "Integer"
	#     },
	#     "published_attributes": {
	#       "type": "API::Quizzes::SlideAttributes"
	#     },
	#     "draft_attributes": {
	#       "type": "API::Quizzes::SlideAttributes"
	#     },
	#     "published_at": {
	#       "description": "Required DateTime slide was published.",
	#       "example": "2015-07-14T15:03:49.365-06:00",
	#       "type": "DateTime or null"
	#     },
	#     "estimated_time": {
	#       "description": "Estimated number of minutes to complete slide.",
	#       "example": 1,
	#       "type": "Integer"
	#     },
	#     "attachments": {
	#       "description": "Array of slide attachments",
	#       "example": "TODO",
	#       "type": "TODO"
	#     }
	#   }
	#
	# @object SlideAttributes
	#   {
	#     "id": "SlideAttributes",
	#     "description": "Weehee",
	#     "properties": {
	#       "id": {
	#         "type": "String"
	#       }
	#     }
	#   }
	class SlidesController < ApplicationController
	end
end