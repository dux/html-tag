require 'spec_helper'

###

class Bar
  prepend HtmlTag
  
  def tag
    'error'
  end
end

class Foo < Bar
  def data1
    tag.div 'foo'
  end

  def data2
    HtmlTag.div 'foo'
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
        expect { Foo.new.data3 }.to raise_error NoMethodError
      end
    end
  end
end
