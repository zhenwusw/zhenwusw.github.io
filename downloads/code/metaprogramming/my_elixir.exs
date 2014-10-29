defmodule MyPlug do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "hello world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end

IO.puts "Running MyPlug with Cowboy on http://localhost:4000"
Plug.Adapters.Cowboy.http MyPlug, []

# mix run --no-halt lib/my_plug.ex


# defmodule MyPlugTest do
#   use ExUnit.Case

#   test "the truth" do
#     assert 1 + 1 == 2
#   end
# end
