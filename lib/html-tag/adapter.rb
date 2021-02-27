# Hash
unless {}.respond_to?(:tag)
  class Hash
    def tag node_name, inner_html=nil
      ::HtmlTagBuilder.build node_name, self, inner_html
    end
  end
end

# String
unless ''.respond_to?(:tag)
  class String
    def tag node_name, opts={}
      ::HtmlTagBuilder.build node_name, opts, self
    end
  end
end
