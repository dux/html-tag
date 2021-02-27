# inclue HtmlTag to import tag method

module HtmlTag
  extend self

  def tag
    ::HtmlTagBuilder
  end

  # forward to class only if
  def method_missing tag_name, *args, &block
    if self === HtmlTag
      ::HtmlTagBuilder.tag(tag_name, args[0], args[1], &block)
    else
      super
    end
  end
end