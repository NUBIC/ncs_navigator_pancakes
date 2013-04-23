##
# When users submit searches to Pancakes, the parameters of those searches are
# saved in an EventSearch instance.  After the instance is persisted to the
# database, the instance is passed to the search processors.
class EventSearch < ActiveRecord::Base
  serialize :json
  set_primary_key :uuid
end

# vim:ts=2:sw=2:et:tw=78
