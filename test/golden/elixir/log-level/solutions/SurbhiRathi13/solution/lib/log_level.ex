defmodule LogLevel do
  def to_label(level, legacy?) do
    # Please implement the to_label/2 function
    cond do
      level==0 && legacy?==false -> :trace
      level==1 && (legacy?==true || legacy?==false) -> :debug
      level==2 && (legacy?==true || legacy?==false) -> :info
      level==3 && (legacy?==true || legacy?==false) -> :warning
      level==4 && (legacy?==true || legacy?==false) -> :error
      level==5 && legacy?==false -> :fatal
      true -> :unknown
    end
  end

  def alert_recipient(level, legacy?) do
    # Please implement the alert_recipient/2 function
    cond do
      to_label(level, legacy?) == :error || to_label(level, legacy?) == :fatal -> :ops
      to_label(level, legacy?) == :trace || to_label(level, legacy?) == :debug || to_label(level,         legacy?) == :warning || to_label(level, legacy?) == :info -> :false
      legacy?==false -> :dev2
      to_label(level, legacy?) == :unknown  -> :dev1
    end
  end
end
