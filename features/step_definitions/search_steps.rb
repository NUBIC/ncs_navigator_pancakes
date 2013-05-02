Given(/^I start an event search with the parameters$/) do |table|
  step "I start an event search"
  step "I enter the parameters", table
end

When(/^I start an event search$/) do
  visit '/event_searches/new'
end

When(/^I enter the parameters$/) do |table|
  table.raw.each do |key, value|
    case key
    when 'event type'
      find('.event-type input').set("#{value}\n")
    when 'start date'
      find('.scheduled-date.start input').set(value)
    when 'end date'
      find('.scheduled-date.end input').set(value)
    when 'done by'
      find('.done-by input').set("#{value}\n")
    else raise "Unknown key #{key}"
    end
  end
end

Then(/^I see the search criteria$/) do |table|
  actual = []

  table.raw.each do |key, expected|
    elem = case key
           when 'event type'
             find('.event-type .tag-label', :text => expected).text
           when 'start date'
             find(".scheduled-date.start input[@value='#{expected}']").value
           when 'end date'
             find(".scheduled-date.end input[@value='#{expected}']").value
           when 'done by'
             find('.done-by .tag-label', :text => expected).text
           else raise "Unknown key #{key}"
           end

    if elem
      actual << [key, elem]
    end
  end

  table.diff!(actual)
end

Then(/^my search involves the study locations$/) do |table|
  actual = [['name', 'will search']]

  table.hashes.each do |h|
    actual << [h['name'], page.has_checked_field?(h['name']) ? 'yes' : 'no']
  end

  table.diff!(actual)
end
