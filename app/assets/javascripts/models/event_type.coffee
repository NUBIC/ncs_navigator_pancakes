A = DS.attr

# An EventType represents an entry in the EVENT_TYPE_CL1 MDES code list.
Pancakes.EventType = DS.Model.extend
  localCode: A 'number'
  displayText: A 'string'

  # Currently, bindings to computed properties (i.e. as defined by DS.attr)
  # do not work in DS.Models.
  #
  # More information:
  # * https://github.com/emberjs/data/issues/708
  # * https://github.com/emberjs/ember.js/issues/1789
  label: Ember.computed.alias('displayText')

# vim:ts=2:sw=2:et:tw=78
