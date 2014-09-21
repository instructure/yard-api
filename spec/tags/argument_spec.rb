require 'spec_helper'

describe YARD::APIPlugin::Tags::ArgumentTag do
  def populate(str=nil)
    YARD::Registry.clear
    YARD.parse_string str if str
  end

  def find_tag(method_name, tag_name, index=0)
    P(method_name.to_sym)
      .tags.select { |tag| tag.tag_name == tag_name.to_s }[index]
  end

  before do
    YARD::Registry.clear
  end

  it 'should work like an @attr tag' do
    populate <<-'eof'
      # @argument [String] name
      #   Your full name.
      def signup
      end
    eof

    tag = find_tag(:signup, :argument, 0)

    expect(tag.name).to eq 'name'
    expect(tag.text).to eq 'Your full name.'
    expect(tag.types).to eq ['String']
  end

  describe 'option: leading_argument_name_fix' do
    it 'should work with type and name specifiers swapped "@argument name [String]"' do
      set_option(:leading_argument_name_fix, true)

      populate <<-'eof'
        # @argument name [String]
        #   Your full name.
        #
        # @argument shirt_size [String, ["S", "M", "L"]]
        #   Size of the shirt you wear.
        #
        # @argument shirt[size] [String, ["S", "M", "L"]]
        #   Size of the shirt you wear.
        #
        def signup
        end
      eof

      find_tag(:signup, :argument, 0).tap do |tag|
        expect(tag.name).to eq 'name'
        expect(tag.text).to eq 'Your full name.'
        expect(tag.types).to eq ['String']
      end

      find_tag(:signup, :argument, 1).tap do |tag|
        expect(tag.name).to eq 'shirt_size'
        expect(tag.text).to eq 'Size of the shirt you wear.'
        expect(tag.types).to eq ['String']
        expect(tag.accepted_values).to eq %w[ S M L ]
      end

      find_tag(:signup, :argument, 2).tap do |tag|
        expect(tag.name).to eq 'shirt[size]'
        expect(tag.text).to eq 'Size of the shirt you wear.'
        expect(tag.types).to eq ['String']
        expect(tag.accepted_values).to eq %w[ S M L ]
      end
    end
  end

  describe '#is_required' do
    it 'should default to whatever Options.strict_arguments is set to' do
      set_option(:strict_arguments, false)

      populate <<-'eof'
        # @argument [String] name
        #   Your full name.
        #
        # @argument [Optional, Number] age
        #   How old you currently are.
        def signup
        end
      eof

      expect(find_tag(:signup, :argument, 0).is_required).to be false
      expect(find_tag(:signup, :argument, 1).is_required).to be false

      set_option(:strict_arguments, true)

      populate <<-'eof'
        # @argument [String] name
        #   Your full name.
        #
        # @argument [Optional, Number] age
        #   How old you currently are.
        def signup
        end
      eof

      expect(find_tag(:signup, :argument, 0).is_required).to be true
      expect(find_tag(:signup, :argument, 1).is_required).to be false
    end

    it 'should be true if Required is written in typestr' do
      set_option :strict_arguments, false

      populate <<-'eof'
        # @argument [Required, String] name
        #   Your full name.
        def signup
        end
      eof

      expect(find_tag(:signup, :argument).is_required).to be true
    end
  end

  describe '#accepted_values' do
    it 'should work in the type specifier: @argument [String, ["foo", "bar"]]' do
      populate <<-'eof'
        # @argument [Required, String, ["S","M","L","XL"]] size
        #   Your full name.
        def order_shirt
        end
      eof

      expect(find_tag(:order_shirt, :argument).accepted_values).to eq(%w[S M L XL])
    end

    it 'should work using "Accepted values: [...]"' do
      populate <<-'eof'
        # @argument [String] size
        #   Size of the t-shirt you want.
        #   Accepted values: ["S","M","L","XL"]
        def order_shirt
        end
      eof

      expect(find_tag(:order_shirt, :argument).accepted_values).to eq(%w[S M L XL])
    end

    it 'should work using "Accepts: [...]"' do
      populate <<-'eof'
        # @argument [String] size
        #   Size of the t-shirt you want.
        #   Accepts: ["S","M","L","XL"]
        def order_shirt
        end
      eof

      expect(find_tag(:order_shirt, :argument).accepted_values).to eq(%w[S M L XL])
    end

    it 'should work using "Possible values: [...]"' do
      populate <<-'eof'
        # @argument [String] size
        #   Size of the t-shirt you want.
        #   Possible values: ["S","M","L","XL"]
        def order_shirt
        end
      eof

      expect(find_tag(:order_shirt, :argument).accepted_values).to eq(%w[S M L XL])
    end
  end
end