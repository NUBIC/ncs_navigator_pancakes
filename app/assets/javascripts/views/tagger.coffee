#= require jquery.ui.core
#= require jquery.ui.position

SelectedTags = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['ui-widget-content']

  itemViewClass: Ember.View.extend
    template: Ember.Handlebars.compile '''
      {{view.content.label}}
      <span class="remove-tag">&#x232b;</span>
    '''

    click: (e) ->
      if $(e.target).hasClass('remove-tag')
        @get('parentView.parentView').willRemoveSelection @get('content')

# ----------------------------------------------------------------------------

Entry = Ember.TextField.extend
  classNames: ['ui-widget']
  wantsCandidates: false

  hasText: (->
    @get('value.length') > 0
  ).property('value')

  keyDown: (e) ->
    @set 'wantsCandidates', true
    pv = @get 'parentView'

    switch e.keyCode
      when $.ui.keyCode.TAB, $.ui.keyCode.ENTER
        @set 'wantsCandidates', false

        if @get 'hasText'
          pv.willAddSelection()
          @set 'value', ''
          e.preventDefault()
      when $.ui.keyCode.UP
        pv.selectPreviousCandidate()
        @set 'wantsCandidates', true
      when $.ui.keyCode.DOWN
        pv.selectNextCandidate()
        @set 'wantsCandidates', true
      when $.ui.keyCode.BACKSPACE
        if !@get 'hasText'
          pv.willRemoveLastSelection()
          @set 'wantsCandidates', false
          e.preventDefault()

# ----------------------------------------------------------------------------

CandidateList = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['ui-widget-content']
  classNameBindings: ['isVisible']
  currentIndex: 0

  currentItem: (->
    @get('content')?.objectAt @get('currentIndex')
  ).property('content.@each', 'currentIndex')

  itemViewClass: Ember.View.extend
    classNameBindings: ['isSelected']
    template: Ember.Handlebars.compile '{{view.content.label}}'

    isSelected: (->
      @get('content') == @get('parentView.currentItem')
    ).property('parentView.currentItem')

  cycleIndex: (->
    ci = @get 'currentIndex'

    if ci < 0
      @set 'currentIndex', @get('content.length') - 1
    else if ci >= @get('content.length')
      @set 'currentIndex', 0
  ).observes('currentIndex', 'content.length')

# ----------------------------------------------------------------------------

Pancakes.Tagger = Ember.ContainerView.extend
  childViews: ['selections', 'entry', 'candidateList']

  selections: SelectedTags.extend
    contentBinding: 'parentView.selection'

  entry: Entry.extend
    valueBinding: 'parentView.criterion'
    placeholderBinding: 'parentView.placeholder'

  candidateList: CandidateList.extend
    contentBinding: 'parentView.candidates'
    isVisibleBinding: 'parentView.entry.wantsCandidates'

    reposition: (->
      @$().position
        of: @get('parentView.entry').$()
        my: 'left top'
        at: 'left bottom'
        collision: 'flip flip'
    ).observes('isVisible')

    resetCurrentIndex: (->
      @set('currentIndex', 0) if !@get('isVisible')
    ).observes('isVisible')

  willAddSelection: ->
    item = @get 'candidateList.currentItem'

    if @get('controller').canAddSelection @get('selections.content'), item
      @get('controller').addSelection @get('selections.content'), item

  willRemoveSelection: (item) ->
    if @get('controller').canRemoveSelection @get('selections.content'), item
      @get('controller').removeSelection @get('selections.content'), item

  willRemoveLastSelection: ->
    @willRemoveSelection @get('selections.content.lastObject')

  selectPreviousCandidate: ->
    @get('candidateList').decrementProperty 'currentIndex', 1

  selectNextCandidate: ->
    @get('candidateList').incrementProperty 'currentIndex', 1

# vim:ts=2:sw=2:et:tw=78
