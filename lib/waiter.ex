defmodule Waiter do
  use GenServer

  def start_link( default ) do
    GenServer.start_link( __MODULE__, default, name: __MODULE__ )
  end

  def handle_cast( { :service_please, philosopher_name }, state ) do
    if (Enum.any?( state, fn(x) -> x == philosopher_name end )) do
      { :noreply, state }
    else
      if Enum.count( state ) < 4 do
        GenServer.cast( String.to_atom( philosopher_name ), { :eat })
        { :noreply, Enum.into( state, [philosopher_name] ) }
      else
        :timer.sleep( 2500 )
        GenServer.cast( Waiter, { :service_please, philosopher_name } )
        { :noreply, state }
      end
    end
  end

  def handle_cast( { :done_eating, philosopher_name }, state ) do
    if (Enum.any?( state, fn(x) -> x == philosopher_name end )) do
      GenServer.cast( String.to_atom( philosopher_name ), { :dine })
      { :noreply, Enum.reject( state, &( &1 == philosopher_name )) }
    else
      { :noreply, state }
    end
  end
end
