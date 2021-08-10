class AddTextToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :text, :text_area
  end
end
