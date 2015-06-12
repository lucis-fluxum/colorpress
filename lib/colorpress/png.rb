require 'oily_png'

module Colorpress
  module PNG

    # Encode a file to PNG format.
    #
    # @param file_name [String] the name of the file to encode
    # @param output_name [String, nil] the optional name of the output file
    #
    # @example Encoding a file
    #   Colorpress::PNG.encode('filename.txt')
    #
    # @return [void]

    def self.encode(file_name, output_name=nil)
      file_size = File.stat(file_name).size
      image = ChunkyPNG::Image.new(file_size, 1)
      width_offset = 0

      Colorpress::FileIO.read_bytes(file_name) do |buffer|
        unpacked_data = buffer.unpack('C*')
        unpacked_data.each_with_index do |value, index|
          image[index + width_offset, 0] = ChunkyPNG::Color.rgb(0, 0, value)
        end
        width_offset += unpacked_data.length
      end

      image.save(output_name.nil? ? file_name + '.png' : output_name)
    end

    # Decode a file from PNG format.
    #
    # @param image_name [String] the name of the image to decode, ex: 'filename.txt.png'
    # @param output_name [String, nil] the name of the output file (no extension needed), ex: 'my_file'
    # @param cleanup [Boolean] whether to delete file after decoding
    #
    # @example Decoding a file
    #   Colorpress::PNG.decode('image_name.yml.png', 'output_name')
    #
    # @return [void]

    def self.decode(image_name, output_name=nil, cleanup=true)
      bytes = []
      output_name = output_name.nil? ? image_name[0...-4] : output_name # Remove .png extension
      image = ChunkyPNG::Image.from_file(image_name)

      Colorpress::FileIO.write_data(output_name, '', true) # Make sure the output file is empty

      (0 .. image.dimension.width - 1).each do |x_pos|
        bytes << ChunkyPNG::Color.b(image[x_pos, 0])
        if bytes.length > 30
          Colorpress::FileIO.write_data(output_name, bytes)
          bytes = []
        end
      end

      Colorpress::FileIO.write_data(output_name, bytes) if bytes.any? # Write if any bytes still in array

      File.delete(image_name) if cleanup
    end

  end
end
