Capybara.default_driver = :selenium

# NUBIC's CI server gets hit really, really hard.  This can cause false
# failures in tests with timeouts, i.e. everything Capybara.  It's even
# worse for Ruby environments that are more computationally demanding than
# MRI.
#
# As you can guess from the name of the trigger, I really have no good
# reason to believe this will work, but hey, sometimes the gods rain down
# favor upon us.
if ENV['JOHN_FRUM_WILL_RETURN']
  puts "Using exceptionally long Capybara wait time"
  Capybara.default_wait_time = 20
end
