class UuidsForEventSearches < ActiveRecord::Migration
  def up
    remove_column :event_searches, :id
    add_column :event_searches, :uuid, :string, :limit => 36, :null => false, :default => '00000000-0000-0000-0000-000000000000'
    add_index :event_searches, :uuid, :unique => true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
