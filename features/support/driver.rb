Capybara.default_driver = :selenium

Around('@api') do |scenario, block|
  begin
    Capybara.current_driver = :rack_test
    block.call
  ensure
    Capybara.use_default_driver
  end
end
