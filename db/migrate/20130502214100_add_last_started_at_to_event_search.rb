class AddLastStartedAtToEventSearch < ActiveRecord::Migration
  def change
    add_column :event_searches, :last_started_at, :timestamp
  end
end
