defmodule Factorial do

  def of(0), do: 1

  def of(n) when n > 0, do: n * of(n-1)

end


defmodule MessageBus do

  # call any function that matches the listener
  # type is atom (eg: :hello)
  # message is string
  # listeners is list of tuples of functions
  # [ hello: fn(m) -> IO.puts m end, bye: fn(m) -> IO.puts m end, hello: fn(m) -> IO.puts "I will also do this crap" end ]""]
  def publish(type, message, listeners) do
    _publish(type, message, listeners)
  end

  def _publish( _type, _message, [] ), do: :nothing

  def _publish(type, message, [ { handler, fun } |t ]) when handler == type do
    fun.(message)
    _publish(type, message, t)
  end

  def _publish( type, message, [ { _, _} | t ] ) do
    _publish(type, message, t)
  end

end

defmodule Math do
    def pow( num, power ) do
      do_pow num, power, 1
    end

    defp do_pow( _num, 0, acc ) do
      acc
    end

    defp do_pow( num, power, acc ) when power > 0 do
      do_pow( num, power - 1, acc * num)
    end
  
end

defmodule Convert do

  defmodule Binary do

    import Enum
    import Math

    # Given a decimal value, return a list of 1 and 0
    # of the value represented in binary
    def from_dec( value ) when value > 0 do
      do_from_dec value, []
    end

    # Given a decimal value, return a string containing the
    # binary representation of value
    def from_dec_to_string( value ) when value > 0 do
      join do_from_dec( value, [] )
    end

    defp do_from_dec( 0, list ) do
      list
    end

    defp do_from_dec( value, list ) when value > 0 do
      do_from_dec div(value, 2), [ rem(value, 2) | list ]
    end


    # Given a list of 1s and 0s, return the decimal representation of value
    def from_binary( value ) when is_list( value ) do
      do_from_binary_list reverse( value ), 0, 0
    end

    # Given a binary value as a string, convert to an int
    # eg: from_binary_string("1010011010") -> 666
    def from_binary( value ) when is_bitstring( value ) do

      bin_list = String.split( value, %r{} )             # split the string into characters
                  |> filter( &1 != "" )                  # drop any chars that are empty strings (String.split terminates the list with an empty string for some reason)
                  |> map( String.to_integer(&1) )        # convert each one into an int; this returns tuples of {i, ""}
                  |> map( fn(i) -> { n, _ } = i; n end ) # get the value from each tuple

      # now convert that list into an int using the main function
      from_binary bin_list
    end

    defp do_from_binary_list( [], _power, acc ) do
      acc
    end

    defp do_from_binary_list( [ v | tail ], power, acc ) do
      do_from_binary_list tail, ( power + 1 ), ( acc + (v * pow(2, power)) )
    end

  end

  defmodule Hex do
    
    def to( value ) when value > 0 do
      raise "ERROR"
    end
  end

end

