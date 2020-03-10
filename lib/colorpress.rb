require 'chunky_png'
require 'colorpress/version'

module Colorpress
  # Encode a file to PNG format.
  #
  # @param file_name [String] the name of the file to encode
  # @param output_name [String, nil] the optional name of the output file
  # @param min_width [Integer] the minimum width of the image, in pixels
  def self.encode(file_name, output_name=nil, min_width=50)
    file_size = File.stat(file_name).size
    # Increase width until it divides number of bytes evenly
    while file_size % min_width != 0
      min_width += 1
    end
    image = ChunkyPNG::Image.new(min_width, file_size/min_width)

    y = 0
    read_bytes(file_name, min_width) do |buffer|
      unpacked_data = buffer.unpack('C*')
      unpacked_data.each_with_index do |value, index|
        # Randomly pick between red/green/blue
        rgb = [0, 0, 0]
        rgb[(rand * 3).to_i] = value
        image[index, y] = ChunkyPNG::Color.rgb(*rgb)
      end
      y += 1
    end

    image.save(output_name.nil? ? file_name + '.png' : output_name)
  end

  # Decode a file from PNG format.
  #
  # @param image_name [String] the name of the image to decode, ex: 'filename.txt.png'
  # @param output_name [String, nil] the name of the output file (no extension needed), ex: 'my_file'
  # @param cleanup [Boolean] whether to delete PNG file after decoding
  def self.decode(image_name, output_name=nil, cleanup=true)
    output_name = image_name[0...-4] unless output_name # Remove .png extension
    image = ChunkyPNG::Image.from_file(image_name)

    write_data(output_name, '', true) # Make sure the output file is empty

    bytes = []
    (0..image.dimension.height-1).each do |y|
      (0..image.dimension.width-1).each do |x|
        # It's either red, green, or blue, so add them all
        bytes << ChunkyPNG::Color.r(image[x, y]) +
          ChunkyPNG::Color.g(image[x, y]) +
          ChunkyPNG::Color.b(image[x, y])
      end
      write_data(output_name, bytes)
      bytes = []
    end

    write_data(output_name, bytes) if bytes.any? # Write if any bytes still in array

    File.delete(image_name) if cleanup
  end

  private

  # Reads bytes from a file into a buffer, yielding the buffer to a given block.
  #
  # @param filename [String] the name of the file to read
  # @param buffer_size[Integer, nil]
  #   amount of bytes to read into the buffer at a time
  #
  # @example Reading all of a file
  #   other_bytes = ''
  #   Colorpress::FileIO.read_bytes('filename.txt', 20) do |buffer|
  #     other_bytes += buffer
  #   end
  #   # other_bytes now contains all bytes of the file
  def self.read_bytes(filename, buffer_size=20)
    File.open(filename, 'rb') do |file|
      until file.eof? do
        buffer = file.read(buffer_size)
        yield buffer
      end
    end
  end

  # Writes the given data to the given filename. Truncates the file if desired.
  #
  # @param filename [String] the name of the file to write
  # @param data [String, Array] the data to write to the file,
  #   it may be a string or an array of bytes
  # @param truncate [Boolean] whether or not to empty the file before writing
  def self.write_data(filename, data, truncate=false)
    mode = truncate ? 'wb' : 'ab'
    File.open(filename, mode) do |file|
      data = data.pack('C*') if data.is_a? Array
      file.write(data)
    end
  end
end
