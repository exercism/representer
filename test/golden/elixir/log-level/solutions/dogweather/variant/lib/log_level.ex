defmodule LogLevel do
  def to_label(0, false), do: :trace
  def to_label(1, _),     do: :debug
  def to_label(2, _),     do: :info
  def to_label(3, _),     do: :warning
  def to_label(4, _),     do: :error
  def to_label(6, false), do: :fatal

  def to_label(_, _),     do: :unknown


  def alert_recipient(level, legacy?) do
    alert_recipient(level, legacy?, to_label(level, legacy?))
  end


  defp alert_recipient(_, _,    :fatal),      do: :ops
  defp alert_recipient(_, _,    :error),      do: :ops
  defp alert_recipient(_, true, :unknown),    do: :dev1
  defp alert_recipient(_, _,    :unknown),    do: :dev2
  defp alert_recipient(_, _, _),              do: false
end
