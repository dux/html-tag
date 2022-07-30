# Hash
unless {}.respond_to?(:tag)
  class Hash
    def tag node_name, inner_html=nil, &block
      HtmlTag::Inbound.new.tag(node_name, inner_html, self, &block).join('')
    end
  end
end

# String
unless ''.respond_to?(:tag)
  class String
    def tag node_name, opts = nil, &block
      HtmlTag::Inbound.new.tag(node_name, self, opts, &block).join('')
    end
  end
end

# HtmlTag do ...
module HtmlTag
  class Proxy
    def initialize
      @pointer = HtmlTag::Inbound.new
    end

    def method_missing name, *args, &block
      @pointer
        .send(name, *args, &block)
        .join('')
    end
  end
end

def HtmlTag *args, &block
  args[0] ||= :div

  if args[0].class == Hash
    args[1] = args[0]
    args[0] = :div
  end

  if block
    out = HtmlTag::Inbound.new self
    out.send(*args, &block)
    out.render
  else
    # HtmlTag._foo 123
    HtmlTag::Proxy.new
  end
end
