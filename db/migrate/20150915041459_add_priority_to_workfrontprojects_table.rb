class AddPriorityToWorkfrontprojectsTable < ActiveRecord::Migration
  def change
    change_table :workfrontprojects do |t|
      t.string :priority
    end
  end
end
