ActiveAdmin.register Profesor do
csv force_quotes: true, col_sep: ';' do
  column :id
  column ("Ime i prezime") {|prof| prof.name}
  column :OIB
  column ("Radi za nas") {|prof| prof.radi_za_nas? ? "Da" : "Ne"}
  column ("Sudski tumač") {|prof| prof.sudski_tumac? ? "Da" : "Ne"}
  column :mobitel
  column :telefon
  column :mail
  column :obrazovanje
  column :karijerska_pozicija
  column ("Inozemno_iskustvo") {|prof| prof.inozemno_iskustvo? ? "Da" : "Ne"}
  column :inozemno_iskustvo_comment
  column :datum_rodenja
  column :mjesto_rodenja
  column :postanski_broj
  column ("Prebivalište") {|prof| prof.grad}
  column :ulica
  column :IBAN
  column ("Banka") {|prof| prof.bank != nil ? prof.bank.name : "" }
end
   controller do
  def show
      @ucenik = Profesor.includes(versions: :item).find(params[:id])
      @versions = @ucenik.versions 
      @ucenik = @ucenik.versions[params[:version].to_i].reify if params[:version]
      show! #it seems to need this
  end
end
  sidebar :verzije, :partial => "layouts/version", :only => :show

menu :label => "Suradnici", :priority => 2




permit_params :name, :OIB, :ulica, :zemlja, :inozemno_iskustvo_comment, :group, :radi_za_nas, :bank_id, :komentar,:sudski_tumac,:mobitel,:telefon,:mail,:obrazovanje,:karijerska_pozicija,:inozemno_iskustvo,:datum_rodenja,:mjesto_rodenja,:postanski_broj ,:grad, :IBAN, jezik_ids: [], book_ids: []
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



 form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :name, :label => "Ime i prezime"
      f.input :OIB, :label => "OIB"

      f.input :zemlja, :input_html => {:value => f.object.zemlja? ? f.object.zemlja : "Hrvatska"}

      f.input :ulica
      f.input :postanski_broj
      f.input :grad
  	  f.input :jeziks, :label => "Jezici" , :input_html => {:class => "chosen" ,:multiple => true}
      f.input :books, :label => "Udžbenici", :input_html => {:class => "chosen" ,:multiple => true}
  	  f.input :radi_za_nas
  	  f.input :komentar
  	  f.input :sudski_tumac
  	  f.input :mobitel
  	  f.input :telefon
  	  f.input :mail
  	  f.input :obrazovanje
  	  f.input :karijerska_pozicija
  	  f.input :inozemno_iskustvo
      f.input :inozemno_iskustvo_comment
        if f.object.datum_rodenja?
  	  f.input :datum_rodenja, start_year: 1920, end_year: Time.now.year, :as => :date_picker,:input_html => {:class => 'form-control', :value => f.object.datum_rodenja.strftime('%Y-%m-%d') }  	     
        else
            f.input :datum_rodenja, start_year: 1920, end_year: Time.now.year, :as => :date_picker,:input_html => {:class => 'form-control' } 
        end 
      f.input :mjesto_rodenja

  	  f.input :IBAN
      f.input :bank

  	
      f.actions
    end
  end

index :title => 'Suradnici' do
	selectable_column
  column :id
	column :name
	column :radi_za_nas
	column :sudski_tumac
	column "Prebivalište", :grad  
	column :karijerska_pozicija
	column :inozemno_iskustvo
	actions
end

  show do
    @pr_mj=0
    @mj=0
    @sati=0
    @pr_sati=0

    profesor.single_events.each do |event|
      if event.odrzano? && event.date.strftime("%m.%Y.") == Time.now.strftime("%m.%Y.")
        @mj+=1
        @sati+=event.end.to_time-event.start
      elsif event.odrzano? && event.date.strftime("%m.%Y.") == (Time.now.-1.month).strftime("%m.%Y.")
        @pr_mj+=1
        @pr_sati+=event.end-event.start
      end


    end

    attributes_table do
      row :name, :label => "Ime i prezime"
      row :OIB, :label => "OIB"
      row :zemlja
      row :ulica
      row :postanski_broj
      row :grad
      row :radi_za_nas
      row :komentar
      row :sudski_tumac
      row :mobitel
      row :telefon
      row :mail
      row :obrazovanje
      row :karijerska_pozicija
      row :inozemno_iskustvo
      row :datum_rodenja, start_year: 1920, end_year: Time.now.year
      row :mjesto_rodenja
      row :grad
      row :postanski_broj
      row :IBAN
      row :bank

      row ("Broj održanih predavanja prošlog mjeseca") {@pr_mj}
      row ("Održanih školskih sati prošlog mjeseca") {(@pr_sati/60)/45}
      row ("Broj održanih predavanja tekućeg mjeseca") {@mj}
      row ("Održanih školskih sati tekućeg mjeseca")  {(@sati/60)/45}

  

      panel "Jezici" do
        table_for profesor.jeziks do
          column "Jezik" do |jezik|
            link_to jezik.name, [:admin, jezik]
          end
        end
      end


      panel "Popis udžbenika" do
        table_for profesor.books do
          column "Naziv" do |book|
            link_to book.title, [:admin, book]
          end
        end
      end

      panel "Grupe" do
        table_for profesor.events do
          column :title do |group|
           link_to group.title, [:admin, group]
         end
        end
      end



    end
  end

end
