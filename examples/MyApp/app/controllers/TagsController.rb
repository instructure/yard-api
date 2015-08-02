# @API Tags
#
# An example of all the tags supported by YARD-API.
class TagsController < ApplicationController
  # @API @argument
  #
  def argument
  end

  def beta
  end

  def example_request
  end

  def example_response
  end

  def internal
  end

  def no_content
  end

  # @API @note
  #
  # @note
  #  This is a note. You may or may not pay attention to it.
  #
  def note
  end

  def object
  end

  def request_field
  end

  def response_field
  end

  def returns
  end

  # @API @throws
  #
  # Example of the @throws tag.
  #
  # @throws [422]
  #   {
  #     "message": "Please. You are not being nice.",
  #     "reason": "Nice level is low."
  #   }
  #
  # @throws [422]
  #   {
  #     "message": "Please. You are being exceptionally not nice.",
  #     "reason": "Nice level is too low."
  #   }
  #
  # @throws [422]
  #   {
  #     "message": "Hm. You really are at it today.",
  #     "reason": "Nice level missing."
  #   }
  #
  def throws
  end

  # @API @warning
  #
  # @warning
  #  This is a warning message. You should be really careful after reading it.
  #
  def warning
  end
end
