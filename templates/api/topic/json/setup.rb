def init
  # sections :header, [:topic_doc, :method_details_list, [T('method_details')]]
  sections :method_details_list, [T('method_details')]
  @resource = object
  # @beta = options[:controllers].any? { |c| c.tag('beta') }
  puts "Topic: HEE? #{@resource}"
end

def method_details_list
  @meths = options[:controllers].map { |c| c.meths(:inherited => false, :included => false) }.flatten
  @meths = run_verifier(@meths)

  # puts "Methods: #{@meths}"

  buffer = [];

  @meths.each_with_index do |meth, i|
    # puts "#{i} => #{meth.tags}"
    buffer.push(yieldall :object => meth, :index => i)
  end

  puts "Buffer: #{buffer.to_json}"

  buffer.to_json
end
