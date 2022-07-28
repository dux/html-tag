# HTML Tag builder

HTML tag builder "on steroids"

https://github.com/dux/html-tag

## Install

### Gemfile

`gem 'html-tag'`

### Manual require

`require 'html-tag'`

## Usage

Example

```ruby
# You can use it in 2 ways

# without node pointer
# - invoked when calling class as a method
# - block is run in context of HtmlTag class instance
# - use "this" prefix to access methods in parent context
# - instance variables are accessible
HtmlTag :ul do
  li do
    a href: '#', class: this.klass_name
  end

  @list.each_with_index do |el, i|
    li el, num: i
  end
end

# with node pointers
# - more efficient but not so readable
# - block is run in context of caller
HtmlTag.ul do |n|
  n.li do |n|
    n.a href: '#', class: klass_names
  end

  @list.each_with_index do |el, i|
    n.li el, num: i
  end
end

# imports tag method
# then use "tag" or "HtmlTag" without import
= tag.ul do |n|                # <ul>
  1.upto(3) do |num|           #
    n.li do |n|                #   <li>
      n.i 'arrow'              #     <i class="arrow"></i>
      n._arrow                 #     <div class="arrow"></div>
      n.span 123               #     <span>123</span>
      n.span { 123 }           #     <span>123</span>
      n._foo                   #     <div class="foo"></div>
      n._foo(bar: baz) { 123 } #     <div class="foo" bar="baz">123</div>
      n.i(foo: [:bar, :baz])   #     <i foo="bar baz"></i>
    end                        #   </li>
  end                          #
end                            # </ul>
```

### More examples

#### Tag without data
```ruby
= tag.div
```

```html
<div></div>
```

#### Empty tags
```ruby
= tag.hr
= tag.meta name: :foo, description: :bar
```

```html
<div></div>
<meta name="foo" description="bar" />
```

#### Tag with block data
```ruby
= tag.div { 'foo' }
```

```html
<div>foo</div>
```

#### Tag with inline data and no params
```ruby
= tag.div('baz')
```

```html
<div>baz</div>
```

#### Tag with inline data and params
```ruby
= tag.div('baz', {foo: :bar})
```

```html
<div foo="bar">baz</div>
```

#### Tag with class shortcut
```ruby
= tag._foo
= HtmlTag.i(:foo) { 'baz' } 
```

```html
<div class="foo"></div>
<i class="foo">baz</i>
```

#### Tag with nested opts and shortcut

```ruby
= tag._miki(id: :foo, data: { bar: :baz })
```

```html
<div id="foo" data-bar="baz" class="miki"></div>
```

#### Tag with underscore notation and array attributes

```ruby
= tag._foo_bar__baz(data: { foo: %w(bar baz) }))
```

```html
<div data-foo="bar baz" class="foo-bar baz"></div>
```

#### Tag with nested data
```ruby
HtmlTag class: :foo do
  ul do
    li do
      a 'baz 1', href: '#'
      a 'baz 2', href: '#'
    end

    push 123

    node :foo, :bar
  end
end
```

```html
<div class="foo">
  <ul>
    <li>
      <a href="#">baz 1</a>
      <a href="#">baz 2</a>
    </li>
    123
    <foo>bar</foo>
  </ul>
</div>
```

#### Renders tag from String base

```ruby
'foo'.tag(:bold, class: :baz)
```

```html
<bold class="baz">foo</bold>
```

#### Renders tag from Hash base

```ruby
{ class: :baz }.tag(:bold, 'foo')
```

```html
<bold class="baz">foo</bold>
```

## Dependency

none

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dux/html-tag.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).