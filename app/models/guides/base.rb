##
# Base for Guides class, which is used to store information about:
# 1. How received from SR JSON should be renamed to fit remote service action needs - input
# 2. What data must be sent back from received response from a remote service back to SR - output
class Guides::Base < Struct.new(:type)
  extend AbstractMethods
  abstract_methods :input, :output

  def find_input_result(key)
    find_input(key)[:result]
  end

  def find_input(key)
    input.find { |hash| hash[:input] == key || hash[:input_fallback] == key }
  end
end
