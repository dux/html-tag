require 'spec_helper'
require 'json'

describe HtmlTag do
  let!(:tag) { HtmlTag }

  describe 'Renders string tag as expected' do
    context String do
      it 'is renders tag' do
        node = 'foo'.tag(:strong)
        expect(node).to eq('<strong>foo</strong>')

        node = 'foo'.tag(:strong, class: :baz)
        expect(node).to eq(%[<strong class="baz">foo</strong>])
      end

      it 'encodes quotes' do
        node = 'foo'.tag(:strong, onclick: %[alert('"')])
        expect(node).to eq("<strong onclick='alert(&apos;\"&apos;)'>foo</strong>")
      end

      it 'can dump json in attribute' do
        json = {
          a: 123,
          b: "a\nb'\nc"
        }

        node = {foo: json.to_json}.tag(:i)

        expect(node).to eq(%[<i foo='{"a":123,"b":"a\\nb&apos;\\nc"}'></i>])
      end
    end
  end

  describe 'Renders hash tag as expected' do
    context Hash do
      it 'is renders tag' do
        node = {class: :baz}.tag(:strong, 'foo')
        expect(node).to eq(%[<strong class="baz">foo</strong>])
      end
    end
  end
end

