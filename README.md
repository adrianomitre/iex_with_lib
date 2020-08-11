# Motivation

Coming to Elixir from languages where there it is possible to install packages globally, I missed the simplicity for quickly experimenting with a library on the REPL

In Ruby you can do it like this:
```bash
# optional step: to check whether the gem is already installed
$ gem list csv

$ gem install csv
$ irb -r csv --simple-prompt
>> CSV.parse("hello,lib")
=> [["hello", "lib"]]
>> # CTRL + D

# optional step: skip this if you skipped `gem list csv` before `gem install csv`
$ gem uninstall csv
```

In Elixir you would have to do something like the following:
```bash
$ export TEMP_DIR=$(mktemp -d)
$ mix new $TEMP_DIR/foo
$ cd $TEMP_DIR/foo
# edit mix.exs file in order to add {:ex_csv, ">= 0"} to Foo.MixProject.deps/0
$ mix deps.get
$ iex -S mix run --no-start
iex(1)> ExCsv.parse("hello,lib")
{:ok,
 %ExCsv.Table{
   body: [["hello", "lib"]],
   headings: [],
   row_mapping: nil,
   row_struct: nil
 }}
iex(2)>%  # CTRL+\

# optional
$ cd -
$ rm -rf $TEMP_DIR/foo
```

Not super hard or complex, but harder still.

# Solution

With this Ruby script you can do the following (assuming it is flagged as executable and in PATH):
```bash
$ iex_with_lib.rb ex_csv
iex(1)> ExCsv.parse("hello,lib")
{:ok,
 %ExCsv.Table{
   body: [["hello", "lib"]],
   headings: [],
   row_mapping: nil,
   row_struct: nil
 }}
iex(2)>%  # CTRL+\
# no manual clean-up necessary
```

# Usage

```bash
iex_with_lib.rb [<lib[-version]>]+
```

You can pass an arbitrary number of libs, optionally specifying the Version requirement for each (e.g., `decimal`, `decimal-1.8.1` or `'decimal - ~> 1.0'`).
