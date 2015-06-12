require_relative 'test_helper'

class FileIOTest < Minitest::Test

  def setup
    @filename = 'test/fixtures/test.txt'
    @temp_filename = @filename + '.tmp'
  end

  def test_read_bytes_from_file
    bytes = File.binread(@filename)

    other_bytes = ''
    Colorpress::FileIO.read_bytes(@filename, 20) do |buffer|
      other_bytes += buffer
    end

    assert_equal bytes, other_bytes
  end

  def test_write_data_to_file
    data = File.binread(@filename)

    Colorpress::FileIO.write_data(@temp_filename, data)
    other_data = File.binread(@temp_filename)

    # Also test clearing a file
    Colorpress::FileIO.write_data(@temp_filename, '', true)

    assert_equal data, other_data
    assert File.stat(@temp_filename).size == 0
  end

  def test_unpacked_data_to_file
    Colorpress::FileIO.read_bytes(@filename, 30) do |buffer|
      data = buffer.unpack('C*')
      Colorpress::FileIO.write_data(@temp_filename, data)
    end

    data = File.binread(@filename)
    other_data = File.binread(@temp_filename)

    assert_equal data, other_data
  end

  def teardown
    File.delete(@temp_filename) if File.exist? @temp_filename
  end
end
