class AddNoteToShifts < ActiveRecord::Migration[8.1]
  def change
    add_column :shifts, :note, :text
  end
end
