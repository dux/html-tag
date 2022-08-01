require 'spec_helper'

describe HtmlTag do
  let!(:tag) { HtmlTag }

  describe 'Renders as expected' do
    context 'without a framework' do
      it 'renders tag without data' do
        expect(tag.div).to eq('<div></div>')
      end

      it 'renders tag with block data' do
        expect(tag.div { ' foo ' }).to eq('<div> foo </div>')
      end

      it 'render meta tag' do
        expect(tag.meta name: :foo, description: :bar).to eq(%[<meta name="foo" description="bar" />])
      end

      it 'renders tag with inline data and no params' do
        expect(tag.div('baz')).to eq('<div>baz</div>')
      end

      it 'renders tag with inline data and params' do
        expect(tag.div('baz', {foo: :bar})).to eq(%[<div foo="bar">baz</div>])
      end

      it 'renders tag with class shortcut' do
        expect(tag._foo).to eq(%[<div class="foo"></div>])
      end

      it 'renders tag with nested opts and shortcut' do
        expect(tag._miki(id: :foo, data: { bar: :baz })).to eq(%[<div id="foo" data-bar="baz" class="miki"></div>])
      end

      it 'renders underscore notation and joins array attributes' do
        expect(tag._foo__bar_baz(class: 'dux', data: { foo: 'bar baz' })).to eq(%[<div class="foo bar-baz dux" data-foo="bar baz"></div>])
      end

      it 'renders arary data' do
        expect(tag.div [tag.i, tag.u, tag.b]).to eq('<div><i></i><u></u><b></b></div>')
      end

      it 'renders tag with nested data' do
        data =
        tag._foo do |n|
          n.ul do |n|
            n.li do |n|
              n.a(href: '#') { 'baz' }
            end
            n.push 123
            n.push { 456 }
          end
        end

        expect(data).to eq(%[<div class="foo"><ul><li><a href="#">baz</a></li>123456</ul></div>])
      end

      it 'renders html in array' do
        data = tag._row [
          tag.div(id: :menu, class: :col) { 'menu' },
          tag._col { 'data' }
        ]

        expect(data).to eq(%[<div class="row"><div id="menu" class="col">menu</div><div class="col">data</div></div>])
      end

      it 'renders complex data' do
        buttons = []
        buttons.push ['Home', '/']
        buttons.push ['Links', '/links']

        data =
        tag.div do |n|
          buttons.each do |name, path|
            n.a name, class: 'btn', href: path
          end
        end

        expect(data).to eq(%[<div><a class="btn" href="/">Home</a><a class="btn" href="/links">Links</a></div>])
      end

      it 'fixes attr when needed' do
        expect({ 'data_foo'=>:bar}.tag(:div)).to eq(%[<div data-foo="bar"></div>])
        expect({ 'foo-bar'=>:bar}.tag :div).to eq(%[<div foo-bar="bar"></div>])
        expect({ 'foo_bar'=>:bar}.tag :div).to eq(%[<div foo_bar="bar"></div>])
      end

      it 'renders empty tags' do
        expect(tag.hr).to eq('<hr />')
      end

      it 'allowes opts and data to be send in any way' do
        expect(tag.div('foo', bar: :baz)).to eq(%[<div bar="baz">foo</div>])
        expect(tag.div({bar: :baz}, 'foo')).to eq(%[<div bar="baz">foo</div>])
      end
    end
  end
end

