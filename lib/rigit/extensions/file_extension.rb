require 'fileutils'

class File
  def self.deep_write(filename, content)
    # :nocov: only due to the fact that the rspec_fixtures gem brings
    #         this method as well
    dirname = File.dirname filename
    FileUtils.mkdir_p dirname unless File.directory? dirname
    File.write filename, content
    # :nocov:
  end
end

