defmodule Timemanager.Accounts.UserToken do
  use Ecto.Schema
  import Ecto.Query

  @hash_algorithm :sha256
  @rand_size 32

  # Définissez la durée de validité du token API
  @api_token_validity_in_days 365

  schema "users_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :user, Timemanager.Accounts.User

    timestamps(updated_at: false)
  end

  def build_api_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %Timemanager.Accounts.UserToken{
      token: :crypto.hash(@hash_algorithm, token),
      context: "api-token",
      user_id: user.id
    }}
  end


  def verify_api_token_query(token) do
    from token in token_and_context_query(token, "api-token"),
      join: user in assoc(token, :user),
      where: token.inserted_at > ago(@api_token_validity_in_days, "day"),
      select: user
  end

  defp token_and_context_query(token, context) do
    from Timemanager.Accounts.UserToken, where: [token: ^token, context: ^context]
  end
end
