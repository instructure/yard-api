module YARD::APIPlugin
	module Registry
		def self.root
			@root ||= begin
			  YARD::Registry.register YARD::CodeObjects::NamespaceObject.new(:root, :API)
			end
		end
	end
end
