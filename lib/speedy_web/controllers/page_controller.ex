defmodule SpeedyWeb.PageController do
  use SpeedyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
