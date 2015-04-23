defmodule BX do
  alias BX.Engine

  def run(argv) do
    parse_args(argv)
  end

  def help do
    IO.puts "usage: mix run -e 'BX.run([\"filename\"])'"
  end

  def run_interpreter(filename) do
    case File.read(filename) do
      {:ok, code}      -> IO.puts Engine.new(code) |> Engine.execute_loop |> Engine.output_result
      {:error, reason} -> IO.puts "Error reading file #{filename}. Reason #{reason}"
    end
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                      aliases: [ h: :help])
    case parse do
      { [help: true ], _, _ } -> help
      { _, [ file ], _ } -> run_interpreter file
      _ -> help
    end
  end
end
