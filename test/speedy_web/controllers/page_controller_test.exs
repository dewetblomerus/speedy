defmodule SpeedyWeb.PageControllerTest do
  use SpeedyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Hello!!!"
  end
end
