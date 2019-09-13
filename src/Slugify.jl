# Slugify.jl -- A library that simplifies a text to an ASCII subset
# By: Emmanuel Raviart <emmanuel@raviart.com>
#
# Copyright (C) 2015 Emmanuel Raviart
# https://github.com/eraviart/Slugify.jl
#
# This file is part of Slugify.jl.
#
# The Slugify.jl package is licensed under the MIT "Expat" License.


module Slugify


export slugify


ASCII_TRANSLATIONS = Dict{Char,String}(
  ' ' => " ",  # U+00A0 NO-BREAK SPACE
  'À' => "A",  # U+00C0 LATIN CAPITAL LETTER A WITH GRAVE
  'Á' => "A",  # U+00C1 LATIN CAPITAL LETTER A WITH ACUTE
  'Â' => "A",  # U+00C2 LATIN CAPITAL LETTER A WITH CIRCUMFLEX
  'Ã' => "A",  # U+00C3 LATIN CAPITAL LETTER A WITH TILDE
  'Ä' => "A",  # U+00C4 LATIN CAPITAL LETTER A WITH DIAERESIS
  'Å' => "A",  # U+00C5 LATIN CAPITAL LETTER A WITH RING ABOVE
  'Æ' => "Ae",  # U+00C6 LATIN CAPITAL LETTER AE
  'Ç' => "C",  # U+00C7 LATIN CAPITAL LETTER C WITH CEDILLA
  'È' => "E",  # U+00C8 LATIN CAPITAL LETTER E WITH GRAVE
  'É' => "E",  # U+00C9 LATIN CAPITAL LETTER E WITH ACUTE
  'Ê' => "E",  # U+00CA LATIN CAPITAL LETTER E WITH CIRCUMFLEX
  'Ë' => "E",  # U+00CB LATIN CAPITAL LETTER E WITH DIAERESIS
  'Ì' => "I",  # U+00CC LATIN CAPITAL LETTER I WITH GRAVE
  'Í' => "I",  # U+00CD LATIN CAPITAL LETTER I WITH ACUTE
  'Î' => "I",  # U+00CE LATIN CAPITAL LETTER I WITH CIRCUMFLEX
  'Ï' => "I",  # U+00CF LATIN CAPITAL LETTER I WITH DIAERESIS
  'Ð' => "Th",  # U+00D0 LATIN CAPITAL LETTER ETH
  'Ñ' => "N",  # U+00D1 LATIN CAPITAL LETTER N WITH TILDE
  'Ò' => "O",  # U+00D2 LATIN CAPITAL LETTER O WITH GRAVE
  'Ó' => "O",  # U+00D3 LATIN CAPITAL LETTER O WITH ACUTE
  'Ô' => "O",  # U+00D4 LATIN CAPITAL LETTER O WITH CIRCUMFLEX
  'Õ' => "O",  # U+00D5 LATIN CAPITAL LETTER O WITH TILDE
  'Ö' => "O",  # U+00D6 LATIN CAPITAL LETTER O WITH DIAERESIS
  'Ø' => "O",  # U+00D8 LATIN CAPITAL LETTER O WITH STROKE
  'Ù' => "U",  # U+00D9 LATIN CAPITAL LETTER U WITH GRAVE
  'Ú' => "U",  # U+00DA LATIN CAPITAL LETTER U WITH ACUTE
  'Û' => "U",  # U+00DB LATIN CAPITAL LETTER U WITH CIRCUMFLEX
  'Ü' => "U",  # U+00DC LATIN CAPITAL LETTER U WITH DIAERESIS
  'Ý' => "Y",  # U+00DD LATIN CAPITAL LETTER Y WITH ACUTE
  'Þ' => "th",  # U+00DE LATIN CAPITAL LETTER THORN
  'ß' => "ss",  # U+00DF LATIN SMALL LETTER SHARP S
  'à' => "a",  # U+00E0 LATIN SMALL LETTER A WITH GRAVE
  'á' => "a",  # U+00E1 LATIN SMALL LETTER A WITH ACUTE
  'â' => "a",  # U+00E2 LATIN SMALL LETTER A WITH CIRCUMFLEX
  'ã' => "a",  # U+00E3 LATIN SMALL LETTER A WITH TILDE
  'ä' => "a",  # U+00E4 LATIN SMALL LETTER A WITH DIAERESIS
  'å' => "a",  # U+00E5 LATIN SMALL LETTER A WITH RING ABOVE
  'æ' => "ae",  # U+00E6 LATIN SMALL LETTER AE
  'ç' => "c",  # U+00E7 LATIN SMALL LETTER C WITH CEDILLA
  'è' => "e",  # U+00E8 LATIN SMALL LETTER E WITH GRAVE
  'é' => "e",  # U+00E9 LATIN SMALL LETTER E WITH ACUTE
  'ê' => "e",  # U+00EA LATIN SMALL LETTER E WITH CIRCUMFLEX
  'ë' => "e",  # U+00EB LATIN SMALL LETTER E WITH DIAERESIS
  'ì' => "i",  # U+00EC LATIN SMALL LETTER I WITH GRAVE
  'í' => "i",  # U+00ED LATIN SMALL LETTER I WITH ACUTE
  'î' => "i",  # U+00EE LATIN SMALL LETTER I WITH CIRCUMFLEX
  'ï' => "i",  # U+00EF LATIN SMALL LETTER I WITH DIAERESIS
  'ð' => "th",  # U+00F0 LATIN SMALL LETTER ETH
  'ñ' => "n",  # U+00F1 LATIN SMALL LETTER N WITH TILDE
  'ò' => "o",  # U+00F2 LATIN SMALL LETTER O WITH GRAVE
  'ó' => "o",  # U+00F3 LATIN SMALL LETTER O WITH ACUTE
  'ô' => "o",  # U+00F4 LATIN SMALL LETTER O WITH CIRCUMFLEX
  'õ' => "o",  # U+00F5 LATIN SMALL LETTER O WITH TILDE
  'ö' => "o",  # U+00F6 LATIN SMALL LETTER O WITH DIAERESIS
  'ø' => "o",  # U+00F8 LATIN SMALL LETTER O WITH STROKE
  'ù' => "u",  # U+00F9 LATIN SMALL LETTER U WITH GRAVE
  'ú' => "u",  # U+00FA LATIN SMALL LETTER U WITH ACUTE
  'û' => "u",  # U+00FB LATIN SMALL LETTER U WITH CIRCUMFLEX
  'ü' => "u",  # U+00FC LATIN SMALL LETTER U WITH DIAERESIS
  'ý' => "y",  # U+00FD LATIN SMALL LETTER Y WITH ACUTE
  'þ' => "th",  # U+00FE LATIN SMALL LETTER THORN
  'ÿ' => "y",  # U+00FF LATIN SMALL LETTER Y WITH DIAERESIS
  'Œ' => "Oe",  # U+0152 LATIN CAPITAL LIGATURE OE
  'œ' => "oe",  # U+0153 LATIN SMALL LIGATURE OE
  '‘' => "'",  # U+2018 LEFT SINGLE QUOTATION MARK
  '’' => "'",  # U+2019 RIGHT SINGLE QUOTATION MARK
)


function char_to_ascii(unicode_char::Char)
  """Convert an unicode character to a string of several ASCII characters."""
  return get(ASCII_TRANSLATIONS, unicode_char) do
    return unicode_char < Char(0x80) ? string(unicode_char) : ""
  end
end


function slugify(string::AbstractString; separator::Char = '-', transform::Function = lowercase)
  """Simplify a string, converting it to an ASCII subset of 0-9, A-Z, a-z & separators."""
  simplified = join([
    slugify_char(char, separator = separator, transform = transform)
    for char in string
  ], "")
  return join(split(simplified, separator, keepempty=false), separator)
end


function slugify_char(unicode_char::Char; separator::Char = '-', transform::Function = lowercase)
  """Convert an unicode character to a subset of ASCII characters or an empty string.

  The result can be composed of several characters (for example, 'œ' becomes 'oe').
  """
  return map(transform(char_to_ascii(unicode_char))) do char
    return char in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" ? char : separator
  end
end


end # module
