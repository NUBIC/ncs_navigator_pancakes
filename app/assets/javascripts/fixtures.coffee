Pancakes.StudyLocation.FIXTURES = [
  {
    id: 'https://foobar.nubic.northwestern.edu',
    name: 'Foobar'
  },
  {
    id: 'https://qux.nubic.northwestern.edu',
    name: 'Qux',
  },
  {
    id: 'https://baz.nubic.northwestern.edu',
    name: 'Baz'
  }
]

Pancakes.EventSearch.FIXTURES = [
  {
    id: '1',
    eventTypes: '1,2,3',
    scheduledStartDate: '01/23/4567',
    scheduledEndDate: '04/10/4568',
    dataCollectors: 'Me,You,Anyone',
    studyLocations: [
      'https://foobar.nubic.northwestern.edu'
    ]
  },
  {
    id: '2',
    eventTypes: '6,7,8',
    scheduledStartDate: '11/11/1111',
    scheduledEndDate: '10/10/1222',
    dataCollectors: 'Nobody at all',
    studyLocations: [
      'https://baz.nubic.northwestern.edu',
      'https://qux.nubic.northwestern.edu'
    ]
  }
]

Pancakes.EventType.FIXTURES =
  [{"local_code":-5,"id":1394,"display_text":"Other"},{"local_code":-4,"id":1395,"display_text":"Missing in Error"},{"local_code":1,"id":1396,"display_text":"Household Enumeration"},{"local_code":2,"id":1397,"display_text":"Two Tier Enumeration"},{"local_code":3,"id":1398,"display_text":"Ongoing Tracking of Dwelling Units"},{"local_code":4,"id":1399,"display_text":"Pregnancy Screening - Provider Group"},{"local_code":5,"id":1400,"display_text":"Pregnancy Screening - High Intensity Group"},{"local_code":6,"id":1401,"display_text":"Pregnancy Screening - Low Intensity Group"},{"local_code":7,"id":1402,"display_text":"Pregnancy Probability"},{"local_code":8,"id":1403,"display_text":"PPG Follow-Up by Mailed SAQ"},{"local_code":9,"id":1404,"display_text":"Pregnancy Screening - Household Enumeration Group"},{"local_code":10,"id":1405,"display_text":"Informed Consent"},{"local_code":11,"id":1406,"display_text":"Pre-Pregnancy Visit"},{"local_code":12,"id":1407,"display_text":"Pre-Pregnancy Visit SAQ"},{"local_code":13,"id":1408,"display_text":"Pregnancy Visit 1"},{"local_code":14,"id":1409,"display_text":"Pregnancy Visit #1 SAQ"},{"local_code":15,"id":1410,"display_text":"Pregnancy Visit 2"},{"local_code":16,"id":1411,"display_text":"Pregnancy Visit #2 SAQ"},{"local_code":17,"id":1412,"display_text":"Pregnancy Visit - Low Intensity Group"},{"local_code":18,"id":1413,"display_text":"Birth"},{"local_code":19,"id":1414,"display_text":"Father"},{"local_code":20,"id":1415,"display_text":"Father Visit SAQ"},{"local_code":21,"id":1416,"display_text":"Validation"},{"local_code":22,"id":1417,"display_text":"Provider Recruitment"},{"local_code":23,"id":1418,"display_text":"3 Month"},{"local_code":24,"id":1419,"display_text":"6 Month"},{"local_code":25,"id":1420,"display_text":"6-Month Infant Feeding SAQ"},{"local_code":26,"id":1421,"display_text":"9 Month"},{"local_code":27,"id":1422,"display_text":"12 Month"},{"local_code":28,"id":1423,"display_text":"12 Month Mother Interview SAQ"},{"local_code":29,"id":1424,"display_text":"Pregnancy Screener"},{"local_code":30,"id":1425,"display_text":"18 Month"},{"local_code":31,"id":1426,"display_text":"24 Month"},{"local_code":32,"id":1427,"display_text":"Low to High Conversion"},{"local_code":33,"id":1428,"display_text":"Low Intensity Data Collection"},{"local_code":34,"id":1429,"display_text":"PBS Participant Eligibility Screening"},{"local_code":35,"id":1430,"display_text":"PBS Frame SAQ"},{"local_code":36,"id":4975,"display_text":"30 Month"},{"local_code":37,"id":4976,"display_text":"36 Month"},{"local_code":38,"id":4977,"display_text":"42 Month"}]

# vim:ts=2:sw=2:et:tw=78
