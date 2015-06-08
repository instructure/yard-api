def init
  sections :main
end

def main
  {
    text: object.tag("API").try(:text)
  }
end
