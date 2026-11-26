defmodule LogLevel do
  def to_label(level, _legacy = true) do
    case level do
      0 -> :unknown
      5 -> :unknown
      _ -> to_label(level, false)
    end
  end

  def to_label(level, _legacy = false) do
    case level do
      0 -> :trace
      1 -> :debug
      2 -> :info
      3 -> :warning
      4 -> :error
      5 -> :fatal
      _ -> :unknown
    end
  end

  def alert_recipient(level, legacy) do
    case to_label(level, legacy) do
      label     when label in [:error, :fatal]  -> :ops
      :unknown  when legacy                     -> :dev1
      :unknown  when not legacy                 -> :dev2
      # pass through
      _ -> false
    end
  end
end
