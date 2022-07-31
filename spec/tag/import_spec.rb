require 'spec_helper'

###

module ModTest
  extend self

  HtmlTag self

  def render
    tag.ul do
      li 1
    end
  end
end

class Bar
  include HtmlTag
end

class Foo < Bar
  def data1
    tag.div 'foo'
  end

  def data2
    HtmlTag.div 'foo'
  end

  def data3
    tag.ul do
      li 1
    end
  end

  def data4
    tag.ul do |n|
      n.li 1
    end
  end
end

##

describe HtmlTag do
  describe 'Renders as expected' do
    context 'without a framework' do
      it 'imported tag' do
        expect(Foo.new.data1).to eq('<div>foo</div>')
      end

      it 'direct module call' do
        expect(Foo.new.data2).to eq('<div>foo</div>')
      end

      it 'metod missing not triggering on not direct calls' do
        expect { Foo.new.data_not_found }.to raise_error NoMethodError
      end

      it 'renders' do
        expect(Foo.new.data3).to eq("<ul><li>1</li></ul>")
      end

      it 'renders' do
        expect(Foo.new.data4).to eq("<ul><li>1</li></ul>")
      end

      it 'renders' do
        expect(ModTest.render).to eq("<ul><li>1</li></ul>")
      end
    end
  end
end
