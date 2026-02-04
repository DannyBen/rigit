require 'stringio'

class StringIO
  def wait_readable(*)
    true
  end
end

module SpecMixin
  def stdin_send(*args)
    $stdin = StringIO.new
    $stdin.puts(args.shift) until args.empty?
    $stdin.rewind
    yield
  ensure
    $stdin = STDIN
  end

  def down_arrow
    "\e[B"
  end

  def up_arrow
    "\e[A"
  end

  def supress_output
    original_stdout = $stdout
    $stdout = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
  end

  def ls
    Dir['**/*'].to_s
  end

  def without_env(var, &)
    with_env(var, nil, &)
  end

  def with_env(var, value = 'yes')
    oritinal_value = ENV[var]
    ENV[var] = value
    yield
    ENV[var] = oritinal_value
  end

  def reset_workdir
    system 'rm -rf spec/tmp' if Dir.exist? 'spec/tmp'
    Dir.mkdir 'spec/tmp'
  end
end
