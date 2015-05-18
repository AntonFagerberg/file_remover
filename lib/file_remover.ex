defmodule FileRemover do
  def run(path \\ File.cwd!, pattern \\ ~r/^\.DS_Store$/) do
    case File.ls(path) do
      {:ok, file_list} ->
        for file <- file_list do
          if Regex.match?(pattern, file) do
            path_file = "#{path}/#{file}"
            
            case File.rm(path_file) do
              :ok -> 
                IO.ANSI.format([:black_background, :green, :bright, "[Ok] ", :white, path_file]) 
                |> IO.puts
              
              {:error, reason} ->
                puts_warning "Unable to remove file: #{path_file}, reason: #{reason}"
            end
          end
        end
        
        for file <- file_list do
          abs_file = "#{path}/#{file}"
          if File.dir?(abs_file), do: run(abs_file)
        end
        
        :ok
      
      {:error, reason} -> 
        puts_warning "Unable to list directory: #{path}, reason: #{reason}"
    end
  end
  
  def puts_warning(message) do
    IO.ANSI.format([:black_background, :red, :bright, "[Error] ", :white, message])
    |> IO.puts
  end
end
