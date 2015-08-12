defmodule Philosopher do
  use GenServer

  def handle_cast( { :dine }, state ) do
    IO.puts "#{ state[ :name ]} is thinking."

    # :timer.sleep(:random.uniform(2000))
    GenServer.cast( Waiter, { :service_please, state[ :name ] })

    { :noreply, state }
  end

  def handle_cast( { :eat }, state ) do
    position = state[ :position ]
    name = state[ :name ]
    
    Table.take_left_chopstick( position )
    Table.take_right_chopstick( position )

    ate_so_far = state[ :ate ] + 1
    IO.puts "#{name} is eating. Ate so far: #{ate_so_far}"
    # :timer.sleep(:random.uniform(2000))

    Table.drop_left_chopstick( position )
    Table.drop_right_chopstick( position )

    GenServer.cast( Waiter, { :done_eating, state[ :name ] })

    { :noreply, %{state | ate: ate_so_far } }
  end

  def handle_call( :how_many_eats, _from, state ) do
    { :reply, state.ate, state }
  end

end

