module YARD::APIPlugin
  class Serializer < ::YARD::Serializers::FileSystemSerializer
    USNSEP = '__' # url-safe namespace separator
    FSSEP = '/'

    def self.topicize(str)
      self.str_underscore(str.lines.first.gsub(/\W+/, '_'))
    end

    # Stolen from rails 4.2, see:
    #
    # http://apidock.com/rails/v4.2.1/ActiveSupport/Inflector/underscore
    def self.str_underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    def serialize(object, data)
      path = File.join(basepath, serialized_path(object))
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

      fspath.gsub(/[^\w\.\-_\/]+/, '-')
    end

    def get_api_id(object)
      if object[:api_id]
        object.api_id
      elsif tag = object.tag(:API)
        tag.text.lines.first.strip
      else
        object.to_s
      end
    end
  end
end