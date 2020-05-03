# typed: true
# frozen_string_literal: true

# modified from https://github.com/hanesbarbosa/alnum
module Alnum
  SYMBOLS = %w(
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    BA BE BY BO BU DA DE DY DO DU LA LE LY LO LU MA ME
    MY MO MU NA NE NY NO NU PA PE PY PO PU SA SE SI SO
    SU TA TE TI TO TU VA VE VY VO VU ZA ZE ZY ZO ZU
  ).freeze
  BASE = SYMBOLS.length

  def self.cipher(number)
    raise TypeError, "Only integers allowed" unless number.is_a? Integer

    numbers = []

    until number < BASE do
      remainder = number % BASE
      numbers << SYMBOLS[remainder]
      number = (number - remainder) / BASE
    end

    numbers << SYMBOLS[number]
    numbers.reverse.join
  end

  def self.decipher(alphanumeric)
    number, count = 0, 0

    alphanumeric.to_s.reverse.each_char() do |c|
      raise RangeError, "Code contains characters out of range: '#{c}'" if SYMBOLS.index(c).nil?
      number += SYMBOLS.index(c) * BASE**count
      count += 1
    end

    number
  end
end
