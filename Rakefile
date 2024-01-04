require 'benchmark'
require 'nokogiri'
require './lib/html-tag'

def ng_tag &block
  builder = Nokogiri::XML::DocumentFragment.parse("")
  Nokogiri::XML::Builder.with( builder, &block )
  builder.to_html
end

def measure name
  out = nil
  puts name
  puts Benchmark.measure {
    10_000.times do
      out = yield
    end
  }
  puts out
  puts
end

###

desc 'Speed test (x10_000)'
task :speed do
  measure 'Nokogiri::XML::Builder' do
    ng_tag do |doc|
      doc.div do
        doc.send('foo-bar') { doc.text 123 }
        doc.div.foo(onload: 'some_func();') do
          doc.span.bold do
            doc.text "Hello world"
          end
        end
      end
    end
  end

  measure 'HtmlTag slim' do
    HtmlTag :div do
      tag('foo-bar', 123)
      _foo(onload: 'some_func();') do
        span(class: :bold) { "Hello world" }
      end
    end
  end

  measure 'HtmlTag safe' do
    HtmlTag.div do |n|
      n.tag('foo-bar', 123)
      n._foo(onload: 'some_func();') do |n|
        n.span(class: :bold) { "Hello world" }
      end
    end
  end
end