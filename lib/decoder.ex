defmodule Base45Ex.Decoder do
  @moduledoc """
  Base 45 decoder following draft https://datatracker.ietf.org/doc/draft-faltstrom-base45/
  """

  @reverse_char_map ~c(0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:)
                    |> Enum.with_index()
                    |> Enum.into(%{})

  @spec decode(content :: binary() | list()) :: {:ok, binary()} | {:error, any()}
  def decode(content) when is_binary(content) do
    decode_charlist(String.to_charlist(content))
  end

  def decode(content) when is_list(content) do
    decode_charlist(content)
  end

  # takes a list of chars that can be numerically handled
  defp decode_charlist(charlist) when is_list(charlist) do
    with {:ok, inverted_chars} <- map_invert(charlist),
         chunked <- Enum.chunk_every(inverted_chars, 3),
         {:ok, decoded} <- decode_bytes(chunked) do
      {:ok, decoded |> Enum.concat() |> List.to_string()}
    else
      error -> error
    end
  end

  defp decode_bytes(chunked) do
    case Enum.reduce_while(
           chunked,
           {:ok, []},
           &decode_bytes_chunk/2
         ) do
      {:ok, decoded} ->
        {:ok, Enum.reverse(decoded)}

      error ->
        error
    end
  end

  defp decode_bytes_chunk([c, d, e], {:ok, acc}) do
    case decode_three_bytes(c, d, e) do
      {:ok, decoded} -> {:cont, {:ok, [decoded | acc]}}
      error -> {:halt, error}
    end
  end

  defp decode_bytes_chunk([c, d], {:ok, acc}) do
    case decode_two_bytes(c, d) do
      {:ok, decoded} -> {:cont, {:ok, [decoded | acc]}}
      error -> {:halt, error}
    end
  end

  defp map_invert(charlist) when is_list(charlist) do
    case Enum.reduce_while(charlist, {:ok, []}, fn char, {:ok, acc} ->
           case Map.get(@reverse_char_map, char, :undefined) do
             :undefined -> {:halt, {:error, {:invalid_char, char}}}
             mapped -> {:cont, {:ok, [mapped | acc]}}
           end
         end) do
      {:ok, reversed_chars} -> {:ok, Enum.reverse(reversed_chars)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp decode_three_bytes(c, d, e) do
    case c + d * 45 + e * 45 * 45 do
      n when n > 0xFFFF ->
        {:error, :invalid_base45_string}

      n ->
        a = div(n, 256)
        b = rem(n, 256)
        {:ok, [<<a::utf8>>, <<b::utf8>>]}
    end
  end

  defp decode_two_bytes(c, d) do
    case c + d * 45 do
      a when a > 0xFF ->
        {:error, :invalid_base45_string}

      a ->
        {:ok, [<<a::utf8>>]}
    end
  end
end
