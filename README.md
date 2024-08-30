<p align="center">
  <img align="center" width="25%" src="guides/images/logo.svg" alt="MJML EEx Logo">
</p>

<p align="center">
  Easily create beautiful emails using <a href="https://mjml.io/" target="_blank">MJML</a> right from Elixir!
</p>

<p align="center">
  <a href="https://hex.pm/packages/mjml_eex">
    <img alt="Hex.pm" src="https://img.shields.io/hexpm/v/mjml_eex?style=for-the-badge">
  </a>

  <a href="https://github.com/akoutmos/mjml_eex/actions">
    <img alt="GitHub Workflow Status (master)"
    src="https://img.shields.io/github/actions/workflow/status/akoutmos/mjml_eex/main.yml?label=Build%20Status&style=for-the-badge&branch=master">
  </a>

  <a href="https://coveralls.io/github/akoutmos/mjml_eex?branch=master">
    <img alt="Coveralls master branch" src="https://img.shields.io/coveralls/github/akoutmos/mjml_eex/master?style=for-the-badge">
  </a>

  <a href="https://github.com/sponsors/akoutmos">
    <img alt="Support the project" src="https://img.shields.io/badge/Support%20the%20project-%E2%9D%A4-lightblue?style=for-the-badge">
  </a>
</p>

<br>

# Contents

- [Installation](#installation)
- [Supporting MJML EEx](#supporting-mjml_eex)
- [Using MJML EEx](#setting-up-mjml_eex)
- [Configuration](#configuration)
- [Attribution](#attribution)

## Installation

[Available in Hex](https://hex.pm/packages/mjml_eex), the package can be installed by adding `mjml_eex` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mjml_eex, "~> 0.12.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/mjml_eex](https://hexdocs.pm/mjml_eex).

## Supporting MJML EEx

If you rely on this library to generate awesome looking emails for your application, it would much appreciated
if you can give back to the project in order to help ensure its continued development.

Checkout my [GitHub Sponsorship page](https://github.com/sponsors/akoutmos) if you want to help out!

### Gold Sponsors

<a href="https://github.com/sponsors/akoutmos/sponsorships?sponsor=akoutmos&tier_id=58083">
  <img align="center" height="175" src="guides/images/your_logo_here.png" alt="Support the project">
</a>

### Silver Sponsors

<a href="https://github.com/sponsors/akoutmos/sponsorships?sponsor=akoutmos&tier_id=58082">
  <img align="center" height="150" src="guides/images/your_logo_here.png" alt="Support the project">
</a>

### Bronze Sponsors

<a href="https://github.com/sponsors/akoutmos/sponsorships?sponsor=akoutmos&tier_id=17615">
  <img align="center" height="125" src="guides/images/your_logo_here.png" alt="Support the project">
</a>

## Using MJML EEx

### Basic Usage

Add `{:mjml_eex, "~> 0.7.0"}` to your `mix.exs` file and run `mix deps.get`. After you have that in place, you
can go ahead and create a template module like so:

```elixir
defmodule BasicTemplate do
  use MjmlEEx, mjml_template: "basic_template.mjml.eex"
end
```

And the accompanying MJML EEx template `basic_template.mjml.eex` (note that the path is relative to the calling
module path):

```html
<mjml>
  <mj-body>
    <mj-section>
      <mj-column>
        <mj-divider border-color="#F45E43"></mj-divider>
        <mj-text font-size="20px" color="#F45E43"> Hello <%= @first_name %> <%= @last_name %>! </mj-text>
      </mj-column>
    </mj-section>
  </mj-body>
</mjml>
```

With those two in place, you can now run `BasicTemplate.render(first_name: "Alex", last_name: "Koutmos")` and you
will get back an HTML document that can be emailed to users.

### Using Functions from Template Module

You can also call functions from your template module if they exist in your MJML EEx template using
the following module declaration:

```elixir
defmodule FunctionTemplate do
  use MjmlEEx, mjml_template: "function_template.mjml.eex"

  defp generate_full_name(first_name, last_name) do
    "#{first_name} #{last_name}"
  end
end
```

In conjunction with the following template:

```html
<mjml>
  <mj-body>
    <mj-section>
      <mj-column>
        <mj-divider border-color="#F45E43"></mj-divider>
        <mj-text font-size="20px" color="#F45E43"> Hello <%= generate_full_name(@first_name, @last_name) %>! </mj-text>
      </mj-column>
    </mj-section>
  </mj-body>
</mjml>
```

In order to render the email you would then call: `FunctionTemplate.render(first_name: "Alex", last_name: "Koutmos")`

### Using Components

**Static components**

In addition to compiling single MJML EEx templates, you can also create MJML partials and include them
in other MJML templates AND components using the special `render_static_component` function. With the following
modules:

```elixir
defmodule FunctionTemplate do
  use MjmlEEx, mjml_template: "component_template.mjml.eex"
end
```

```elixir
defmodule HeadBlock do
  use MjmlEEx.Component

  @impl true
  def render(_opts) do
    """
    <mj-head>
      <mj-title>Hello world!</mj-title>
      <mj-font name="Roboto" href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500"></mj-font>
    </mj-head>
    """
  end
end
```

And the following template:

```html
<mjml>
  <%= render_static_component HeadBlock %>

  <mj-body>
    <mj-section>
      <mj-column>
        <mj-divider border-color="#F45E43"></mj-divider>
        <mj-text font-size="20px" color="#F45E43"> Hello <%= generate_full_name(@first_name, @last_name) %>! </mj-text>
      </mj-column>
    </mj-section>
  </mj-body>
</mjml>
```

Be sure to look at the `MjmlEEx.Component` module for additional usage information as you can also pass options to your
template and use them when generating the partial string. One thing to note is that when using
`render_static_component`, the data that is passed to the component must be defined at compile time. This means that you
cannot use any assigns that would be evaluated at runtime. For example, this would raise an error:

```elixir
<mj-text>
  <%= render_static_component MyTextComponent, some_data: @some_data %>
</mj-text>
```

**Dynamic components**

If you need to render your components dynamically, use `render_dynamic_component` instead and be sure to configure your
template module like below to generate the email HTML at runtime. First, you create your component, for example, `MyTemplate.CtaComponent.ex`:

```elixir
def MyTemplate.CtaComponent do
  use MjmlEEx.Component, mode: :runtime

  @impl MjmlEEx.Component
  def render(assigns) do
    """
    <mj-column>
      <mj-text font-size="20px" color="#F45E43">#{assigns[:call_to_action_text]}</mj-text>
      <mj-button align="center" inner-padding="12px 20px">#{assigns[:call_to_action_link]}</mj-button>
    </mj-column>
    """
  end
end
```

then, in your MJML template, insert it using the `render_dynamic_template_component` function:

```html
<mjml>
  <mj-body>
    <mj-section>
      <mj-column>
        <mj-divider border-color="#F45E43"></mj-divider>
        <%= render_dynamic_component MyTemplate.CtaComponent %{call_to_action_text: "Call to action text",
        call_to_action_link: "#{@cta_link}"} %>
      </mj-column>
    </mj-section>
  </mj-body>
</mjml>
```

In your `UserNotifier` module, or equivalent, you render your template, passing any assigns/data it expects:

```Elixir
WelcomeEmail.render(call_to_action_text: call_to_action_text, call_to_action_link: call_to_action_link)
```

### Using Layouts

Often times, you'll want to create an Email skeleton or layout using MJML, and then inject your template into that
layout. MJML EEx supports this functionality which makes it really easy to have business branded emails application
wide without having to copy and paste the same boilerplate in every template.

To create a layout, define a layout module like so:

```elixir
defmodule BaseLayout do
  use MjmlEEx.Layout, mjml_layout: "base_layout.mjml.eex"
end
```

And an accompanying layout like so:

```html
<mjml>
  <mj-head>
    <mj-title>Say hello to card</mj-title>
    <mj-font name="Roboto" href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500"></mj-font>
    <mj-attributes>
      <mj-all font-family="Montserrat, Helvetica, Arial, sans-serif"></mj-all>
      <mj-text font-weight="400" font-size="16px" color="#000000" line-height="24px"></mj-text>
      <mj-section padding="<%= @padding %>"></mj-section>
    </mj-attributes>
  </mj-head>

  <%= @inner_content %>
</mjml>
```

As you can see, you can include assigns in your layout template (like `@padding`), but you also need to
include a mandatory `@inner_content` expression. That way, MJML EEx knowns where to inject your template
into the layout. With that in place, you just need to tell your template module what layout to use (if
you are using a layout that is):

```elixir
defmodule MyTemplate do
  use MjmlEEx,
    mjml_template: "my_template.mjml.eex",
    layout: BaseLayout
end
```

And your template file can contain merely the parts that you need for that particular template:

```html
<mj-body> ... </mj-body>
```

## Using with Gettext

Similarly to Phoenix live/dead views, you can leverage Gettext to produce translated emails. To use Gettext, you will
need to have a Gettext module defined in your project (this should be created automatically for you when you create your
Phoenix project via `mix phx.new MyApp`). Then your MjmlEEx module will look something like this:

```elixir
defmodule MyApp.GettextTemplate do
    import MyApp.Gettext

    use MjmlEEx,
      mjml_template: "gettext_template.mjml.eex",
      mode: :compile
  end
```

Make sure that you have the `import MyApp.Gettext` statement before the `use MjmlEEx` statement as you will get a
compiler error that the `gettext` function that is being called in the `gettext_template.mjml.eex` has not been defined.

## Configuration

MJML EEx has support for both the 1st party [NodeJS compiler](https://github.com/mjmlio/mjml) and the 3rd party
[Rust compiler](https://github.com/jdrouet/mrml). By default, MJML EEx uses the Rust compiler as there is an
Elixir NIF built with [Rustler](https://github.com/rusterlium/rustler) that packages the Rust
library for easy use: [mjml_nif](https://github.com/adoptoposs/mjml_nif). By default the Rust compiler is used
as it does not require you to have NodeJS available.

In order to use the NodeJS compiler, you can provide the following configuration in your `config.exs` file:

```elixir
config :mjml_eex, compiler: MjmlEEx.Compilers.Node
```

Be sure to check out the documentation for the `MjmlEEx.Compilers.Node` module as it also requires some
additional set up.

## Attribution

- The logo for the project is an edited version of an SVG image from the [unDraw project](https://undraw.co/)
- The Elixir MJML library that this library builds on top of [MJML](https://github.com/adoptoposs/mjml_nif)
- The Rust MRML library that provides the MJML compilation functionality [MRML](https://github.com/jdrouet/mrml)


## Contributing

Clone the repository and run `mix git_hooks.install` to install the pre-commit hooks. Otherwise, you'll see errors like this when you commit your changes:

```
The dependency is not available, run "mix deps.get"
```