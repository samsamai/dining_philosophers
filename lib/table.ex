defmodule Table do
  use GenServer

  # Client API
  
  def start_link( default ) do
    GenServer.start_link( __MODULE__, default, name: __MODULE__ )
  end

  def take_left_chopstick( position ) do
    position = position - 1
    if position < 0, do: position = 5 + position
    index = rem( position, 5 )

    result = GenServer.call( __MODULE__, { :take_chopstick, index } )

    if result == false, do: take_left_chopstick( position )
    result
  end

  def take_right_chopstick( position ) do
    index = rem( (position), 5 )

    result = GenServer.call( __MODULE__, { :take_chopstick, index } )

    if result == false, do: take_right_chopstick( position )
    result
  end

  def drop_left_chopstick( position ) do
    position = position - 1
    if position < 0, do: position = 5 + position
    index = rem( position, 5 )

    result = GenServer.call( __MODULE__, { :drop_chopstick, index } )

    if result == false, do: drop_left_chopstick( position )
    result
  end

  def drop_right_chopstick( position ) do
    index = rem( (position), 5 )

    result = GenServer.call( __MODULE__, { :drop_chopstick, index } )

    if result == false, do: drop_right_chopstick( position )
    result
  end

  # Server
  def handle_call( { :take_chopstick, index }, _from, state ) do
    if elem( state, index ) == :free do
      new_state = put_elem( state, index, :in_use )
      { :reply, true, new_state }
    else
      { :reply, false, state }
    end
  end

  def handle_call(  { :drop_chopstick, index }, _from, state ) do
    if elem( state, index ) == :in_use do
      { :reply, true, put_elem( state, index, :free ) }
    else
      { :reply, false, state }
    end
  end
end
