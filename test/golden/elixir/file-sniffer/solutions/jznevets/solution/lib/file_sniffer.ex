defmodule FileSniffer do
  @exe_type "application/octet-stream"
  @exe_sig <<0x7F, 0x45, 0x4C, 0x46>>
  @bmp_type "image/bmp"
  @bmp_sig <<0x42, 0x4D>>
  @png_type "image/png"
  @png_sig <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>
  @jpg_type "image/jpg"
  @jpg_sig <<0xFF, 0xD8, 0xFF>>
  @gif_type "image/gif"
  @gif_sig <<0x47, 0x49, 0x46>>

  def type_from_extension("exe"), do: @exe_type
  def type_from_extension("bmp"), do: @bmp_type
  def type_from_extension("png"), do: @png_type
  def type_from_extension("jpg"), do: @jpg_type
  def type_from_extension("gif"), do: @gif_type
  def(type_from_extension(_), do: nil)

  def type_from_binary(<<0x7F, _::binary>> = file),
    do: do_type_from_binary(file, @exe_sig, @exe_type)

  def type_from_binary(<<0x42, _::binary>> = file),
    do: do_type_from_binary(file, @bmp_sig, @bmp_type)

  def type_from_binary(<<0x89, _::binary>> = file),
    do: do_type_from_binary(file, @png_sig, @png_type)

  def type_from_binary(<<0xFF, _::binary>> = file),
    do: do_type_from_binary(file, @jpg_sig, @jpg_type)

  def type_from_binary(<<0x47, _::binary>> = file),
    do: do_type_from_binary(file, @gif_sig, @gif_type)

  def type_from_binary(_), do: nil

  defp do_type_from_binary(
         <<first::binary-size(1), file_rest::binary>>,
         <<first::binary-size(1), sig_rest::binary>>,
         type
       ) do
    do_type_from_binary(file_rest, sig_rest, type)
  end

  defp do_type_from_binary(_, <<>>, type), do: type

  defp do_type_from_binary(_, _, _), do: nil

  def verify(file_binary, extension) do
    type = type_from_extension(extension)

    cond do
      nil == type ->
        {:error, "Warning, file format and file extension do not match."}

      type == type_from_binary(file_binary) ->
        {:ok, type}

      true ->
        {:error, "Warning, file format and file extension do not match."}
    end
  end
end
