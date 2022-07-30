# inclue HtmlTag to import tag method

require 'set'

module HtmlTag
  extend self

  ###

  OPTS = {
    format: false
  }

  def tag *args, &block
    HtmlTag *args, &block
  end

  # forward to class only if
  def method_missing tag_name, *args, &block
    if self === HtmlTag
      # Outbound.tag(tag_name, args[0], args[1], &block)
      Proxy.new.tag(tag_name, args[0], args[1], &block)
    else
      super
    end
  end
end
