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

tag._row [                      # <div class="row">
  tag.('#menu.col') { @menu },  #   <div id="menu" class="col">@menu</div>
  tag._col { @data }            #   <div class="col">@data</div>
]                               # </div>
```

### More examples

#### Tag without data
```ruby
= tag.div
```

```html
<div></div>
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
= tag.div({foo: :bar}, 'baz')
```

```html
<div foo="bar">baz</div>
```

#### Tag with class shortcut
```ruby
= tag._foo
```

```html
<div class="foo"></div>
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
= tag._foo_bar(data: { foo: %w(bar baz) }))
```

```html
<div data-foo="bar baz" class="foo-bar"></div>
```

#### Tag with array data attributes

```ruby
tag.div [tag.i, tag.u, tag.b]
```

```html
<div><i></i><u></u><b></b></div>
```

#### Tag with nested data
```ruby
tag._foo do
  tag.ul do
    tag.li do
      tag.a(href: '#') { 'baz 1' }
      tag.a(href: '#') { 'baz 2'  }
    end
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
  </ul>
</div>
```

#### Renders html data passed as an array
```ruby
= tag._row [
  tag.('#menu.col') { @menu },
  tag._col { @data }
]
```

```html
<div class="row">
  <div id="menu" class="#menu col"></div>
  <div class="col"></div>
</div>
```
