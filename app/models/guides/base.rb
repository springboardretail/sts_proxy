##
# Base for Guides class, which is used to store information about:
# 1. How received from SR JSON should be renamed to fit remote service action needs - input
# 2. What data must be sent back from received response from a remote service back to SR - output
class Guides::Base < Struct.new(:type)
  extend AbstractMethods
  abstract_methods :input, :output
end