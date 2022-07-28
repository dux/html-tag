# improved builder that is not pasing node pointers

# HtmlTag do
#   form do
#     input name: q
#   end
# end

module HtmlTag
  class Inbound
    IVARS ||= Struct.new :HtmlTagInboundIvars, :context, :data, :depth, :inbound

    # allows to add cusom tags if needed
    # HtmlTag::Inbound.define :foo
    def self.define tag, empty: false
      if empty
        EMPTY_TAGS.add tag
      end

      define_method tag do |*args, &block|
        node tag, *args, &block
      end
    end

    # create static methods for all common tags (method missing is slow)
    (TAGS + EMPTY_TAGS).each {|tag| define tag }

    ###

    def initialize context
      # copy all instance varialbes from context
      for el in context.instance_variables
        unless el.to_s.include?('@_')
          val = context.instance_variable_get el
          instance_variable_set el, val
        end
      end

      # lets keep all instance vars in one object
      @_iv = IVARS.new
      @_iv.context = context
      @_iv.data    = []
      @_iv.depth   = 0
      @_iv.inbound = true
    end

    # access parent context via parent / context / this
    # h1 class: this.class_name
    def parent &block
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
        .gsub(/([\w>])[[:blank:]]+</, '\1<')
    end

    # render single node
    def node name, *args, &block
      opt_hash, opt_data = args

      # allow any arragement of vars
      # div class: :foo, 123
      # div 123, class: :foo
      if opt_hash && opt_hash.class != Hash
        opt_hash, opt_data = opt_data, opt_hash
      end

      tag = "\n%s<%s" % [' ' * @_iv.depth, name]

      # if opts given, add them
      if opt_hash
        tag += ' '
        tag += opt_hash.inject([]) do |t, el|
          if el[1].class == Array
            el[1] = el[1].join(' ')
          end

          t.push '%s="%s"' % [el[0], el[1].to_s.gsub(/"/, '&quot;')]
          t
        end.join(' ')
      end

      unless EMPTY_TAGS.include?(name)
        tag += '>'
      end

      @_iv.data << tag

      # nested blocks
      if block
        @_iv.depth += 1
        instance_exec(@_iv.context, &block)
        # block.call(self) # for outbound render
        @_iv.depth -= 1
      end

      if EMPTY_TAGS.include?(name)
        @_iv.data << ' />'
      else
        unless opt_data
          @_iv.data << ' ' * @_iv.depth
        end

        @_iv.data << "%s</%s>\n" % [opt_data, name]
      end
    end

    def push data
      @_iv.data << data
    end

    def method_missing name, *args, &block
      message = [
        %{HTML node "#{name}" not found.},
        "Use this.#{name}() to call node in parent context",
        "or use node(:#{name}, params, data) to add custom html node."
      ]
      raise NoMethodError.new(message.join(' '))
    end
  end
end
