defmodule Ksphoenix.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :username, :string, default: "anamitra_joshi"

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:username, :body])
    |> validate_required([:body])
    |> validate_length(:body, min: 2, max: 1000)
  end
end
