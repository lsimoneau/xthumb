defmodule Thumbnail.ConverterTest do
  use ExUnit.Case

  @dest_path "./test/support/sample_files/433x66_medium.png"

  setup do
    on_exit fn ->
      File.rm(@dest_path)
    end
  end

  test "it resizes images to the provided geometry" do
    Thumbnail.Converter.convert("./test/support/sample_files/433x66.png", @dest_path, "400x400>")
    :timer.sleep 500
    cmd = ~s(identify -format "%wx%h" "#{@dest_path}")
    assert System.cmd(cmd) == "400x61"
  end
end
