require 'fileutils'

class File
  def self.deep_write(filename, content)
    dirname = File.dirname filename
    FileUtils.mkdir_p dirname unless File.directory? dirname
    File.write filename, content
  end
end

