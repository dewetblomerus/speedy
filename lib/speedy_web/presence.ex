defmodule SpeedyWeb.Presence do
  use Phoenix.Presence,
    otp_app: :my_app,
    pubsub_server: Speedy.PubSub
end
