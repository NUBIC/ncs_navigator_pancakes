##
# A Store caches model instances.  It's meant to be used for models whose
# lifetime is a Pancakes process' lifetime.  It SHOULD NOT be used for large
# collections of short-lived models, such as datasets from StudyLocations.
#
# Users of this module MUST implement #request.  The #request method MUST
#
# 1. Accept a maximum of zero arguments.
# 2. Return an enumerable.
# 3. Cache its query result in the @response instance variable.
#
# #request SHOULD freeze the returned numerable.
module Store
  def reload
    @response = nil
    request
  end

  def all
    request.value
  end
end
