class CreateEventSearches < ActiveRecord::Migration
  def change
    create_table :event_searches do |t|
      t.text :json
      t.string :username
      t.timestamps
    end
  end
end
