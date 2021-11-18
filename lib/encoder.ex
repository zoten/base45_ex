defmodule Base45Ex.Encoder do
  @moduledoc """
  Base 45 encoder following draft https://datatracker.ietf.org/doc/draft-faltstrom-base45/
  """
  @alphabet ~c(0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:)

  @spec encode(content :: binary() | list()) :: {:ok, binary()}
  def encode(content) when is_binary(content) do
    encode_charlist(String.to_charlist(content))
  end

  def encode(content) when is_list(content) do
    encode_charlist(content)
  end

  # takes a list of chars that can be numerically handled
  defp encode_charlist(charlist) when is_list(charlist) do
    result =
      charlist
      |> Enum.chunk_every(2)
      |> Enum.map(fn
        [a, b] -> encode_two_bytes(a, b)
        [a] -> encode_one_byte(a)
      end)
      |> Enum.concat()
      |> List.to_string()

    {:ok, result}
  end

  defp encode_two_bytes(a, b) do
    encoded = a * 256 + b
    c_pos = rem(encoded, 45)
    d_pos = rem(div(encoded, 45), 45)
    e_pos = rem(div(div(encoded, 45), 45), 45)
    [Enum.at(@alphabet, c_pos), Enum.at(@alphabet, d_pos), Enum.at(@alphabet, e_pos)]
  end

  defp encode_one_byte(a) do
    c_pos = rem(a, 45)
    d_pos = rem(div(a, 45), 45)
    [Enum.at(@alphabet, c_pos), Enum.at(@alphabet, d_pos)]
  end
end
