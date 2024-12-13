defmodule Ksphoenix.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ksphoenix.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-12-12],
        description: "some description",
        title: "some title"
      })
      |> Ksphoenix.Events.create_event()

    event
  end
end
