defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    options = parse_flags(flags)
    pattern = if options.case_insensitive, do: String.downcase(pattern), else: pattern

    files
    |> Stream.map(&process_file(&1, pattern, options, files))
    |> Stream.reject(&is_nil/1)
    |> Enum.join("\n")
    |> then(&if(&1 == "", do: &1, else: &1 <> "\n"))
  end

  defp parse_flags(flags) do
    %{
      line_numbers: "-n" in flags,
      file_names_only: "-l" in flags,
      case_insensitive: "-i" in flags,
      invert_match: "-v" in flags,
      entire_line: "-x" in flags
    }
  end

  defp process_file(file, pattern, options, files) do
    with {:ok, content} <- File.read(file),
         lines = String.split(content, "\n"),
         matching_lines = filter_lines(lines, pattern, options),
         true <- matching_lines != [] do
      if options.file_names_only, do: file, else: format_output(matching_lines, file, options, files)
    else
      _ -> nil
    end
  end

  defp filter_lines(lines, pattern, options) do
    lines
    |> Enum.with_index(1)
    |> Enum.filter(fn {line, _} ->
      line = if options.case_insensitive, do: String.downcase(line), else: line
      match? = if options.entire_line, do: line == pattern, else: String.contains?(line, pattern)
      (options.invert_match && line != "" && !match?) || (!options.invert_match && match?)
    end)
  end

  defp format_output(matching_lines, file, options, files) do
    show_filename = length(files) > 1

    matching_lines
    |> Enum.map_join("\n", fn {line, line_num} ->
      [
        if(show_filename, do: "#{file}:", else: ""),
        if(options.line_numbers, do: "#{line_num}:", else: ""),
        line
      ]
      |> Enum.join()
    end)
  end
end