require_relative 'test_helper'

class PngTest < Minitest::Test

  def setup
    @file_name = 'test/fixtures/test.txt'
    @encode_out = 'test/fixtures/testpng.png'
    @decode_out = 'test/fixtures/testfinal.txt'
  end

  def test_encode_and_decode_file
    Colorpress::PNG.encode(@file_name, @encode_out)

    assert File.exist?(@encode_out)

    file_init = File.binread(@file_name)
    Colorpress::PNG.decode(@encode_out, @decode_out) # cleans up @encode_out
    file_final = File.binread(@decode_out)

    assert_equal file_init, file_final
  end

  def teardown
    File.delete(@decode_out)
  end
end
