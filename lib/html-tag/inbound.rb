# improved HTML builder that doess not need node pointers

module HtmlTag
  class Inbound
    IVARS ||= Struct.new :HtmlTagInboundIvars, :context, :data, :depth

    TAGS ||= Set.new %i(
      a article b button code center colgroup dd div dl dt em fieldset form h1 h2 h3 h4 h5 h6
      header i iframe label legend li main map nav noscript object ol optgroup option p pre q
      script section select small span sub strong style summary table tbody td textarea tfoot th thead title tr u ul video
    )

    EMPTY_TAGS ||= Set.new %w(area base br col embed hr img input keygen link meta param source track wbr)

    # allows to add cusom tags if needed
    # HtmlTag::Inbound.define :foo
    def self.define name, empty: false
      if empty
        EMPTY_TAGS.add name
      end

      define_method name do |*args, &block|
        tag name, *args, &block
      end
    end

    # create static methods for all common tags (method missing is slow)
    (TAGS + EMPTY_TAGS).each {|tag| define tag }

    ###

    def initialize context = nil
      # copy all instance varialbes from context
      for el in context.instance_variables
        unless el.to_s.include?('@_')
          val = context.instance_variable_get el
          instance_variable_set el, val
        end
      end

      # lets keep all instance vars in one object
      @_iv = IVARS.new
      @_iv.context   = context
      @_iv.data      = []
      @_iv.depth     = 0
    end

    # access parent context via parent / context / this
    # h1 class: this.class_name
    def parent &block
      unless @_iv.context
        raise 'Host scope is not available'
      end

      if block
        @_iv.context.instance_exec(&block)
      else
        @_iv.context
      end
    end
    alias :context :parent
    alias :this :parent

    # export renderd data
    def render
      @_iv.data
        .join('')
        .gsub(/\n+/, $/)
        #.gsub(/([\w>])[[:blank:]]+</, '\1<')
    end

    # render single node
    def tag name, *args, &block
      name, opt_hash, opt_data = _prepare_tag_params name, args

      tag_data = "%s%s<%s" % [_depth_new_line, _depth_spaces, name]

      # if tag params given, add them
      if opt_hash
        tag_data += ' '
        tag_data += opt_hash.inject([]) do |t, el|
          key, value = el

          if value.class == Hash
            for el in value
              t.push '%s-%s=%s' % [key, el[0], _escape_param(el[1])]
            end
          else
            if value.class == Array
              value = value.join(' ')
            end

            key = key.to_s.sub(/^data_/, 'data-')

            t.push '%s=%s' % [key, _escape_param(value)]
          end
          t
        end.join(' ')
      end

      unless EMPTY_TAGS.include?(name)
        tag_data += '>'
      end

      @_iv.data << tag_data

      # nested blocks
      if block
        @_iv.depth += 1
        node_count = @_iv.data.length

        block_data = if @_iv.context
          # HtmlTag scope
          instance_exec(self, &block)
        else
          # outbound scope
          block.call(self)
        end

        if block_data.class == String && node_count == @_iv.data.length
          @_iv.data << block_data
        end

        @_iv.depth -= 1
      end

      if EMPTY_TAGS.include?(name)
        @_iv.data << ' />'
      else
        unless opt_data
          @_iv.data << _depth_spaces
        end

        if opt_data.class == Array
          opt_data = opt_data.join('')\
        end

        @_iv.data << '%s</%s>%s' % [opt_data, name, _depth_new_line]
      end
    end

    def push data = nil
      if block_given?
        data = yield
      end

      @_iv.data << data
    end

    def method_missing name, *args, &block
      klass = name.to_s

      if klass.start_with?('_')
        tag klass, *args, &block
      elsif @_iv.context
        @_iv.context.send name, *args, &block
      else
        message = [
          %{HTML tag "#{name}" not found.},
          "Use this.#{name}() to call method in parent context",
          "or use tag(:#{name}, params, data) to add custom html node."
        ]
        raise NoMethodError.new(message.join(' '))
      end
    end

    private

    def _prepare_tag_params name, args
      opt_hash, opt_data = args

      # allow any arragement of vars
      # div class: :foo, 123
      # div 123, class: :foo
      if opt_data.class == Hash || (opt_hash && opt_hash.class != Hash)
        opt_hash, opt_data = opt_data, opt_hash
      end

      # _foo__bar-baz class: 'dux' ->  <div class="foo bar-baz dux"></div>
      klass = name.to_s
      if klass.start_with?('_')
        classes = klass
          .sub('_', '')
          .split('__')
          .map{|it| it.gsub('_', '-') }
          .join(' ')

        klass = :div

        opt_hash ||= {}
        opt_hash[:class] = "#{classes} #{opt_hash[:class]}".sub(/\s+$/, '')
      end

      [klass, opt_hash, opt_data]
    end

    def _depth_spaces
      if OPTS[:format]
        ' ' * 2 * @_iv.depth
      else
        ''
      end
    end

    def _depth_new_line
      OPTS[:format] ? $/ : ''
    end

    def _escape_param el
      data = el.to_s

      if data.include?('"')
        # if we dump json export to a tag attribute, there will be a lot of qutes
        # it is much more readable to use quot(') insted of quote (") in this case
        "'%s'" % data.gsub(/'/, '&apos;')
      else
        # regualr node
        '"%s"' % data
      end
    end
  end
end
