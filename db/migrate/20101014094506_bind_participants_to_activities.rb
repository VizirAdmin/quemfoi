class BindParticipantsToActivities < ActiveRecord::Migration

  def self.up
    remove_column :participants, :course_id
    add_column :participants, :activity_id, :integer
  end
  
  def self.down
    add_column :participants, :course_id, :integer
    remove_column :participants, :activity_id
  end
  
end
