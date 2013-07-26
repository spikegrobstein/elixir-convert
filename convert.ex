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
    
    import Enum
    import Math

    # lookup table for hex values
    @lookup_table %w{ 0 1 2 3 4 5 6 7 8 9 A B C D E F }

    # given a value as a positive integer
    # return a list of string values containing the hex characters
    def from_dec( value ) when value > 0 do
      do_from_dec( value , [] )         # convert to list of integers (0-15)
        |> map( at(@lookup_table, &1) ) # translate integers into 0-F values from @lookup_table
    end

    # given a value as a positive integer
    # return a string of the hexadecimal representation of said value
    def from_dec_to_string( value ) when value > 0 do
      from_dec( value )
        |> join
    end

    defp do_from_dec( 0, list ) do
      list
    end

    defp do_from_dec( value, list ) when value > 0 do
      do_from_dec div(value, 16), [ rem(value, 16) | list ]
    end

    # Given a list of hex value strings
    # return a the integer representation of it
    def from_hex( value ) when is_list( value ) do
      do_from_hex_list reverse( value ), 0, 0
    end

    # Given a string representation of a hex value,
    # return the integer representation of it
    def from_hex( value ) when is_bitstring( value ) do
      hex_list = String.split( value, %r{} )
                  |> filter( &1 != "" )

      from_hex( hex_list )
    end

    # convert a single hex value (a nibble) as a string into an integer
    # case-insensitive
    # eg: a -> 10
    def hex_val_to_int( hexval ) do
      String.capitalize( hexval )
        |> do_hex_val_to_int( @lookup_table, 0 )
    end

    defp do_hex_val_to_int( hexval, [ v | tail ], acc) when hexval == v do
      acc
    end

    defp do_hex_val_to_int( hexval, [ v | tail ], acc) do
      do_hex_val_to_int( hexval, tail, acc + 1 )
    end


    defp do_from_hex_list( [], _power, acc ) do
      acc
    end

    defp do_from_hex_list( [ v | tail ], power, acc ) do
      val = hex_val_to_int( v )
      do_from_hex_list tail, ( power + 1 ), ( acc + ( val * pow( 16, power)) )
    end

  end

end

