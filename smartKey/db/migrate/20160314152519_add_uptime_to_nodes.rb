class AddUptimeToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :uptime, :integer, :default => 0
  end
end
