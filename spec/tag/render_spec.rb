require 'spec_helper'

describe HtmlTagBuilder do
  let!(:tag) { HtmlTagBuilder }

  describe 'Renders as expected' do
    context 'in a framework (Rails, Lux)' do
      it 'is added to ApplicationHelper' do
        ApplicationHelper.send :extend, ApplicationHelper
        expect(ApplicationHelper.tag :div, :foo).to eq('<div>foo</div>')
      end
    end

    context 'without a framework' do
      it 'renders tag without data' do
        expect(tag.div).to eq('<div></div>')
      end

      it 'renders tag with block data' do
        expect(tag.div { 'foo' }).to eq('<div>foo</div>')
      end

      it 'renders tag with inline data and no params' do
        expect(tag.div('baz')).to eq('<div>baz</div>')
      end

      it 'renders tag with inline data and params' do
        expect(tag.div({foo: :bar}, 'baz')).to eq('<div foo="bar">baz</div>')
      end

      it 'renders tag with class shortcut' do
        expect(tag._foo).to eq('<div class="foo"></div>')
      end

      it 'renders tag with nested opts and shortcut' do
        expect(tag._miki(id: :foo, data: { bar: :baz })).to eq('<div id="foo" data-bar="baz" class="miki"></div>')
      end

      it 'renders underscore notation and joins array attributes' do
        expect(tag._foo_bar(data: { foo: %w(bar baz) })).to eq('<div data-foo="bar baz" class="foo-bar"></div>')
      end

      it 'renders arary data' do
        expect(tag.div [tag.i, tag.u, tag.b]).to eq('<div><i></i><u></u><b></b></div>')
      end

      it 'renders tag with nested data' do
        data =
        tag._foo do
          tag.ul do
            tag.li do
              tag.a(href: '#') { 'baz' }
            end
          end
        end

        expect(data).to eq('<div class="foo"><ul><li><a href="#">baz</a></li></ul></div>')
      end

      it 'renders html in array' do
        data = tag._row [
          tag.('#menu.col') { @menu },
          tag._col { @data }
        ]

        expect(data).to eq('<div class="row"><div id="menu" class="#menu col"></div><div class="col"></div></div>')
      end

      it 'renders complex data' do
        buttons = []
        buttons.push ['Home', '/']
        buttons.push ['Links', '/links']

        data =
        tag.div do |n|
          buttons.each do |name, path|
            n.a({class: 'btn', href: path }) { name }
          end
        end

        expect(data).to eq('<div><a class="btn" href="/">Home</a><a class="btn" href="/links">Links</a></div>')
      end
    end
  end
end

