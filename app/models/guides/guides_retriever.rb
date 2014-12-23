##
# Utility class for handy guides retrieving
class Guides::GuidesRetriever
  class << self
    ##
    # Retrieves guides for a certain action
    #
    # @param action [String]
    # @return [Guides]
    def get_guides(action)
      eval("Guides::#{action.to_s.classify}.new('#{action}')")
    end
  end
end
