defmodule Utils do

  @spec parse_codepoints(binary) :: list
  def parse_codepoints(han) do
    String.codepoints(han) |> classify_letter_number
  end

  # join letter codepoints in a word
  # ["到", "阿", "a", "s", "d", "f", "a", "a", "s", "f"]
  # transform =>
  # ["到", "阿", "asdfaasf"]
  defp classify_letter_number([]), do: []
  defp classify_letter_number([a]), do: [a]

  defp classify_letter_number(list) do
    [a, b | rest] = list
    cond do
      !is_english_number?(b) -> [a, b | classify_letter_number(rest)]
      !is_english_number?(a) -> [a | classify_letter_number([b | rest])]
      true -> classify_letter_number([a <> b | rest])
    end
  end

  defp is_english_number?(str) do
    number = if String.length(str) == 1 do
      << val :: utf8 >> = str
      val
    else
      << val :: utf8 >> = String.last(str)
      val
    end
    ( number >= 97 and number <= 122 ) or # a-z
    ( number >= 65 and number <= 90 ) or # A-Z
    ( number >= 48 and number <= 57 ) # 0-9
  end

  @list [
    ["ā", "a", 1],
    ["á", "a", 2],
    ["ǎ", "a", 3],
    ["à", "a", 4],

    ["ē", "e", 1],
    ["é", "e", 2],
    ["ě", "e", 3],
    ["è", "e", 4],

    ["ī", "i", 1],
    ["í", "i", 2],
    ["ǐ", "i", 3],
    ["ì", "i", 4],

    ["ō", "o", 1],
    ["ó", "o", 2],
    ["ǒ", "o", 3],
    ["ò", "o", 4],

    ["ǖ", "u", 1],
    ["ǘ", "u", 2],
    ["ǚ", "u", 3],
    ["ǜ", "u", 4],

    ["ū", "u", 1],
    ["ú", "u", 2],
    ["ǔ", "u", 3],
    ["ù", "u", 4],

    ["üē", "ue", 1],
    ["üé", "ue", 2],
    ["üě", "ue", 3],
    ["üè", "ue", 4]
  ]

  def pinyin_to_ascii(pinyin, withtone? \\ false) do
    Enum.map(@list, fn([k | v]) ->
      if String.contains?(pinyin, k) do
        if withtone? do
          String.replace(pinyin, k, List.first v) <> List.last v
        else
          String.replace(pinyin, k, List.first v)
        end
      else
        pinyin
      end
    end)
  end

  def pinyin_to_ascii_with_tone(pinyin) do
    pinyin_to_ascii(pinyin, true)
  end
end
