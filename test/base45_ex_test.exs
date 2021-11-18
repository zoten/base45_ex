defmodule Base45ExTest do
  use ExUnit.Case
  doctest Base45Ex

  # in -> out
  @valid_values [
    {"hello", "+8D VDL2"},
    {"Hello!!", "%69 VD92EX0"}
  ]

  @invalid_values [
    "GGW"
  ]

  describe "encode" do
    test "encode various strings" do
      Enum.each(
        @valid_values,
        fn {input, output} ->
          assert Base45Ex.encode(input) == {:ok, output}
        end
      )
    end
  end

  describe "decode" do
    test "decode various strings" do
      Enum.each(
        @valid_values,
        fn {input, output} ->
          assert Base45Ex.decode(output) == {:ok, input}
        end
      )
    end

    test "decode invalid strings return errors" do
      Enum.each(
        @invalid_values,
        fn input ->
          assert {:error, _reason} = Base45Ex.decode(input)
        end
      )
    end
  end
end
