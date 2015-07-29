require 'spec_helper'

module YARD
  module Serializers
    # A serializer that writes data to standard output.
    class SpecSerializer < Base
      # Creates a serializer to print text to stdout
      #
      # @param [Fixnum, nil] wrap if wrap is a number, wraps text to +wrap+
      #   columns, otherwise no wrapping is done.
      def initialize(buffer)
        @buffer = buffer
      end

      # Overrides serialize behaviour to write data to standard output
      def serialize(object, data)
        @buffer << data
      end
    end
  end
end

describe YARD::Templates::Engine.template(:api, :fulldoc) do
  before do
    Registry.clear
    set_option("output", "./tmp/doc")
  end

  describe '@object' do
    it 'should register it as a CodeObject inside the API namespace' do
      populate <<-'eof'
        # @API Quizzes
        #
        # @object Quiz
        #   {
        #     "id": "Quiz",
        #     "description": "A quiz that can be taken by students.",
        #     "properties": {
        #       "id": {
        #         "type": "String"
        #       }
        #     }
        #   }
        class QuizzesController < ApplicationController
        end
      eof

      YARD::Templates::Engine.render({
        objects: [ P('QuizzesController') ],
        type: :fulldoc,
        template: :api,
        format: :html
      })

      expect(Registry.all.map(&:path).sort).to eq(%w[
        API
        API::Quiz
        API::Quizzes
        API::Quizzes::Quiz
        QuizzesController
      ])

      expect(P('API::Quizzes::Quiz')).to be_truthy
      expect(P('API::Quizzes::Quiz').parent).to eq P('API::Quizzes')
    end
  end
end