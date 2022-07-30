require 'spec_helper'

###

class InboudRspec
  include HtmlTag

  def numbers
    1234
  end

  def get_data1
    tag :ul, class: :foo do
      li 123
    end
  end

  def get_data2
    tag.ul do |n|
      n.li numbers
    end
  end
end

describe HtmlTag::Inbound do
  context 'via tag' do
    it 'renders' do
      data = InboudRspec.new.get_data1
      expect(data).to eq("<ul class='foo'><li>123</li></ul>")
    end
  end

  context 'inboud' do
    it 'inline tag' do
      data = HtmlTag { input name: :foo }
      expect(data).to include(%[<input name='foo' />])
    end

    it 'outbound data' do
      @list = %w(foo bar baz)

      data = HtmlTag do
        ul do
          @list.each do |el|
            li el
          end
        end
      end

      expect(data).to include('<li>baz</li>')
    end

    it 'outbound method not found' do
      expect do
        HtmlTag { input num: foo }
      end.to raise_error(NoMethodError)
    end

    it 'calls outbound methods' do
      def foo
        123
      end

      data = HtmlTag { input 456, num: this.foo }
      expect(data).to include(%[<input num='123' />])
    end

    it 'renders class names with shorthand' do
      data = HtmlTag { _foo__bar_baz 123, class: 'dux' }
      expect(data).to include(%[<div class='foo bar-baz dux'>123</div>])
    end

    it 'renders depth' do
      expect(InboudRspec.new.get_data1).to eq("<ul class='foo'><li>123</li></ul>")
      HtmlTag::OPTS[:format] = true
      expect(InboudRspec.new.get_data1).to eq("\n<ul class='foo'>\n  <li>123</li>\n</ul>\n")
      HtmlTag::OPTS[:format] = false
    end

    it 'renders data opts' do
      data = HtmlTag { _foo 456, data: {foo: :bar} }
      expect(data).to include(%[<div data-foo='bar' class='foo'>456</div>])
    end

    it 'allows manual tag call' do
      data = HtmlTag do
        tag(:foo, bar: :baz) do
          'dux'
        end
      end

      expect(data).to eq("<div><foo bar='baz'>dux</foo></div>")
    end
  end

  context 'outbound' do
    it 'renders with scope' do
      def ofoo
        12
      end

      data = HtmlTag().ul do |n|
        n.li ofoo
        n.li {|n| n.push(34) }
      end

      expect(data).to eq('<ul><li>12</li><li>34</li></ul>')
    end

    it 'renders without scope' do
      def ofoo
        12
      end

      data = HtmlTag.ul {|n| n.li ofoo }
      expect(data).to eq('<ul><li>12</li></ul>')
    end

    it 'raises NoMethodError error' do
      data = proc { HtmlTag().ul {|n| n.li ofoo2 } }
      expect(data).to raise_error NoMethodError
    end

    it 'raises NoMethodError error' do
      data = proc { HtmlTag.ul {|n| n.li ofoo2 } }
      expect(data).to raise_error NameError
    end
  end
end
