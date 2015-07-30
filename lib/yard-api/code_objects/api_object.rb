require 'yard/code_objects/method_object'

module YARD::CodeObjects
	class APIObject < Base
		def self.sanitize_id(text)
			text.gsub(/\s/, '')
		end

		def path
			self.class.sanitize_id(super)
		end

		def title
			[ object.title, name ].join(NSEP)
		end
	end
end