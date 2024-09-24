# Elixir is heavily using recursion for looping
# And as the problem with recursion is that it push functions to the stack we might easily fall into a stackoverflow problem
# but that is not the case with Tailcalls, it simply mean that if a function ends with a function call
# It is not pushed to the stack, but it jumps without pushing
defmodule FibonacciWithoutTailCall do
	def getNumber(0), do: 0
	def getNumber(1), do: 1
	def getNumber(n) when n < 0, do: :error
	def getNumber(n), do: getNumber(n-1) + getNumber(n-2)
end

defmodule FibonacciWithTailCall do
	def getNumber(n) when n < 0, do: :error
	def getNumber(n), do: getNumber(n, 1, 0)
	defp getNumber(0, _, current_val), do: current_val
	defp getNumber(n, next_val, current_val), do: getNumber(n-1, next_val + current_val, next_val)
end

defmodule TestWithTailCall do
	def test(n) do
		start = :os.system_time
		fib = FibonacciWithTailCall.getNumber(n)
		finish = :os.system_time
		diff = finish - start
		IO.puts("Fib is #{fib}")
		IO.puts("Time is #{diff}")
	end
end

defmodule TestWithoutTailCall do
	def test(n) do
		start = :os.system_time
		fib = FibonacciWithoutTailCall.getNumber(n)
		finish = :os.system_time
		diff = finish - start
		IO.puts("Fib is #{fib}")
		IO.puts("Time is #{diff}")
	end
end

# iex(17)> TestWithoutTailCall.test(40)
# Fib is 102334155
# Time is 7032775000
# :ok
# iex(18)> TestWithTailCall.test(40)
# Fib is 102334155
# Time is 2000
# :ok
