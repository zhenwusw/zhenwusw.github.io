defmodule FirstPlug do
  import Plug.Connection

  def call(conn, []) do
    conn = conn
           |> put_resp_content_type("text/plain")
           |> send_resp(200, "Hello world")
    { :ok, conn }
  end
end

IO.puts "Running FirstPlug with Cowboy on http://localhost:4000"
Plug.Adapters.Cowboy.http FirstPlug, []
