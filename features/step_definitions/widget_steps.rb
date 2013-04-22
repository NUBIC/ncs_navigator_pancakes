When(/^I uncheck "(.*?)"$/) do |spec|
  uncheck spec
end

When(/^I click "(.*?)"$/) do |spec|
  click_link_or_button spec
end

Then(/^I see "(.*?)"$/) do |text|
  page.should have_content(text)
end
