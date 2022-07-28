# Hash
unless {}.respond_to?(:tag)
  class Hash
    def tag node_name, inner_html=nil
      ::HtmlTag::Outbound.build node_name, self, inner_html
    end
  end
end

# String
unless ''.respond_to?(:tag)
  class String
    def tag node_name, opts={}
      ::HtmlTag::Outbound.build node_name, opts, self
    end
  end
end

# HtmlTag do ...
def HtmlTag *args, &block
  args[0] ||= :div

  if args[0].class == Hash
    args[1] = args[0]
    args[0] = :div
  end

  out = HtmlTag::Inbound.new self
  out.send(*args, &block)
  out.render
end
