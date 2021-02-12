# Hash
unless {}.respond_to?(:tag)
  class Hash
    def tag node_name, inner_html=nil
      HtmlTagBuilder.build self, node_name, inner_html
    end
  end
end

# String
unless ''.respond_to?(:tag)
  class String
    def tag node_name, opts={}
      HtmlTagBuilder.build opts, node_name, self
    end
  end
end

# All other objects
class Object
  def tag *args, &block
    args.first ? HtmlTagBuilder.tag(*args, &block) : HtmlTagBuilder
  end
end