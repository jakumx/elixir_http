defmodule ElixirHttpTest do
	use ExUnit.Case
	doctest ElixirHttp

 	test "1 sec requests sync" do
 		
 		startDate = System.monotonic_time(:milliseconds)
 		afterDate = startDate + 1000

 		{count, arryDiff} = Recursion.do_multiple_times(0,[], startDate, afterDate, false)
 		Recursion.show_logs(count, arryDiff, "sync")

 	end

 	test "1 sec requests async" do
 		
 		startDate = System.monotonic_time(:milliseconds)
 		afterDate = startDate + 1000

 		{count, arryDiff} = Recursion.do_multiple_times(0,[], startDate, afterDate, true)
 		Recursion.show_logs(count, arryDiff, "async")

 	end

 	test "GET /" do

		startDate = System.monotonic_time(:milliseconds)
		response = HTTPotion.get "http://127.0.0.1:4000/exec"
		endDate = System.monotonic_time(:milliseconds)

		diff = endDate - startDate
		IO.inspect "GET /exec ->  #{diff} ms"

    	assert HTTPotion.Response.success?(response)

	end

end

defmodule Recursion do
	def do_multiple_times(count, arryDiff, now, limit, flag) when now <= limit do
		count = count + 1
		ops = 
		 if flag do
		 	[stream_to: self]
		 else 
		 	[stream_to: nil]
		 end
		startDate = System.monotonic_time(:milliseconds)
		HTTPotion.get "http://127.0.0.1:4000/exec", ops
		endDate = System.monotonic_time(:milliseconds)
		diff = endDate - startDate
		arryDiff = Enum.into(arryDiff, [diff])
		do_multiple_times(count,arryDiff, System.monotonic_time(:milliseconds), limit, flag)
	end

	def do_multiple_times(count, arryDiff,now, limit, flag) do
		{count - 1, Enum.drop(arryDiff, -1)}
	end

  	def show_logs(count, arryDiff, title) do
  		IO.inspect "----- #{title} ------"
  		IO.inspect "counts: #{count}"
  		IO.inspect "sum: #{Enum.sum(arryDiff)}"
  		IO.inspect "prom: #{Enum.sum(arryDiff)/count}"
	end
end
