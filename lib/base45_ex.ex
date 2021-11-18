defmodule Base45Ex do
  @moduledoc """
  Documentation for `Base45Ex`.
  """

  @spec encode(binary() | list()) :: {:ok, binary()}
  @doc """
  Base45 Encode a string or charlist

  ## Examples

      iex> Base45Ex.encode("hello")
      {:ok, "+8D VDL2"}

  """
  def encode(content) do
    Base45Ex.Encoder.encode(content)
  end

  @spec decode(binary() | list()) :: {:error, any()} | {:ok, binary()}
  @doc """
  Base45 Decode a string or charlist

  ## Examples

      iex> Base45Ex.decode("+8D VDL2")
      {:ok, "hello"}

  """
  def decode(content) do
    Base45Ex.Decoder.decode(content)
  end
end
