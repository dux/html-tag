require 'set'

class HtmlTagBuilder
  EMPTY_TAGS ||= Set.new %w(area base br col embed hr img input keygen link meta param source track wbr)

  class << self
    # tag.div -> tag.tag :div
    def method_missing name, *args, &block
      tag name, args[0], args[1], &block
    end

    # tag :div, { 'class'=>'iform' } do
    def tag name, *args
      data, opts =
      if args[1]
        args[0].class == Hash ? args.reverse : args
      elsif args[0]
        if args[0].class == Symbol
          # tag.div(:a) { 1 } -> <div class="a">1</div>
          [nil, { class: args[0].to_s.gsub('__', ' ').gsub('_', '-') }]
        elsif args[0].class == Hash
          [nil, args[0]]
        else
          [args[0], {}]
        end
      else
        [nil, {}]
      end

      opts ||= {}

      unless opts.class == Hash
        raise ArgumentError.new('HtmlTag: bad agrument, attriobutes are no a hash')
      end

      if data.class == Hash
        raise ArgumentError.new('HtmlTag: bad agrument, data sent as hash')
      end

      # covert n._row_foo to n(class: 'row-foo')
      name = name.to_s
      if name.to_s[0, 1] == '_'
        opts ||= {}
        opts[:class] = name.to_s.sub('_', '').gsub('_', '-')
        name = :div
      end

      if block_given?
        if data
          raise ArgumentError.new('HtmlTag: data is allreay defined and block is given')
        end

        stack = new
        data  = yield(stack, opts)

        # if data is pushed to passed node, use that data
        data = stack.data if stack.data.first
      end

      data = data.join('') if data.is_a?(Array)

      build name, opts, data
    end

    # build html node
    def build node, attrs={}, text=nil
      node = node.to_s

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

      if node
        text ||= '' unless EMPTY_TAGS.include?(node)
        text ? %{<#{node}#{opts}>#{text}</#{node}>} : %{<#{node}#{opts} />}
      else
        opts
      end
    end

    # tag.div(class: 'klasa') do -> tag.('klasa') do
    def call class_name, &block
      tag(:div, class_name, &block)
    end

    def __add_opts opts, key, value
      unless value.to_s == ''
        value = value.join(' ') if value.is_a?(Array)
        key   = key.to_s.gsub(/data_/,'data-')
        opts.push key+'="'+value.to_s.gsub(/"/,'&quot;')+'"'
      end
    end
  end

  ###

  attr_reader :data

  def initialize
    @data = []
  end

  # push data to stack
  def push data=nil
    @data.push block_given? ? yield : data
  end

  private

  # forward to class
  def method_missing tag_name, *args, &block
    @data.push self.class.tag(tag_name, args[0], args[1], &block)
  end
end
