defmodule Thumbnail.Converter do
  use GenServer

  def start_link(_options) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def process(server, opts={src, dst, geometry}) do
    GenServer.cast(server, {:process, opts})
  end

  def init(_options) do
    {:ok, []}
  end

  def handle_cast({:process, {src, dst, geometry}}, state) do
    convert(src, dst, geometry)
    {:noreply, state}
  end

  @doc """
  Resizes the image at path `src` using the geometry string `geometry`,
  writing a new image at path `dst`.
  """
  def convert(src, dst, geometry) do
    cmd = ~s(convert "#{src}" -resize "#{geometry}" "#{dst}")
    System.cmd(cmd)
  end
end
