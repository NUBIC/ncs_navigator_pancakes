Pancakes.StudyLocationSelector = Ember.Checkbox.extend
  checked: (->
    @get('selection')?.contains @get('location')
  ).property('selection.@each', 'location')

  onCheckedChanged: (->
    { location: l, controller: c } = @getProperties 'location', 'controller'

    if @get 'checked'
      c.select l
    else
      c.deselect l
  ).observes('checked')

# vim:ts=2:sw=2:et:tw=78
