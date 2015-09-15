class CreateWorkfrontprojects < ActiveRecord::Migration
  def change
    create_table :workfrontprojects do |t|
      t.string :work_front_project_id
      t.string :name
      t.string :objCode
      t.float :percentComplete
      t.string :plannedCompletionDate
      t.string :plannedStartDate
      t.string :projectedCompletionDate
      t.string :status

      t.timestamps null: false
    end
  end
end
