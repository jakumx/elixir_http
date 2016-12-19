defmodule ElixirHttp.Router do
	use Plug.Router
	# require Logger

	# plug Plug.Logger
	plug :match
	plug :dispatch

	def init(options) do
		options
	end

	def start_link do
		{:ok, _} = Plug.Adapters.Cowboy.http ElixirHttp.Router, []
	end

	get "/" do
		conn
		|> send_resp(200, "the / route works")
		|> halt()
	end

	get "/exec" do
		# {resp, _} = System.cmd("ls", [])
		resp = :os.cmd('pwd && ls')

		conn
		|> send_resp(200, resp)
		|> halt()
	end

	match _ do
		conn
		|> send_resp(400, "not found")
		|> halt()
	end


end