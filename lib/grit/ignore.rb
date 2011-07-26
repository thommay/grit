module Grit

  class Ignore

    def initialize(base)
      @base = base
    end

    # Test a path against the set of ignored patterns
    #   +path+ is a relative or absolute path 
    #   +patterns+ is an optional Array of patterns to additionally check
    #
    # Examples
    #   i.ignored?("some/file/path.rb")
    #   i.ignored?("some/file/path.rb", ["!path.rb"])
    #
    # returns true if the file is ignored, false otherwise
    #    
    def ignored?(path, patterns=[])
      # walk the list of patterns in all our ignorefiles, and check all of them
    end

    private
    
    # Build a list of patterns to ignore from an ignore file
    #   +fn+ is the ignore file to parse
    #
    # Returns a Hash containing the directory path and an Array of patterns.
    def parse_ignorefile(fn)
      if fn && File.exists?(fn)
        patterns = File.new(fn).inject([]) { |acc,l| l.strip!; acc << l unless (l.empty? or l =~/^\#/); acc }
        { File.dirname(fn) => patterns }
      end
    end

    # Get a heirarchical set of ignore patterns based on the order specified 
    # by the gitignore(5) manpage
    #   +path+ is the path to search for .gitignore files
    #   +patterns+ is an optional Array of ignore patterns
    #
    # returns an Array of Hashes returned from parse_ignorefile
    def patterns(path, patterns=[])
      ignores = []
      ignores << parse_ignorefile(@base.config.fetch("core.excludesfile",""))
      ignores << parse_ignorefile(File.join(@base.path, "info", "exclude"))
      p = @base.working_dir
      ignores << parse_ignorefile(File.join(p, ".gitignore"))
      path.split("/").each do |dir|
        p = File.join(p,dir)
        ignores << parse_ignorefile(File.join(p, ".gitignore"))
      end
      ignores << patterns
    end

  end
end
