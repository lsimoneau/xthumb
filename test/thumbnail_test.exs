defmodule ThumbnailTest do
  use ExUnit.Case

  @small_target "./test/support/sample_files/foo-small.png"
  @medium_target "./test/support/sample_files/foo-medium.png"

  setup do
    on_exit fn ->
      File.rm(@small_target)
      File.rm(@medium_target)
    end
  end

  test "creating multiple thumbnails of an image" do
    Thumbnail.process("./test/support/sample_files/433x66.png", "./test/support/sample_files", "foo", [{:medium, "400x400>"}, {:small, "200x200>"}])
    :timer.sleep 1000
    assert System.cmd(~s(identify -format "%wx%h" "#{@small_target}")) == "200x30"
    assert System.cmd(~s(identify -format "%wx%h" "#{@medium_target}")) == "400x61"
  end
end
