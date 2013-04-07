#= require jquery.ui.core
#= require jquery.ui.position

SelectedTags = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['ui-widget-content', 'selected-tags']

  itemViewClass: Ember.View.extend
    classNames: ['selected-tag']
    template: Ember.Handlebars.compile '''
      {{view.content.label}}
      <span class="remove-tag">&#x232b;</span>
    '''

    click: (e) ->
      if $(e.target).hasClass('remove-tag')
        @get('parentView.parentView').willRemoveSelection @get('content')

# ----------------------------------------------------------------------------

Entry = Ember.TextField.extend
  classNames: ['ui-widget', 'tag-entry']
  wantsCandidates: false

  hasText: (->
    @get('value.length') > 0
  ).property('value')

  keyDown: (e) ->
    pv = @get 'parentView'

    switch e.keyCode
      when $.ui.keyCode.TAB, $.ui.keyCode.ENTER
        @set 'wantsCandidates', false
        pv.willAddSelection()

        if @get 'hasText'
          @set 'value', ''
          e.preventDefault()
      when $.ui.keyCode.UP
        pv.selectPreviousCandidate() if @get 'wantsCandidates'
        @set 'wantsCandidates', true
      when $.ui.keyCode.DOWN
        pv.selectNextCandidate() if @get 'wantsCandidates'
        @set 'wantsCandidates', true
      when $.ui.keyCode.BACKSPACE
        if !@get 'hasText'
          pv.willRemoveLastSelection()
          @set 'wantsCandidates', false
          e.preventDefault()
      else
        @set 'wantsCandidates', true

# ----------------------------------------------------------------------------

CandidateList = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['ui-widget-content', 'ui-autocomplete', 'ui-menu']
  classNameBindings: ['isVisible']
  currentIndex: 0

  currentItem: (->
    @get('content')?.objectAt @get('currentIndex')
  ).property('content.@each', 'currentIndex')

  itemViewClass: Ember.View.extend
    classNames: ['ui-menu-item']
    classNameBindings: ['isSelected']
    template: Ember.Handlebars.compile '<a href="#">{{view.content.label}}</a>'

    isSelected: (->
      'ui-state-focus' if @get('content') == @get('parentView.currentItem')
    ).property('parentView.currentItem')

  cycleIndex: (->
    ci = @get 'currentIndex'

    if ci < 0
      @set 'currentIndex', @get('content.length') - 1
    else if ci >= @get('content.length')
      @set 'currentIndex', 0
  ).observes('currentIndex', 'content.length')

  ensureVisible: (->
    @scrollToCurrent() if @hasScroll()
  ).observes('currentIndex')

  scrollToCurrent: ->
    el = @$()
    view = @get('childViews').objectAt(@get('currentIndex'))?.$()

    return unless view

    bt = parseFloat(el.css('borderTopWidth')) || 0
    pt = parseFloat(el.css('paddingTop')) || 0
    offset = view.offset().top - el.offset().top - bt - pt
    scroll = el.scrollTop()
    height = el.height()
    viewHeight = view.height()

    if offset < 0
      el.scrollTop(scroll + offset)
    else if (offset + viewHeight > height)
      el.scrollTop(scroll + offset - height + viewHeight)

  hasScroll: ->
    el = @$()

    el.outerHeight() < el.prop 'scrollHeight'

# ----------------------------------------------------------------------------

Pancakes.Tagger = Ember.ContainerView.extend
  classNames: ['ui-widget', 'tagger']
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
