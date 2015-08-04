ActiveAdmin.register Book do

permit_params :num, :title

config.clear_sidebar_sections!
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

menu :label => "Udžbenici", :priority => 7

 index :title => 'Udžbenici' do
    selectable_column
    column "Naziv", :title
    column "Broj komada", :num
    actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :title, :label => "Naziv"
      f.input :num, :label => "Broj komada"


      end
     # f.inputs "Ponavljanje" do
     #   f.input :recurring_rule, :as=> :select, :input_html => { :class => 'recurring_select'}, :collection => options_for_select([[ "- not recurring -" , "null"],["Set schedule..." , "custom" ]], [ "- not recurring -" , "null"])
     # end
      f.actions
  end

end
