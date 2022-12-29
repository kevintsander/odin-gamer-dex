class AddDirectionToUserRelationship < ActiveRecord::Migration[7.0]
  def change
    add_column :user_relationships, :direction, :string
  end
end
