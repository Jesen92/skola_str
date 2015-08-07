ActiveAdmin.register Payment do

menu :label => "Plaćanje", :priority => 12

permit_params :uplaceno, :uplata
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


  index :title => "Plaćanje" do
    selectable_column
    column :id 
    column :date, :sortable => :date
    column :ucenik
    column :group, :sortable => :level
    column :uplaceno
    column :created_at, :sortable => :created_at

    actions
  end

	form do |f|
		f.inputs "Details" do
		  f.input :date, :label => "Datum"
		  f.input :uplaceno, :label => "Plaćeno"
		  f.input :uplata, :label => "Uplata(kn)"


		  end

		  f.actions
	end

end
