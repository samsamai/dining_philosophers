# TODO
# make a nice table

defmodule Monitor do
  @names [ "Seneca", "Zeno", "Musonius Rufus", "Epictetus", "Marcus" ]

  def stats() do
    n = Enum.map( @names, fn( name ) -> 
            eats = GenServer.call( { String.to_atom( name ), :"party@sams-mini" }, :how_many_eats, 10000 )
            [name: name, eats: Integer.to_string(eats)]
          end 
        )

    IO.puts IO.ANSI.clear
    IO.puts IO.ANSI.home
    IO.puts "\n\n\n\n\n\n\n\n\n\n\n"
    print_table_for_columns( n, [:name, :eats] )

    :timer.sleep( 500 )
    stats 
  end

  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  def print_table_for_columns(rows, headers) do 
    data_by_columns = split_into_columns(rows, headers) 
    column_widths = widths_of(data_by_columns) 
    format = format_for( column_widths )
    puts_one_line_in_columns headers, format
    IO.write "                            "
    IO.puts separator(column_widths)
    puts_in_columns data_by_columns, format
  end

  def split_into_columns(rows, headers) do 
    for header <- headers do
      for row <- rows, do: printable(row[header]) 
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> map( fn(x) -> if x < 5, do: 5, else: x end ) |> max
  end

  def format_for(column_widths) do
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do 
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    IO.write "                            "
    :io.format(format, fields)
  end

end
