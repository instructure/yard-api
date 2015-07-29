require 'yard/code_objects/class_object'

module YARD::CodeObjects
	class APIObject < Base
		def path
			super().gsub(/\s/, '')
		end

		def title
			[ object.title, name ].join('::')
		end
	end

	class ClassObject < NamespaceObject
		def title
			self[:api_id] || super
		end
	end
end