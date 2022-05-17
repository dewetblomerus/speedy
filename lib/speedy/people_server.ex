defmodule Speedy.PeopleServer do
  use GenServer
  require Logger
  alias Speedy.People

  @big_list_length 30000
  @pages 10_000
  @per_page 15
  @update_sleep 1000

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  # Callbacks

  @impl true
  def init(_) do
    :ets.new(:people, [:set, :public, :named_table])
    create_people()
    send(self(), {:tick, 1})

    {:ok, []}
  end

  @impl true
  def handle_info({:tick, tick_count}, _) do
    Process.send_after(self(), {:tick, tick_count + 1}, @update_sleep)
    {us_update_people, _} = :timer.tc(__MODULE__, :update_people, [])
    # Logger.debug("_____________________________________")
    # Logger.debug("people updated in #{us_update_people / 1000} milliseconds ✅")

    # Logger.debug("updating big list")
    {us_update_big_list, _} = :timer.tc(__MODULE__, :update_big_list_of_people, [])
    # Logger.debug("big_list updated in #{us_update_big_list / 1000} milliseconds 🌋")
    # Logger.debug("PeopleServer ticking #{tick_count} ⏰")

    {:noreply, []}
  end

  # Helpers

  defp create_people() do
    :ets.insert(:people, {:all, People.generate(@big_list_length)})

    for page <- 1..@pages do
      starting_id = (page - 1) * @per_page + 1

      :ets.insert(:people, {page, People.generate(@per_page, starting_id)})
    end
  end

  def update_people() do
    page_range = 1..@pages

    for page <- page_range do
      update_page(page)
    end
  end

  def update_page(page) do
      updated_people =
        People.list(page: page)
        |> People.update(12)

      :ets.insert(:people, {page, updated_people})
  end

  def update_big_list_of_people() do
    updated_people =
      People.list_from_pages(limit: @big_list_length)

    :ets.insert(:people, {:all, updated_people})
  end
end
