# TODO
# make a nice table

defmodule Monitor do
  @names [ "Seneca", "Zeno", "Musonius Rufus", "Epictetus", "Marcus" ]

  def stats() do
    n = Enum.map( @names, fn( name ) -> 
            eats = GenServer.call( { String.to_atom( name ), :"party@sams-mini" }, :how_many_eats, 10000 )
            { name, eats }
          end 
        )

    IO.puts IO.ANSI.clear
    IO.puts IO.ANSI.home
    n |> Enum.map( fn{ name, eats } -> IO.puts "#{name} : #{eats}" end )

    :timer.sleep( 1500 )
    stats 
  end
end
