# inclue HtmlTag to import tag method

require 'set'

module HtmlTag
  extend self

  ###

  OPTS = {
    format: false
  }

  TAGS ||= Set.new %i(
    a b button code colgroup dd div dl dt em fieldset form h1 h2 h3 h4 h5 h6
    header i iframe label legend li main map nav noscript object ol optgroup option p pre q
    script section select small span strong summary table tbody td textarea tfoot th thead title tr u ul video
  )

  EMPTY_TAGS ||= Set.new %w(area base br col embed hr img input keygen link meta param source track wbr)

  def tag *args, &block
    if block
      HtmlTag *args, &block
    else
      ::HtmlTag::Outbound
    end
  end

  # forward to class only if
  def method_missing tag_name, *args, &block
    if self === HtmlTag
      Outbound.tag(tag_name, args[0], args[1], &block)
    else
      super
    end
  end
end
