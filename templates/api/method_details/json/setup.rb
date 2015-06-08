def init
  puts ">> method_details: #{object}"
  # sections :header, [:method_signature, T('docstring')]

  sections :main
end

def main
  {
    text: object.tag("API").try(:text)
  }
end
