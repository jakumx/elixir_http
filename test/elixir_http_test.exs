defmodule ElixirHttpTest do
  use ExUnit.Case
  doctest ElixirHttp

  test "the truth" do
    assert 1 + 1 == 2
  end

	test "GET /" do

		startDate = System.monotonic_time(:milliseconds)
		response = HTTPotion.get "http://127.0.0.1:4000"
		endDate = System.monotonic_time(:milliseconds)

		diff = endDate - startDate
		IO.inspect "----- ms -------"
		IO.inspect diff
		IO.inspect "----------------"

    assert HTTPotion.Response.success?(response)

  end

end
