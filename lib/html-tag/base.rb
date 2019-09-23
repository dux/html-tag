class HtmlTagBuilder
  class << self
    # tag.div -> tag.tag :div
    def method_missing tag_name, *args, &block
      tag tag_name, args[0], args[1], &block
    end

    # tag :div, { 'class'=>'iform' } do
    def tag name=nil, opts={}, data=nil
      if Array === opts
        # join data given as an array
        data = opts
        opts = {}
      elsif Hash === data
        # tag.button('btn', href: '/') { 'Foo' }
        opts = data.merge class: opts
        data = nil
      end

      # covert n._row to n(class: 'row')
      name = name.to_s
      if name.to_s[0, 1] == '_'
        opts ||= {}
        opts[:class] = name.to_s.sub('_', '')
        name = :div
      end

      # covert tag.a '.foo.bar' to class names
      # covert tag.a '#id' to id names
      if (data || block_given?) && opts.is_a?(String)
        given = opts.dup
        opts  = {}

        given.sub(/#([\w\-]+)/) { opts[:id] = $1 }
        klass = given.sub(/^\./, '').gsub('.', ' ')
        opts[:class] = klass unless klass.blank?
      end

      # fix data and opts unless opts is Hash
      data, opts = opts, {} unless opts.class == Hash

      if block_given?
        inline = new
        data = yield(inline, opts)

        # if data is pushed to passed node, use that data
        data = inline.data if inline.data.first
      end

      data = data.join('') if data.is_a?(Array)

      build opts, name, data
    end

    # build html node
    def build attrs, node=nil, text=nil
      opts = []
      attrs.each do |attr_key, attr_value|
        if attr_value.is_a?(Hash)
          for data_key, data_value in attr_value
            __add_opts opts, "#{attr_key}-#{data_key}", data_value
          end
        else
          __add_opts opts, attr_key, attr_value
        end
      end

      opts = opts.first ? ' '+opts.join(' ') : ''

      return opts unless node

      text = yield opts if block_given?
      text ||= '' unless ['input', 'img', 'meta', 'link', 'hr', 'br'].include?(node.to_s)
      out = text ? %{<#{node}#{opts}>#{text}</#{node}>} : %{<#{node}#{opts} />}
      out.respond_to?(:html_safe) ? out.html_safe : out
    end

    # tag.div(class: 'klasa') do -> tag.('klasa') do
    def call class_name, &block
      tag(:div, class_name, &block)
    end

    def __add_opts opts, key, value
      unless value.to_s.blank?
        opts.push key.to_s.gsub(/_/,'-')+'="'+value.to_s.gsub(/"/,'&quot;')+'"'
      end
    end

  end

  ###

  attr_reader :data

  def initialize
    @data = []
  end

  # push data to stack
  def push data
    @data.push data
  end

  # n.div(class: 'klasa') do -> n.('klasa') do
  def call class_name, &block
    @data.push self.class.tag(:div, { class: class_name }, &block)
  end

  # forward to class
  def method_missing tag_name, *args, &block
    @data.push self.class.tag(tag_name, args[0], args[1], &block)
  end
end