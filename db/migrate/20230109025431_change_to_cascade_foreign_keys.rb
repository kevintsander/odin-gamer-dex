class ChangeToCascadeForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key 'posts', 'users'
    remove_foreign_key 'reactions', 'posts'
    remove_foreign_key 'reactions', 'users'
    remove_foreign_key 'user_relationships', 'users'
    remove_foreign_key 'user_relationships', 'users' # , column: 'friend_id'
    add_foreign_key 'posts', 'users', on_delete: :cascade
    add_foreign_key 'reactions', 'posts', on_delete: :cascade
    add_foreign_key 'reactions', 'users', on_delete: :cascade
    add_foreign_key 'user_relationships', 'users', column: 'user_id', on_delete: :cascade
    add_foreign_key 'user_relationships', 'users', column: 'friend_id', on_delete: :cascade
  end
end
