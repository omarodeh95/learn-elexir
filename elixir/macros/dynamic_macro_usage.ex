# leveraging macros and meta programming
# Assume that before running a programe i.e web app, we want to configrue our db
# on client side, you will simple configure your db by use Database, :postgres
# This will thin provide the Repo, which is configured to use postgress
# the use keyword is going to invoke the __using__ macro
defmodule Database do
  def mysql(which) do
    # quote will make the code as an expression and not executable
    quote do
      # Assume I am importing a specific printing module
      defmodule Repo do
        def db_config do
          IO.puts("You selected #{unquote which} configuration")
        end
      end
    end
  end

  def postgres(which) do
    quote do
      # Assume I am importing a specific printing module
      defmodule Repo do
        def db_config do
          IO.puts("You selected #{unquote which} configuration")
        end
      end
    end
  end

  defmacro __using__(db_type) do
    # apply will call a function dynamically based on args
    # __MODULE__ refers to the current module
    # Which is the name of the function to be called
    # [] -> those are parameters, that can be passed to the function
    apply __MODULE__, db_type, [db_type]
  end
end

# iex(1)> require Database
# Database
# iex(2)> use Database, :postgres
# {:module, Repo,
#  <<70, 79, 82, 49, 0, 0, 6, 160, 66, 69, 65, 77, 65, 116, 85, 56, 0, 0, 0, 243,
#    0, 0, 0, 25, 11, 69, 108, 105, 120, 105, 114, 46, 82, 101, 112, 111, 8, 95,
#    95, 105, 110, 102, 111, 95, 95, 10, 97, ...>>, {:db_config, 0}}
# iex(3)> Repo.db_config
# You selected postgres configuration
# :ok

