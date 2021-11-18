# Base45Ex

Super naive Base45 encoding-decoding utilities.
Not aimed for performance or anything. Yet.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `base45_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:base45_ex, "~> 0.1.0"}
  ]
end
```

otherwise, you can just link directly to this repo

```elixir
def deps do
  [
    {:base45_ex, git: "https://github.com/zoten/base45_ex", ref: "main"}
  ]
end
```

## Usage

This library offers two callbacks

### Encoding

Encoding always returns `{:ok, <encoded string>}`

``` elixir
Base45Ex.encode("hello")
# {:ok, "+8D VDL2"}
```

### Decoding

``` elixir
Base45Ex.decode("+8D VDL2")
# {:ok, "hello"}
Base45Ex.decode("GGW")     
# {:error, :invalid_base45_string}
```

## Contributing

Well, please just make sure you format your code until the check is performed in CI.
And maybe also check that tests pass, this could be nice :)
Thanks in advance if you wish to improve this code!
