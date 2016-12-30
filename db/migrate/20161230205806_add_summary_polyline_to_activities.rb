class AddSummaryPolylineToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :summary_polyline, :text
  end
end
