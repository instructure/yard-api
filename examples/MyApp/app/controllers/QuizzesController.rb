# @API Quizzes
#
# @object Quiz
#  {
#    "id": "Quiz",
#    "description": "Wazzaa quiz!",
#    "properties": {
#      "id": {
#        "description": "the ID of the quiz",
#        "example": 5,
#        "type": "integer"
#      },
#      "title": {
#        "description": "the title of the quiz",
#        "example": "Hamlet Act 3 Quiz",
#        "type": "string"
#      },
#      "html_url": {
#        "description": "the HTTP/HTTPS URL to the quiz",
#        "example": "http://canvas.example.edu/courses/1/quizzes/2",
#        "type": "string"
#      },
#      "mobile_url": {
#        "description": "a url suitable for loading the quiz in a mobile webview.  it will persiste the headless session and, for quizzes in public courses, will force the user to login",
#        "example": "http://canvas.example.edu/courses/1/quizzes/2?persist_healdess=1&force_user=1",
#        "type": "string"
#      },
#      "preview_url": {
#        "description": "A url that can be visited in the browser with a POST request to preview a quiz as the teacher. Only present when the user may grade",
#        "example": "http://canvas.example.edu/courses/1/quizzes/2/take?preview=1",
#        "type": "string"
#      },
#      "description": {
#        "description": "the description of the quiz",
#        "example": "This is a quiz on Act 3 of Hamlet",
#        "type": "string"
#      },
#      "quiz_type": {
#        "description": "type of quiz possible values: 'practice_quiz', 'assignment', 'graded_survey', 'survey'",
#        "example": "assignment",
#        "type": "string",
#        "allowableValues": {
#          "values": [
#            "practice_quiz",
#            "assignment",
#            "graded_survey",
#            "survey"
#          ]
#        }
#      },
#      "assignment_group_id": {
#        "description": "the ID of the quiz's assignment group:",
#        "example": 3,
#        "type": "integer"
#      },
#      "time_limit": {
#        "description": "quiz time limit in minutes",
#        "example": 5,
#        "type": "integer"
#      },
#      "shuffle_answers": {
#        "description": "shuffle answers for students?",
#        "example": false,
#        "type": "boolean"
#      },
#      "hide_results": {
#        "description": "let students see their quiz responses? possible values: null, 'always', 'until_after_last_attempt'",
#        "example": "always",
#        "type": "string",
#        "allowableValues": {
#          "values": [
#            "always",
#            "until_after_last_attempt"
#          ]
#        }
#      },
#      "show_correct_answers": {
#        "description": "show which answers were correct when results are shown? only valid if hide_results=null",
#        "example": true,
#        "type": "boolean"
#      },
#      "show_correct_answers_last_attempt": {
#        "description": "restrict the show_correct_answers option above to apply only to the last submitted attempt of a quiz that allows multiple attempts. only valid if show_correct_answers=true and allowed_attempts > 1",
#        "example": true,
#        "type": "boolean"
#      },
#      "show_correct_answers_at": {
#        "description": "when should the correct answers be visible by students? only valid if show_correct_answers=true",
#        "example": "2013-01-23T23:59:00-07:00",
#        "type": "datetime"
#      },
#      "hide_correct_answers_at": {
#        "description": "prevent the students from seeing correct answers after the specified date has passed. only valid if show_correct_answers=true",
#        "example": "2013-01-23T23:59:00-07:00",
#        "type": "datetime"
#      },
#      "one_time_results": {
#        "description": "prevent the students from seeing their results more than once (right after they submit the quiz)",
#        "example": true,
#        "type": "boolean"
#      },
#      "scoring_policy": {
#        "description": "which quiz score to keep (only if allowed_attempts != 1) possible values: 'keep_highest', 'keep_latest'",
#        "example": "keep_highest",
#        "type": "string",
#        "allowableValues": {
#          "values": [
#            "keep_highest",
#            "keep_latest"
#          ]
#        }
#      },
#      "allowed_attempts": {
#        "description": "how many times a student can take the quiz -1 = unlimited attempts",
#        "example": 3,
#        "type": "integer"
#      },
#      "one_question_at_a_time": {
#        "description": "show one question at a time?",
#        "example": false,
#        "type": "boolean"
#      },
#      "question_count": {
#        "description": "the number of questions in the quiz",
#        "example": 12,
#        "type": "integer"
#      },
#      "points_possible": {
#        "description": "The total point value given to the quiz",
#        "example": 20,
#        "type": "integer"
#      },
#      "cant_go_back": {
#        "description": "lock questions after answering? only valid if one_question_at_a_time=true",
#        "example": false,
#        "type": "boolean"
#      },
#      "access_code": {
#        "description": "access code to restrict quiz access",
#        "example": "2beornot2be",
#        "type": "string"
#      },
#      "ip_filter": {
#        "description": "IP address or range that quiz access is limited to",
#        "example": "123.123.123.123",
#        "type": "string"
#      },
#      "due_at": {
#        "description": "when the quiz is due",
#        "example": "2013-01-23T23:59:00-07:00",
#        "type": "datetime"
#      },
#      "lock_at": {
#        "description": "when to lock the quiz",
#        "type": "datetime"
#      },
#      "unlock_at": {
#        "description": "when to unlock the quiz",
#        "example": "2013-01-21T23:59:00-07:00",
#        "type": "datetime"
#      },
#      "published": {
#        "description": "whether the quiz has a published or unpublished draft state.",
#        "example": true,
#        "type": "boolean"
#      },
#      "unpublishable": {
#        "description": "Whether the assignment's 'published' state can be changed to false. Will be false if there are student submissions for the quiz.",
#        "example": true,
#        "type": "boolean"
#      },
#      "locked_for_user": {
#        "description": "Whether or not this is locked for the user.",
#        "example": false,
#        "type": "boolean"
#      },
#      "lock_info": {
#        "description": "(Optional) Information for the user about the lock. Present when locked_for_user is true.",
#        "$ref": "LockInfo"
#      },
#      "lock_explanation": {
#        "description": "(Optional) An explanation of why this is locked for the user. Present when locked_for_user is true.",
#        "example": "This quiz is locked until September 1 at 12:00am",
#        "type": "string"
#      },
#      "speedgrader_url": {
#        "description": "Link to Speed Grader for this quiz. Will not be present if quiz is unpublished",
#        "example": "http://canvas.instructure.com/courses/1/speed_grader?assignment_id=1",
#        "type": "string"
#      },
#      "quiz_extensions_url": {
#        "description": "Link to endpoint to send extensions for this quiz.",
#        "example": "http://canvas.instructure.com/courses/1/quizzes/2/quiz_extensions",
#        "type": "string"
#      },
#      "permissions": {
#        "$ref": "QuizPermissions",
#        "description": "Permissions the user has for the quiz"
#      },
#      "all_dates": {
#        "$ref": "AssignmentDate",
#        "description": "list of due dates for the quiz"
#      },
#      "version_number": {
#        "description": "Current version number of the quiz",
#        "example": 3,
#        "type": "integer"
#      },
#      "question_types": {
#        "description": "List of question types in the quiz",
#        "example": ["mutliple_choice", "essay"],
#        "type": "array"
#      }
#    }
#  }
#
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
#     },
#     "create": {
#       "description": "whether the user may create a new quiz",
#       "example": true,
#       "type": "boolean"
#     },
#     "manage": {
#       "description": "whether the user may edit, update, or delete the quiz",
#       "example": true,
#       "type": "boolean"
#     },
#     "read_statistics": {
#       "description": "whether the user may view quiz statistics for this quiz",
#       "example": true,
#       "type": "boolean"
#     },
#     "review_grades": {
#       "description": "whether the user may review grades for all quiz submissions for this quiz",
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
	# What's up?
	#
	# @returns {QuizPermissions}
	def permissions
	end

	# @API Get some student's shirts
	#
	# @returns {Shirts::Shirt}
	def shirts
	end
end