defmodule Thumbnail do
  use Application

  @doc """
  Takes a source image `src`, a target path `dest`, a base name `name` to be used for generated files, and list of tuples `sizes` representing named thumbnails to generate.

      Thumbnail.process(
        "./foo.png",
        "./destination',
        "foo",
        [ {:medium, "400x400>"}, {:small, "200x200>"} ]
      )

  Asynchronously converts the source image to the target sizes, with the generated filenames in the format:

      :dest/:name-:size.:ext
  """
  def process(src, dest, name, sizes) do
    ext = :filename.extension(src)
    for size <- sizes do
      :poolboy.transaction(:converter_pool, fn(worker) ->
        Thumbnail.Converter.process(
          worker, {src, "#{dest}/#{name}-#{elem(size, 0)}#{ext}", elem(size, 1)}
        )
      end)
    end
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    pool_options = [
      name: {:local, :converter_pool},
      worker_module: Thumbnail.Converter,
      size: 5,
      overflow: 10
    ]

    children = [
      :poolboy.child_spec(:converter_pool, pool_options, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Thumbnail.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
