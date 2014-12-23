class String
  ##
  # Returns hash value by using a string as a guide to open hash inside hash
  #
  # @param hash [Hash]
  # @param separator [String] a character which indicates different parts of the given string for hash access
  # @return [?] hash value
  # @example
  #   string = 'Response/Amount_Balance'
  #   hash = { "Response" => { "Amount_Balance" => 5 } }
  #   result = string.hash_value(hash, '/')
  #   # 5
  def hash_value(hash, separator)
    array = split(separator)
    array.inject(hash) { |result, el| result[el] }
  end
end
