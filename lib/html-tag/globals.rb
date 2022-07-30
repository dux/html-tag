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
    def initialize scope = nil
      @pointer = HtmlTag::Inbound.new scope
    end

    def method_missing name, *args, &block
      @pointer
        .send(name, *args, &block)
        .join('')
    end
  end
end

def HtmlTag *args, &block
  if args[0].class == Class
    # imports tag method without poluting ancesstors namespace
    # class SomeClass
    #   HtmlTag self
    args[0].define_method :tag do |*tag_args, &tag_block|
      HtmlTag *tag_args, &tag_block
    end
  else
    # HtmlTag do ...
    args[0] ||= :div

    if args[0].class == Hash
      args[1] = args[0]
      args[0] = :div
    end

    if block
      # HtmlTag(:ul) { li ... }
      out = HtmlTag::Inbound.new self
      out.send(*args, &block)
      out.render
    else
      # HtmlTag._foo 123
      HtmlTag::Proxy.new self
    end
  end
end
