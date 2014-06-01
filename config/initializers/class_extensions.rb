# Author: Frederico Araujo (fred.the.master@gmail.com)

class FalseClass
  def to_word
    if self 
      "yes"
    else
      "no"
    end
  end
end

class TrueClass
  def to_word
    if self 
      "yes"
    else
      "no"
    end
  end
end

class Float
  def to_decimal(prec=2,sep='.')
    num = self.to_i.to_s
    dig = ((prec-(post=((self*(10**prec)).to_i%(10**prec)).to_s).size).times do post='0'+post end; post)
    return num+sep+dig
  end
end


class Fixnum
  # Converts a number to Storage size, 
  # ie. 195500.to_file_size => 195.50 KB (OS X Style)
  # or  195500.to_file_size => 190.91 KB (Linux/Windows)
  def to_file_size
    # byte can be 1024.00 for Windows/Linux style
    # or it can be 1000.00 for Mac OS X 10.6+ style
    byte = 1000.00
    case self
    when 0 
      return "0 byte"
    when 1..(byte)
      return "1 KB"
    when (byte+1)..(byte**2)
      kb = self / byte
      return "#{kb.to_decimal} KB"
    when (byte**2+1)..(byte**3)
      kb = self / byte
      mb = kb / byte
      return "#{mb.to_decimal} MB"
    else
      kb = self/byte
      mb = kb / byte
      gb = mb / byte
      return "#{gb.to_decimal} GB"
    end
  end
end

class String
  # http://rosettacode.org/wiki/Strip_control_codes_and_extended_characters_from_a_string#Ruby
  def strip_control_characters
    self.chars.inject("") do |str, char|
      unless char.ascii_only? and (char.ord < 32 or char.ord == 127)
        str << char
      end
      str
    end
  end

  def strip_control_and_extended_characters
    self.chars.inject("") do |str, char|
      if char.ascii_only? and char.ord.between?(32,126)
        str << char
      end
      str
    end
  end
end

# p s = "\ba\x00b\n\rc\fd\xc3\x7ffoo"
# p s.strip_control_characters
# p s.strip_control_and_extended_characters
