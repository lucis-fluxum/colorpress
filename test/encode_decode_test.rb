require_relative 'test_helper'

class PngTest < Minitest::Test

  def setup
    @file_name = 'test/fixtures/test.txt'
    @encode_out = 'test/fixtures/encoded.png'
    @decode_out = 'test/fixtures/decoded.txt'
  end

  def test_encode_and_decode_file
    Colorpress::encode(@file_name, @encode_out, min_width=100)
    assert File.exist?(@encode_out)
    Colorpress::decode(@encode_out, @decode_out, cleanup=false)
    assert File.exist?(@encode_out)

    assert_equal File.binread(@file_name), File.binread(@decode_out)
  end

  def teardown
    File.delete(@decode_out)
  end
end
