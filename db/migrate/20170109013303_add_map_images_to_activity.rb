class AddMapImagesToActivity < ActiveRecord::Migration[5.0]
  def change
    add_attachment :activities, :small_map
    add_attachment :activities, :large_map
  end
end
