require 'spec_helper'

###

class InboudRspec
  include HtmlTag

  def get_data1
    tag :ul, class: :foo do
      li 123
    end
  end
end

describe HtmlTag::Inbound do
  describe 'Renders as expected' do
    context 'via tag' do
      it 'renders' do
        data = InboudRspec.new.get_data1
        expect(data).to eq("\n<ul class=\"foo\">\n <li>123</li>\n</ul>\n")
      end
    end

    context 'inboud' do
      it 'inline tag' do
        data = HtmlTag { input name: :foo }
        expect(data).to include(%[<input name="foo" />])
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

      it 'outbound methods' do
        def foo
          123
        end

        data = HtmlTag { input num: this.foo }
        expect(data).to include(%[<input num="123" />])
      end
    end
  end
end
