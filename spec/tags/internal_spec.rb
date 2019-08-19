require 'spec_helper'

describe YARD::Templates::Engine.template(:api, :fulldoc) do
  before(:each) do
    YARD::Registry.clear
  end

  after(:each) do
    YARD::Registry.clear
  end

  before(:each) do
    populate <<-'eof'
      # @API Quizzes
      # @internal
      class QuizzesController < ApplicationController
      end
    eof
  end

  let(:serializer) { YARD::Serializers::SpecSerializer.new([]) }
  let(:verifier) { YARD::APIPlugin::Verifier.new }

  it 'should hide entities marked with @internal' do
    entities = YARD::Registry.all

    YARD::Templates::Engine.render({
      objects: entities,
      type: :fulldoc,
      template: :api,
      format: :json,
      serializer: serializer
    })

    expect(entities.size).to be > 0
    expect(verifier.run(entities).size).to be == 0
  end

  context 'when the "include_internal" option is turned on...' do
    before(:each) do
      set_option(:include_internal, true)
    end

    it 'should not hide entities marked with @internal' do
      populate <<-'eof'
        # @API Quizzes
        # @internal
        class QuizzesController < ApplicationController
        end
      eof

      entities = YARD::Registry.all

      YARD::Templates::Engine.render({
        objects: entities,
        type: :fulldoc,
        template: :api,
        format: :json,
        serializer: serializer
      })

      expect(entities.size).to be > 0
      expect(verifier.run(entities).size).to eq(entities.size)
    end
  end
end