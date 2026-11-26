defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part({:def,  _, [fun | _]} = ast, acc), do: {ast, decode_fun(fun, acc)}
  def decode_secret_message_part({:defp, _, [fun | _]} = ast, acc), do: {ast, decode_fun(fun, acc)}
  def decode_secret_message_part(                        ast, acc), do: {ast, acc}

  defp decode_fun({:when, _, [fun | _]}, acc), do: decode_fun(fun, acc)
  defp decode_fun({_,     _, nil},       acc), do: [""                                           | acc]
  defp decode_fun({name,  _, args},      acc), do: [String.slice("#{name}", 0, Enum.count(args)) | acc]

  def decode_secret_message(string) do
    to_ast(string)
    |> Macro.prewalk([], &decode_secret_message_part*2)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.join()
  end
end
