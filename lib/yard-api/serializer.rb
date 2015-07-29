module YARD::APIPlugin
	class Serializer < ::YARD::Serializers::FileSystemSerializer
		USNSEP = '__' # url-safe namespace separator
		FSSEP = '/'

	  def self.topicize(str)
	    str.lines.first.gsub(/\W+/, '_').downcase
	  end

    def serialize(object, data)
      path = File.join(basepath, serialized_path(object))

      if path.include?(' ')
      	debugger
      end

      log.debug "Serializing to #{path}"
      File.open!(path, "wb") {|f| f.write data }
    end

    def serialized_path(object)
      return object if object.is_a?(String)

      fspath = nil

      if object.is_a?(YARD::CodeObjects::ExtraFileObject)
        fspath = 'file.' + object.name + (extension.empty? ? '' : ".#{extension}")
      else
        fspath = if object == YARD::Registry.root
        	"top-level-namespace"
        else
        	self.class.topicize(get_api_id(object))
        end

        if object.is_a?(YARD::CodeObjects::MethodObject)
        	fspath += '_' + object.scope.to_s[0,1]
        end

        unless extension.empty?
      		fspath += ".#{extension}"
      	end
      end

      if (fspath.include?(' '))
      	debugger
      end

      fspath.gsub(/[^\w\.\-_\/]+/, '-')
    end

		def get_api_id(object)
			if object[:api_id]
				object.api_id
			elsif tag = object.tag(:API)
				tag.text.lines.first.strip
			else
				object.name.to_s
			end
		end
	end
end