Dine
====

** Start the Dining Philosophers process **
iex --sname party -S mix
iex> Dine.run

** Start the monitor process **
iex --sname monitor -S mix
iex> Monitor.stats