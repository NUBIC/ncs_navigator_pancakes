When(/^I start an event search$/) do
  visit '/event_searches/new'
end

Then(/^all study locations are selected$/) do
  page.should have_checked_field('Foobar')
  page.should have_checked_field('Qux')
  page.should have_checked_field('Baz')
end

