#!/usr/bin/env ruby

def replace_deps(project_path)
  deps_lines =
    ARGV.map do |arg|
      lib, version = arg.split('-')
      version ||= ">= 0.0.0"
      ' '*6 + %Q({:#{lib}, "#{version}"})
    end.join(",\n")

  lines_to_add = <<-EOS.lines
  defp deps do
    [
      #{deps_lines}
    ]
  end
  EOS
  mix_exs_path = File.join(project_path, 'mix.exs')
  lines = File.readlines(mix_exs_path)
  i0 = lines.index { |l| l[/^\s*defp\s+deps\s+do\s*$/] }
  i1 = i0 + lines[i0..-1].index { |l| l[/^\s*end\s*$/] }
  altered_content = (lines[0...i0] + lines_to_add + lines[i1+1..-1]).join("\n")
  File.write(mix_exs_path, altered_content)
end  

PROJECT_NAME = 'iex_tmp'
if __FILE__ == $PROGRAM_NAME
  require 'tmpdir'

  if ARGV.size < 1
    puts "usage #{__FILE__} [<lib[-version]>]+"
    exit
  end

  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir)
    system "mix new #{PROJECT_NAME}"
    project_path = File.join(tmp_dir, PROJECT_NAME)
    replace_deps(project_path)
    Dir.chdir(project_path)
    system "mix deps.get"
    system "iex -S mix run --no-start"
  end
end
