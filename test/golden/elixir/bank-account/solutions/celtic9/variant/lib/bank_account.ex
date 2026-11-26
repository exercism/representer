defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {:ok, account} = Agent.start(fn -> 0 end)
    account
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    Agent.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    with {:ok, balance} <- check_balance(account) do
      balance
    else
      error -> error
    end
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(account, amount) do
    with {:ok, _} <- check_balance(account),
         {:ok, _} <- check_amount(amount) do
      Agent.update(account, fn balance -> balance + amount end)
    else
      error -> error
    end
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(account, amount) do
    with {:ok, balance} <- check_balance(account),
         {:ok, _} <- check_amount(amount),
         {:ok, _} <- check_enough_balance(balance, amount) do
         Agent.update(account, fn balance -> balance - amount end)
    else
      error -> error
    end
  end

  defp check_balance(account) do
    if Process.alive?(account) do
      {:ok, Agent.get(account, &(&1))}
    else
      {:error, :account_closed}
    end
  end

  defp check_amount(amount) when amount < 0, do: {:error, :amount_must_be_positive}
  defp check_amount(amount), do: {:ok, amount}

  defp check_enough_balance(balance, amount) when amount > balance, do: {:error, :not_enough_balance}
  defp check_enough_balance(_balance, amount), do: {:ok, amount}

  

end
