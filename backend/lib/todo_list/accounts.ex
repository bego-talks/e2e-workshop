defmodule TodoList.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias TodoList.{Accounts, Repo}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(Accounts.User)
  end

  @doc """
  Gets a single user.
  """
  def get_user(id) do
    case Repo.get(Accounts.User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %Accounts.User{}
    |> Accounts.User.changeset(attrs)
    |> Repo.insert()
  end

  def new_user do
    %Accounts.User{} |> Ecto.Changeset.change()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%Accounts.User{} = user, attrs) do
    user
    |> Accounts.User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%Accounts.User{} = user) do
    Repo.delete(user)
  end

  def login(%{"name" => name, "password" => password}) do
    case Accounts.User |> Repo.get_by(name: name, password: password) do
      nil ->
        {:error, :login_invalid}

      %Accounts.User{id: id} ->
        {:ok, Phoenix.Token.sign(TodoListWeb.Endpoint, "secret", %{id: id})}
    end
  end

  def login(_), do: {:error, :login_invalid}

  def verify_token(token) do
    Phoenix.Token.verify(TodoListWeb.Endpoint, "secret", token, max_age: 24 * 3600)
  end
end
