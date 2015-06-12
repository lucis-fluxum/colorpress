module Colorpress
  module FileIO

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
    #
    # @return [void]

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
    #   it may be a string or an array of ASCII values
    # @param truncate [Boolean] whether or not to empty the file before writing
    #
    # @return [void]

    def self.write_data(filename, data, truncate=false)
      mode = truncate ? 'wb' : 'ab'
      File.open(filename, mode) do |file|
        data = data.pack('C*') if data.is_a? Array
        file.write(data)
      end
    end

  end
end
