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
import HtmlTag

tag.ul do
  # html tags are accessible as mmethods
  li do
    a href: '#', class: method_in_caller_scope
  end

  # instance variables are accesible
  @list.each_with_index do |el, i|
    li el, num: i
  end

  # custom tags
  tag 'svelte-clock', city: 'London'

  # order of data is not immportant
  a({href: '#'}, name)
  a(name, {href: '#'})

  # class name shrocuts
  _foo__bar_baz # <div class="foo bar-baz"></div>

  # push any data
  push ' &sdot; '
end
```

## Advanced

Useable without importing `HtmlTag`.

```ruby
HtmlTag :ul do
  li do
    a link_to, href: '#'
  end
end

# if you want code to be executed in host scope and not HtlmTag one
HtmlTag.ul do 'n'
  n.li do |n|
    n.a link_to, href: '#'
  end
end
```

### More examples

#### Tag without data
```ruby
= HtmlTag.div
```

```html
<div></div>
```

#### Empty tags
```ruby
= hr
= meta name: :foo, description: :bar
```

```html
<div></div>
<meta name="foo" description="bar" />
```

#### Tag with block data
```ruby
= div { 'foo' }
```

```html
<div>foo</div>
```

#### Tag with inline data and no params
```ruby
= div('baz')
```

```html
<div>baz</div>
```

#### Tag with inline data and params
```ruby
= div('baz', {foo: :bar})
```

```html
<div foo="bar">baz</div>
```

#### Tag with class shortcut
```ruby
= _foo
= _foo__bar_baz 123
```

```html
<div class="foo"></div>
<i class="foo bar-baz">123</i>
```

#### Tag with nested opts and shortcut

```ruby
= _miki(id: :foo, data: { bar: :baz })
```

```html
<div id="foo" data-bar="baz" class="miki"></div>
```

#### Tag with underscore notation and array attributes

```ruby
= _foo_bar__baz(data: { foo: 'bar baz' }))
```

```html
<div data-foo="bar baz" class="foo-bar baz"></div>
```

#### Tag with nested data and manual push

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