#= require sjcl

Pancakes.Adapter = DS.RESTAdapter.extend
  namespace: 'api/v1'
  generateIdForRecord: (store, record) ->
    # A v4 UUID requires 128 bits of random numbers; randomWords generates
    # 32-bit quantities.
    #
    # From RFC 4122, section 4.4:
    #  o  Set the two most significant bits (bits 6 and 7) of the
    #     clock_seq_hi_and_reserved to zero and one, respectively.
    #  o  Set the four most significant bits (bits 12 through 15) of the
    #     time_hi_and_version field to the 4-bit version number from
    #     Section 4.1.3.
    #  o  Set all the other bits to randomly (or pseudo-randomly) chosen
    #     values.
    #
    # To satisfy this, we start out with 128 bits' worth of random numbers,
    # then proceed in reverse order, twiddling what we need.
    words = sjcl.random.randomWords(4)
    words[1] = (words[1] & 0xFFFF0FFF) | 0x00004000
    words[2] = (words[2] & 0x3FFFFFFF) | 0x80000000
    x = sjcl.codec.hex.fromBits(words)
    "#{x.slice(0, 8)}-#{x.slice(8, 12)}-#{x.slice(12, 16)}-#{x.slice(16, 20)}-#{x.slice(20)}"

  # In Pancakes, create and update are the same operation.  However, we still
  # need to call @didCreateRecord instead of @didUpdateRecord.
  createRecord: (store, type, record) ->
    root = @rootForType type
    data = {}
    data[root] = @serialize record, includeId: true

    @ajax @buildURL(root, record.get('id')), 'PUT',
      data: data,
      success: (json) ->
        Ember.run this, ->
          @didCreateRecord store, type, record, json
      error: (xhr) ->
        @didError store, type, record, xhr

  # Set up custom primary keys.
  #
  # FYI, Ember Data passes constants in the type parameter, not strings.  This
  # is a bit odd because Adapter.map receives strings.  Whatever.
  serializer: DS.RESTSerializer.extend
    primaryKey: (type, record) ->
      switch type
        when Pancakes.EventType     then 'local_code'
        when Pancakes.DataCollector then 'username'
        when Pancakes.StudyLocation then 'url'
        else 'id'

Pancakes.Adapter.configure 'plurals',
  event_search: 'event_searches'

Pancakes.Adapter.map 'Pancakes.EventSearch',
  eventTypes:
    embedded: 'always'
  dataCollectors:
    embedded: 'always'
  studyLocations:
    embedded: 'always'

# vim:ts=2:sw=2:et:tw=78
