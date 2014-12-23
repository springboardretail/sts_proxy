
##
#
class Guides::GuidesRetriever
  class << self
    ##
    #
    def get_guides(action)
      eval("Guides::#{action.to_s.classify}.new('#{action}')")
    end
  end
end