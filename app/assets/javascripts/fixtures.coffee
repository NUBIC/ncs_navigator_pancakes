Pancakes.CasesInstance.FIXTURES = [
  {
    id: '1',
    url: 'https://foobar.nubic.northwestern.edu',
    name: 'Foobar',
    active: true
  },
  {
    id: '2',
    url: 'https://qux.nubic.northwestern.edu',
    name: 'Qux',
    active: false
  },
  {
    id: '3',
    url: 'https://baz.nubic.northwestern.edu',
    name: 'Baz',
    active: true
  }
]

Pancakes.EventSearch.FIXTURES = [
  {
    id: '1',
    eventTypes: '1,2,3',
    scheduledStartDate: '01/23/4567',
    scheduledEndDate: '04/10/4568',
    dataCollectors: 'Me,You,Anyone'
  },
  {
    id: '2',
    eventTypes: '6,7,8',
    scheduledStartDate: '11/11/1111',
    scheduledEndDate: '10/10/1222',
    dataCollectors: 'Nobody at all'
  }
]
# vim:ts=2:sw=2:et:tw=78
