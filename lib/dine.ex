defmodule Dine do
  def run do
    IO.puts "Starting the dining party!"
    { :ok, _pid } = Table.start_link( { :free, :free, :free, :free, :free } )
    { :ok, _waiter_pid } = Waiter.start_link( [] )

    names = [ "Seneca", "Zeno", "Musonius Rufus", "Epictetus", "Marcus" ]
    names |> Enum.with_index 
          |> Enum.map( fn( { _name, _position } ) -> 
                  IO.puts "Configuring #{_name}"
                  GenServer.start_link( Philosopher, %{ name: _name, position: _position, ate: 0 }, name: String.to_atom( _name ))
                  GenServer.cast( String.to_atom( _name ), { :dine }) 
                end 
              )
  end
end
