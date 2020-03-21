module HtmlTagBuilderHelper
  # tag :div, { 'class'=>'iform' } do
  # tag.div(class: :iform) { |n| ... }
  def xtag name=nil, opts={}, data=nil
    return HtmlTagBuilder unless name
    data = yield(opts) if block_given?
    HtmlTagBuilder.tag name, opts, data
  end
end

# add to Rails, Sinatra or all other that respond to ApplicationHelper
if defined?(ActionView::Base)
  class ActionView::Base
    def tag *args, &block
      args.first ? HtmlTagBuilder.tag(*args, &block) : HtmlTagBuilder
    end
  end
elsif defined?(Sinatra::Base)
  class Sinatra::Base
    def tag *args, &block
      args.first ? HtmlTagBuilder.tag(*args, &block) : HtmlTagBuilder
    end
  end
elsif defined?(ApplicationHelper)
  module ApplicationHelper
    def tag *args, &block
      args.first ? HtmlTagBuilder.tag(*args, &block) : HtmlTagBuilder
    end
  end
end

# Hash
unless {}.respond_to?(:tag)
  class Hash
    def tag node_name=nil, inner_html=nil
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

