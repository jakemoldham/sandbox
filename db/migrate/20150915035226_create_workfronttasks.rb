class CreateWorkfronttasks < ActiveRecord::Migration
  def change
    create_table :workfronttasks do |t|
      t.string :workfront_id
      t.string :name
      t.string :objCode
      t.float :percentComplete
      t.string :plannedCompletionDate
      t.string :plannedStartDate
      t.integer :priority
      t.string :progressStatus
      t.string :projectedCompletionDate
      t.string :projectedStartDate
      t.string :status
      t.integer :taskNumber
      t.string :wbs
      t.integer :workTequired

      t.timestamps null: false
    end
  end
end
