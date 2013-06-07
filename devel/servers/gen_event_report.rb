require 'json'
require 'securerandom'
require 'date'

usernames = %w(abc123 hji321 jvv234 kdc689 fgh456 bjl789)
names = ('A'..'Z').to_a

def random_choice(count, from)
  a = 0
  res = []
  s = from.dup

  while res.length < count
    res << s.delete_at(rand(s.length - 1))
  end

  res
end

a = [].tap do |a|
  20.times do
    a << {
      data_collector_usernames: random_choice(3, usernames),
      disposition_code: {
        category_code: rand(40),
        disposition: "Possibly worked",
        interim_code: rand(40).to_s
      },
      event_id: SecureRandom.uuid,
      event_type: {
        display_text: "Foo",
        local_code: "-99"
      },
      participant_first_name: names[rand(names.length - 1)],
      participant_last_name: names[rand(names.length - 1)],
      participant_id: SecureRandom.uuid,
      scheduled_date: Date.today + rand(4000)
    }
  end
end

puts({ 'events' => a, 'filters' => [] }.to_json)
