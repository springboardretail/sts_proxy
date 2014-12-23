class String
  def hash_value(hash, separator)
    array = split(separator)
    array.inject(hash) { |result, el| result[el] }
  end
end