# Hash
unless {}.respond_to?(:tag)
  class Hash
    def tag node_name, inner_html=nil
      HtmlTag().send node_name, self, inner_html
    end
  end
end

# String
unless ''.respond_to?(:tag)
  class String
    def tag node_name, opts = nil
      HtmlTag().send node_name, self, opts
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
    HtmlTag::Proxy.new
  end
end
