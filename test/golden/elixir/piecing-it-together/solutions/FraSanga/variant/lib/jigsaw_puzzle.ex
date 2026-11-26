defmodule JigsawPuzzle do
  @doc """
  Fill in missing jigsaw puzzle details from partial data
  """

  @type format() :: :landscape | :portrait | :square
  @type t() :: %__MODULE__{
          pieces: pos_integer() | nil,
          rows: pos_integer() | nil,
          columns: pos_integer() | nil,
          format: format() | nil,
          aspect_ratio: float() | nil,
          border: pos_integer() | nil,
          inside: pos_integer() | nil
        }

  defstruct [:pieces, :rows, :columns, :format, :aspect_ratio, :border, :inside]

  @spec data(jigsaw_puzzle :: JigsawPuzzle.t()) ::
          {:ok, JigsawPuzzle.t()} | {:error, String.t()}
  def data(%JigsawPuzzle{
    pieces: pieces,
    rows: nil,
    columns: nil,
    format: nil,
    aspect_ratio: aspect_ratio,
    border: nil,
    inside: nil
  }) do
    rows = pieces / aspect_ratio |> :math.sqrt() |> round()
    columns = rows * aspect_ratio |> round()
    border = 2 * (rows + columns - 2)
    inside = pieces - border

    format = cond do
      rows < columns -> :landscape
      rows > columns -> :portrait
      true -> :square
    end

    {:ok, %JigsawPuzzle{
      pieces: pieces,
      rows: rows,
      columns: columns,
      format: format,
      aspect_ratio: aspect_ratio,
      border: border,
      inside: inside
    }}
  end

  def data(%JigsawPuzzle{
    pieces: nil,
    rows: rows,
    columns: nil,
    format: :square,
    aspect_ratio: nil,
    border: nil,
    inside: nil
  }) do
    columns = rows
    pieces = rows * columns
    aspect_ratio = columns / rows
    border = 2 * (rows + columns - 2)
    inside = pieces - border
    {:ok, %JigsawPuzzle{
      pieces: pieces,
      rows: rows,
      columns: columns,
      format: :square,
      aspect_ratio: aspect_ratio,
      border: border,
      inside: inside
    }}
  end

  def data(%JigsawPuzzle{
    pieces: nil,
    rows: nil,
    columns: nil,
    format: nil,
    aspect_ratio: aspect_ratio,
    border: nil,
    inside: inside
  }) do
    if aspect_ratio == 1 do
      rows = (:math.sqrt(inside) |> round()) + 2
      columns = rows
      pieces = rows * columns
      border = 2 * (rows + columns - 2)
      {:ok, %JigsawPuzzle{
        pieces: pieces,
        rows: rows,
        columns: columns,
        format: :square,
        aspect_ratio: aspect_ratio,
        border: border,
        inside: inside
      }}
    else
      {:error, "Insufficient data"}
    end
  end

  def data(%JigsawPuzzle{
    pieces: nil,
    rows: rows,
    columns: nil,
    format: nil,
    aspect_ratio: aspect_ratio,
    border: nil,
    inside: nil
  }) do
    columns = round(rows * aspect_ratio)
    format = :landscape
    pieces = rows * columns
    border = 2 * (rows + columns + 2)
    inside = pieces - border

    {:ok, %JigsawPuzzle{
      pieces: pieces,
      rows: rows,
      columns: columns,
      format: format,
      aspect_ratio: aspect_ratio,
      border: border,
      inside: inside
    }}
  end

  def data(%JigsawPuzzle{
    pieces: _,
    rows: nil,
    columns: nil,
    format: format,
    aspect_ratio: nil,
    border: nil,
    inside: nil
  }) when format != :square do
    {:error, "Insufficient data"}
  end

  def data(%JigsawPuzzle{
    pieces: pieces,
    rows: nil,
    columns: nil,
    format: format,
    aspect_ratio: nil,
    border: border,
    inside: nil
  }) do
    inside = pieces - border
    len = (:math.sqrt(:math.pow((border / 2) + 2, 2) - 4 * pieces) + ((border / 2) + 2)) / 2 |> round()
    cond do
      format == :landscape ->
        {:ok, %JigsawPuzzle{
          pieces: pieces,
          columns: pieces / len,
          rows: len,
          format: format,
          aspect_ratio: len / (pieces / len),
          border: border,
          inside: inside
        }}
      format == :portrait ->
        {:ok, %JigsawPuzzle{
          pieces: pieces,
          rows: len,
          columns: pieces / len,
          format: format,
          aspect_ratio: (pieces / len) / len,
          border: border,
          inside: inside
        }}
      format == :square ->
        {:ok, %JigsawPuzzle{
          pieces: pieces,
          rows: len,
          columns: len,
          format: format,
          aspect_ratio: 1,
          border: border,
          inside: inside
        }}
    end
  end

  def data(%JigsawPuzzle{
    pieces: nil,
    rows: rows,
    columns: columns,
    format: format,
    aspect_ratio: nil,
    border: nil,
    inside: nil
  }) do
    cond do
      format == :landscape and rows > columns ->
        {:error, "Contradictory data"}
      format == :portrait and rows < columns ->
        {:error, "Contradictory data"}
      format == :square and rows != columns ->
        {:error, "Contradictory data"}
      true ->
        {:ok, %JigsawPuzzle{
          pieces: rows * columns,
          rows: rows,
          columns: columns,
          format: format,
          aspect_ratio: columns / rows,
          border: 2 * (rows + columns - 2),
          inside: (rows * columns) - (2 * (rows + columns - 2))
        }}
    end
  end
end
