defmodule FileRemover do
  defp delete(path_file) do
    case File.rm(path_file) do
      :ok ->
        puts_ok("Deleted", path_file)

      {:error, reason} ->
        puts_error "Unable to remove file: #{path_file}, reason: #{reason}"
    end
  end

  defp ask(path_file) do
    case IO.gets("[Y/n] Delete file: #{path_file}? ") do
      input when is_binary(input) ->
        cond do
          input == "Y\n" || input == "y\n" || input == "\n" ->
            delete(path_file)

          input == "N\n" || input == "n\n" ->
            :ok

          true ->
            ask(path_file)
        end

      _ ->
        ask(path_file)
    end
  end

  def run(path \\ File.cwd!, pattern \\ ~r/^\.DS_Store$/, mode \\ :ask) do
    case File.ls(path) do
      {:ok, file_list} ->
        for file <- file_list do
          if Regex.match?(pattern, file) do
            path_file = "#{path}/#{file}"

            case mode do
              :delete -> delete(path_file)
              :ask -> ask(path_file)
              :print -> puts_ok("Found", path_file)
              _ -> puts_error("Invalid mode: #{mode}")
            end
          end
        end

        for file <- file_list do
          abs_file = "#{path}/#{file}"
          if File.dir?(abs_file), do: run(abs_file, pattern, mode)
        end

        :ok

      {:error, reason} ->
        puts_error "Unable to list directory: #{path}, reason: #{reason}"
        :ok
    end
  end

  def puts_error(message) do
    IO.ANSI.format([:black_background, :red, :bright, "[Error] ", :white, message])
    |> IO.puts
  end

  def puts_ok(label, message) do
    IO.ANSI.format([:black_background, :green, :bright, "[#{label}] ", :white, message])
    |> IO.puts
  end
end
