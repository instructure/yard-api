#
# Copyright (C) 2011 - 2014 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

# @API Accounts
#
# API for accessing account data.
#
# @model Account
#     {
#       "id": "Account",
#       "description": "",
#       "properties": {
#         "id": {
#           "description": "the ID of the Account object",
#           "example": 2,
#           "type": "integer"
#         },
#         "name": {
#           "description": "The display name of the account",
#           "example": "Canvas Account",
#           "type": "string"
#         },
#         "parent_account_id": {
#           "description": "The account's parent ID, or null if this is the root account",
#           "example": 1,
#           "type": "integer"
#         },
#         "root_account_id": {
#           "description": "The ID of the root account, or null if this is the root account",
#           "example": 1,
#           "type": "integer"
#         },
#         "default_storage_quota_mb": {
#           "description": "The storage quota for the account in megabytes, if not otherwise specified",
#           "example": 500,
#           "type": "integer"
#         },
#         "default_user_storage_quota_mb": {
#           "description": "The storage quota for a user in the account in megabytes, if not otherwise specified",
#           "example": 50,
#           "type": "integer"
#         },
#         "default_group_storage_quota_mb": {
#           "description": "The storage quota for a group in the account in megabytes, if not otherwise specified",
#           "example": 50,
#           "type": "integer"
#         },
#         "default_time_zone": {
#           "description": "The default time zone of the account. Allowed time zones are {http://www.iana.org/time-zones IANA time zones} or friendlier {http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html Ruby on Rails time zones}.",
#           "example": "America/Denver",
#           "type": "string"
#         },
#         "sis_account_id": {
#           "description": "The account's identifier in the Student Information System. Only included if the user has permission to view SIS information.",
#           "example": "123xyz",
#           "type": "string"
#         },
#         "integration_id": {
#           "description": "The account's identifier in the Student Information System. Only included if the user has permission to view SIS information.",
#           "example": "123xyz",
#           "type": "string"
#         },
#         "sis_import_id": {
#           "description": "The id of the SIS import if created through SIS. Only included if the user has permission to manage SIS information.",
#           "example": "12",
#           "type": "integer"
#         },
#         "lti_guid": {
#           "description": "The account's identifier that is sent as context_id in LTI launches.",
#           "example": "123xyz",
#           "type": "string"
#         },
#         "workflow_state": {
#           "description": "The state of the account. Can be 'active' or 'deleted'.",
#           "example": "active",
#           "type": "string"
#         }
#       }
#     }
#
class AccountsController < ApplicationController
  # @API List accounts
  # List accounts that the current user can view or manage.  Typically,
  # students and even teachers will get an empty list in response, only
  # account admins can view the accounts that they are in.
  #
  # @argument include[] [String, ["lti_guid"|"registration_settings"]]
  #   Array of additional information to include.
  #
  #   "lti_guid":: the 'tool_consumer_instance_guid' that will be sent for this account on LTI launches
  #   "registration_settings":: returns info about the privacy policy and terms of use
  #
  # @returns [Account]
  def index
  end

  # @API List accounts for course admins
  # List accounts that the current user can view through their admin course enrollments.
  # (Teacher, TA, or designer enrollments).
  # Only returns "id", "name", "workflow_state", "root_account_id" and "parent_account_id"
  #
  # @returns [Account]
  def course_accounts
  end

  # @API Get a single account
  # Retrieve information on an individual account, given by id or sis
  # sis_account_id.
  #
  # @returns Account
  def show
  end

  # @API Get the sub-accounts of an account
  #
  # List accounts that are sub-accounts of the given account.
  #
  # @argument recursive [Boolean] If true, the entire account tree underneath
  #   this account will be returned (though still paginated). If false, only
  #   direct sub-accounts of this account will be returned. Defaults to false.
  #
  # @example_request
  #     curl https://<canvas>/api/v1/accounts/<account_id>/sub_accounts \
  #          -H 'Authorization: Bearer <token>'
  #
  # @returns [Account]
  def sub_accounts
  end

  # @API List active courses in an account
  # Retrieve the list of courses in this account.
  #
  # @argument with_enrollments [Boolean]
  #   If true, include only courses with at least one enrollment.  If false,
  #   include only courses with no enrollments.  If not present, do not filter
  #   on course enrollment status.
  #
  # @argument published [Boolean]
  #   If true, include only published courses.  If false, exclude published
  #   courses.  If not present, do not filter on published status.
  #
  # @argument completed [Boolean]
  #   If true, include only completed courses (these may be in state
  #   'completed', or their enrollment term may have ended).  If false, exclude
  #   completed courses.  If not present, do not filter on completed status.
  #
  # @argument by_teachers[] [Integer]
  #   List of User IDs of teachers; if supplied, include only courses taught by
  #   one of the referenced users.
  #
  # @argument by_subaccounts[] [Integer]
  #   List of Account IDs; if supplied, include only courses associated with one
  #   of the referenced subaccounts.
  #
  # @argument hide_enrollmentless_courses [Boolean]
  #   If present, only return courses that have at least one enrollment.
  #   Equivalent to 'with_enrollments=true'; retained for compatibility.
  #
  # @argument state[] [String, ["created","claimed","available","completed","deleted","all"]]
  #   If set, only return courses that are in the given state(s). By default,
  #   all states but "deleted" are returned.
  #
  # @argument enrollment_term_id [Integer]
  #   If set, only includes courses from the specified term.
  #
  # @argument search_term [String]
  #   The partial course name, code, or full ID to match and return in the results list. Must be at least 3 characters.
  #
  # @argument include[] [String, ["needs_grading_count"|"syllabus_body"|"total_scores"|"term"|"course_progress"|"sections"|"storage_quota_used_mb"]]
  #   - All explanations can be seen in the {api:CoursesController#index Course API index documentation}
  #
  # @returns [Course]
  def courses_api
  end

  # Delegated to by the update action (when the request is an api_request?)
  def update_api
  end

  # @API Update an account
  # Update an existing account.
  #
  # @argument account[name] [String]
  #   Updates the account name
  #
  # @argument account[default_time_zone] [String]
  #   The default time zone of the account. Allowed time zones are
  #   {http://www.iana.org/time-zones IANA time zones} or friendlier
  #   {http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html Ruby on Rails time zones}.
  #
  # @argument account[default_storage_quota_mb] [Integer]
  #   The default course storage quota to be used, if not otherwise specified.
  #
  # @argument account[default_user_storage_quota_mb] [Integer]
  #   The default user storage quota to be used, if not otherwise specified.
  #
  # @argument account[default_group_storage_quota_mb] [Integer]
  #   The default group storage quota to be used, if not otherwise specified.
  #
  # @argument account[settings][restrict_student_past_view] [Boolean]
  #   Restrict students from viewing courses after end date
  #
  # @argument account[settings][restrict_student_future_view] [Boolean]
  #   Restrict students from viewing courses before start date
  #
  # @example_request
  #   curl https://<canvas>/api/v1/accounts/<account_id> \
  #     -X PUT \
  #     -H 'Authorization: Bearer <token>' \
  #     -d 'account[name]=New account name' \
  #     -d 'account[default_time_zone]=Mountain Time (US & Canada)' \
  #     -d 'account[default_storage_quota_mb]=450'
  #
  # @returns Account
  def update
  end

  def settings
  end

  # @API Delete a user from the root account
  #
  # Delete a user record from a Canvas root account. If a user is associated
  # with multiple root accounts (in a multi-tenant instance of Canvas), this
  # action will NOT remove them from the other accounts.
  #
  # WARNING: This API will allow a user to remove themselves from the account.
  # If they do this, they won't be able to make API calls or log into Canvas at
  # that account.
  #
  # @example_request
  #     curl https://<canvas>/api/v1/accounts/3/users/5 \
  #       -H 'Authorization: Bearer <ACCESS_TOKEN>' \
  #       -X DELETE
  #
  # @returns User
  def remove_user
  end
end
