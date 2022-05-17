defmodule Speedy.PeopleServer do
  use GenServer
  require Logger
  alias Speedy.People

  @big_list_length 30000
  @pages 1000
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
    update_people()
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

  defp update_people() do
    for page <- 1..@pages do
      updated_people =
        People.list(page: page)
        |> People.update(12)

      :ets.insert(:people, {page, updated_people})
    end

    updated_people =
      People.list_from_pages(limit: @big_list_length)

    :ets.insert(:people, {:all, updated_people})
  end
end
