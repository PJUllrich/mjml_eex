defmodule MjmlEEx.TestComponents.HEEXComponent do
  @moduledoc "A single Phoenix.Component that renders a HEEX template."

  use Phoenix.Component

  attr(:index, :integer, required: true)
  attr(:name, :string, default: "default")

  def render(assigns) do
    ~H"""
    <mj-text>HEEXComponent <%= @index %> says: <.greet name={@name} /></mj-text>
    """
  end

  def greet(assigns) do
    ~H"""
    <mj-text>Hello to <%= @name %>.</mj-text>
    """
  end
end
