defmodule DSLDS do
  # creating DSL using data structures
  def validate(data, rules) do
    Enum.reduce(rules, %{}, fn {field, checks}, acc ->
      value = Map.get(data, field)
      errors = Enum.reduce(checks, [], fn
        {:length, range}, errors_acc ->
          if String.length(value) in range do
            errors_acc
          else
            [{field, "length out of range"} | errors_acc]
          end
        {:matches, regex}, errors_acc ->
          if Regex.match?(regex, value) do
            errors_acc
          else
            [{field, "does not match regex pattern"} | errors_acc]
          end
      end)

      Map.put(acc, field, errors)
    end
  )
  end
end

# Usage
defmodule Client1 do
  import DSLDS
  def client_1_user_validator(user) do
    validate user, [name: [length: 1..10], email: [matches: ~r/@/]]
  end
end

defmodule DSLF do
  def validate_length(data, key, range) do
    value = Map.get(data, key)
    if String.length(value) in range do
      data
    else
      # or maybe return tagged tuple
      raise ArgumentError, "#{key} has invalid length"
    end
  end

  def validate_regex(data, field, regex) do
    value = Map.get(data, field)
    if Regex.match?(regex, value) do
      data
    else
      raise ArgumentError, "#{field} does not match regex patter"
    end
  end
end

# Usage
defmodule Client2 do
  import DSLF
  def client2_user_validator(user) do
    user
    |> validate_length(:name, 1..10)
    |> validate_regex(:email, (~r/@/))
  end
end

# Modules and Macros

defmodule DSLM do
  defmacro __using__(_opts) do
    # when calling use, this what happens, we import macros and make them available for the module
    # we initialize test tests with empty list
    # we register the before compile hook
    quote do
      import DSLM

      @tests []

      # Invoke TestCase.__before_compile__/1 before the module is compiled
      @before_compile DSLM
    end
  end

  # when calling test, it will define a function for it
  defmacro test(description, do: block) do
    function_name = String.to_atom("test " <> description)
    quote do
      @tests [unquote(function_name) | @tests]
      def unquote(function_name)(), do: unquote(block)
    end
  end

  # define a function that would run all tests before compile
  defmacro __before_compile__(_env) do
    quote do
      def run do
        Enum.each(@tests, fn name ->
          IO.puts "Running #{name} test"
          apply(__MODULE__, name, []) # call the function
        end)
      end
    end
  end
end

defmodule Client3 do
  use DSLM

  test "first test" do
    "hello" = "hello"
  end

  test "second test" do
    "hello" = "bye"
  end
end

# # Usage
# Client3.run()

