module HtmlTagBuilderHelper
  # tag :div, { 'class'=>'iform' } do
  # tag.div(class: :iform) { |n| ... }
  def xtag name=nil, opts={}, data=nil
    return HtmlTagBuilder unless name
    data = yield(opts) if block_given?
    HtmlTagBuilder.tag name, opts, data
  end
end

# Rails
if defined?(ActionView::Base)
  ActionView::Base.send :include, HtmlTagBuilderHelper

# Sinatra
elsif defined?(Sinatra::Base)
  class Sinatra::Base
    include HtmlTagBuilderHelper
    alias :tag :xtag
  end

# Lux and other
elsif defined?(ApplicationHelper)
  # all other frameworks, including Lux
  module ApplicationHelper
    include HtmlTagBuilderHelper
    alias :tag :xtag
  end

end



