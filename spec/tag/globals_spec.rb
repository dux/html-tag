require 'spec_helper'

describe HtmlTag do
  context String do
    it 'renders' do
      data = 'foo'.tag :a, b: :c
      expect(data).to eq('<a b="c">foo</a>')
    end
  end

  context Hash do
    it 'renders' do
      data = {b: :c}.tag(:a, 'foo')
      expect(data).to eq('<a b="c">foo</a>')
    end
  end
end
  