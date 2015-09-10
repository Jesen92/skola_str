ActiveAdmin.register Event do
csv force_quotes: true, col_sep: ';' do
  column :id
  column ("Naziv") {|event| event.title}
  column ("Školska godina") {|event| event.skolska_god != nil ? event.skolska_god.name : ""}
  column ("Polje") {|event| event.polje != nil ? event.polje.name : ""}
  column ("Početak") {|event| event.start}
  column ("Kraj") {|event| event.end}
  column ("Datum početka tečaja") {|event| event.start_date.strftime("%d.%m.%Y.")} 
  column ("Učionica") {|event| event.where != nil ? event.where.name : ""}
  column ("Profesor") {|event| event.profesor != nil ? event.profesor.name : ""}
end
 controller do
  def show
      @ucenik = Event.includes(versions: :item).find(params[:id])
      @versions = @ucenik.versions 
      @ucenik = @ucenik.versions[params[:version].to_i].reify if params[:version]
      show! #it seems to need this
  end
end
  sidebar :verzije, :partial => "layouts/version", :only => :show

menu :label => "Tečajevi", :priority => 3

 index :title => 'Tečajevi' do
    selectable_column
    column :id
    column :title, :sortable => :title
    column "Početak predavanja", :sortable => :start do |t|
      t.start.strftime("%H:%M")
    end
    column "Kraj predavanja", :sortable => :end do |t|
      t.end.strftime("%H:%M")
    end
    column :start_date
    column :where


    column :profesor
    column :group
    column :created_at
    actions
  end




permit_params :title,:start, :end, :br_sk_sati, :br_pred, :dodatak, :br_uku_sati, :skolska_god_id, :polje_id, :start_date, :single_event, :end_date, :allDay, :where_id, :profesor_id, :repeat, :repeat_until, :group_id, :recurring_rule, day_ids: [], ucenik_ids: []
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


show do
    attributes_table do
      row :id
      row :title
      row :skolska_god
      row :polje
      row :dodatak
      row :profesor
      row :group
      row :where
      row ("Početak predavanja") {event.start.strftime("%H:%M")}
      row ("Kraj predavanja") {event.end.strftime("%H:%M")}
      row :start_date
      #row :recurring_rule



      row :created_at
      row :updated_at

      panel "Popis učenika" do
        table_for event.uceniks do 
          column :name do |ucenik|
           link_to ucenik.name, [:admin, ucenik]
         end
        end
      end

      panel "Predavanja" do
        table_for event.single_events.sort_by {|event| event.date} do 

          column "Naziv" do |e|
            link_to e.title, [:admin, e]
          end

          column "Datum" do |e|
            link_to e.date.strftime("%d.%m.%Y."), [:admin, e]
          end

          column "Vrijeme predavanja" do |e|
            e.start.to_s+" - "+e.end.to_s
          end


          column "Profesor" do |e|
            if e.profesor != nil
            link_to e.profesor.name, [:admin, e.profesor]
            end
          end

          column "Predavaonica" do |e|
            if e.where != nil
            link_to e.where.name, [:admin, e.where]
            end
          end

        end
      end
      
    end
  end

  sidebar "Tjedno se ponavlja:", only: [:show], if: proc{event.repeat?} do
    table_for event.days do 
          column "Dani ponavljanja", :name do |day|
           day.name
      end
    end

    table_for event do
      column "Broj predavanja",:br_pred 
    end 
  end


  form do |f|
    f.inputs "Details" do
      f.input :group, :label => "Grupa"
      f.input :skolska_god, :label => "Školska godina"
      f.input :polje, :label => "Red grupe"
      f.input :dodatak
      f.input :profesor, :label => "Predavač"
      f.input :start, :label => "Vrijeme početka:", :as => :time_picker, :required => true
      f.input :br_sk_sati, :label => "Broj školskih sati"
      f.input :where, :label => "Mjesto predavanja",  :as => :select
      f.input :uceniks, :label => "Učenici", :input_html => {:class => "chosen" ,:multiple => true}

      f.input :start_date, :label => "Datum početka:", :as => :datepicker, :required => true

      f.input :repeat, :label => "Tjedno Ponavljanje:"
      f.input :br_uku_sati, :label => "Ukupan broj školskih sati"
      #f.input :br_pred, :label => "Broj predavanja"
      f.input :days, :label => "Dani ponavljanja:", :as => :check_boxes

      end
     # f.inputs "Ponavljanje" do
     #   f.input :recurring_rule, :as=> :select, :input_html => { :class => 'recurring_select'}, :collection => options_for_select([[ "- not recurring -" , "null"],["Set schedule..." , "custom" ]], [ "- not recurring -" , "null"])
     # end
      f.actions
  end

end
