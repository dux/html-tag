# improved builder that is not pasing node pointers

# HtmlTag do
#   form do
#     input name: q
#   end
# end

module HtmlTag
  class Inbound
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
        unless el.to_s.include?('@_tag_')
          val = context.instance_variable_get el
          instance_variable_set el, val
        end
      end

      @_tag_context = context
      @_tag_data    = []
      @_tag_depth   = 0
    end

    # access parent context via parent / context / this
    # h1 class: this.class_name
    def parent &block
      if block
        @_tag_context.instance_exec(&block)
      else
        @_tag_context
      end
    end
    alias :context :parent
    alias :this :parent

    # export renderd data
    def render
      @_tag_data
        .join('')
        .gsub(/\n+/, $/)
        .gsub(/([\w>])[[:blank:]]+</, '\1<')
    end

    # render single node
    def node name, *args, &block
      opt_hash, opt_data = args

      if opt_hash && opt_hash.class != Hash
        opt_hash, opt_data = opt_data, opt_hash
      end

      tag = "\n%s<%s" % [' ' * @_tag_depth, name]

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

      @_tag_data << tag

      if block
        @_tag_depth += 1
        instance_exec(&block)
        @_tag_depth -= 1
      end

      if EMPTY_TAGS.include?(name)
        @_tag_data << ' />'
      else
        unless opt_data
          @_tag_data << ' ' * @_tag_depth
        end

        @_tag_data << "%s</%s>\n" % [opt_data, name]
      end
    end

    def push data
      @_tag_data << data
    end

    def method_missing name, *args, &block
      raise NoMethodError.new(%[HTML node "#{name}" not found. Use this.#{name}() to call node in parent context or use node(:#{name}, params, data) to add custom html node.])
    end
  end
end
