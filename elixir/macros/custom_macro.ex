# Macros and meta programming
# Macros allow us to manipulate code at COMPILE TIME, so it is used for configuration, seting up modules when compiling
# To achieve this, we need to study regular functions, macros, quote and unquote

# Let's start by quote and unquote
# assume  expr is IO.puts "Hi"
defmodule DynamicStaticCode do
	def quoted_function(_expr) do
		quote do
			_expr # expr is considred some code, and this function is returning AST -> {:_expr, [], DynamicStaticCode}
		end
	end
	# Output AST can be evaluated
	# HI
	# {:_expr, [], DynamicStaticCode}
	def unquoted_function(expr) do
		expr # expression is executed, and the return value of passed function is passed, so we're just returning the value
	end	
	# Output
	# HI
	# :ok
	def quote_and_unquote(expr) do
		quote do
			unquote expr # Interpolating the value of expr
		end
	end
	# Output (this is actually an AST), but it is primitve and only a data so nothing to evaluate
	# HI
	# :ok
end

# So quote let's us create AST (a code block as data)
# We can write our code in that block
# We can evaluate code from out of the quoted block by unquoting
# We can convert that AST to code by Code.eval_quoted


# Macro and Regular functions
defmodule MacroAndRegularFunc do
  defmacro macro_func(clause, do: expression) do
		# Params captured as AST
		quote do
			IO.puts "Inside function"
			IO.inspect(unquote clause)
			IO.inspect(unquote expression)
		end
  end

  def regular_func(clause, do: expression) do
		# Params are captured as values
		quote do
			IO.puts "Inside function"
			IO.inspect(unquote clause)
			IO.inspect(unquote expression)
		end
  end
end

# So we use macros for several reason
# First let's us pass code as AST (not value), which is crucial for injecting
# Second macros will automatically expand/evalute the code
# That is why a macro should almost always return an expression, otherwise it will expand the return value

# iex(13)> MacroAndRegularFunc.macro_func true, do: IO.puts("Hi")
# Inside function
# true
# Hi
# :ok
# :ok
# iex(14)> MacroAndRegularFunc.regular_func true, do: IO.puts("Hi")
# Hi
# {:__block__, [],
#  [
#    {{:., [], [{:__aliases__, [alias: false], [:IO]}, :puts]}, [],
#     ["Inside function"]},
#    {{:., [], [{:__aliases__, [alias: false], [:IO]}, :inspect]}, [], [true]},
#    {{:., [], [{:__aliases__, [alias: false], [:IO]}, :inspect]}, [], [:ok]}
#  ]}


defmodule CustomMacro do
  defmacro custom_unless(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end
end

# Here and at compile time, we have the custom unless
# iex(2)> CustomMacro.custom_unless false, do: IO.puts("Hi")
# Hi
# :ok

