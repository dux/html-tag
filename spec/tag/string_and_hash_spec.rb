require 'spec_helper'

describe HtmlTagBuilder do
  let!(:tag) { HtmlTagBuilder }

  describe 'Renders string tag as expected' do
    context String do
      it 'is renders tag' do
        node = 'foo'.tag(:bold)
        expect(node).to eq('<bold>foo</bold>')

        node = 'foo'.tag(:bold, class: :baz)
        expect(node).to eq('<bold class="baz">foo</bold>')
      end

      it 'encodes quotes' do
        node = 'foo'.tag(:bold, onclick: %[alert('"')])
        expect(node).to eq(%{<bold onclick="alert('&quot;')">foo</bold>})
      end
    end
  end

  describe 'Renders hash tag as expected' do
    context Hash do
      it 'is renders tag' do
        node = {class: :baz}.tag(:bold, 'foo')
        expect(node).to eq('<bold class="baz">foo</bold>')
      end
    end
  end
end

