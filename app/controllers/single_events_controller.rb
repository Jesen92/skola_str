class SingleEventsController < ApplicationController
respond_to :json
    helper_method :current_user
    before_filter :authenticate_user!

  

  def get_events #JSON zapis predavanja za kalendar(current_user)
    @event = current_user.profesor.events
    events = []
    @event.each do |event|
        @s_event = event.single_events
        @s_event.each do |s_event|

            @col = "#0066FF"
            @grupa
            @mjesto
            @adresa
            if s_event.group == nil
              @grupa = "";
            else
              @grupa = s_event.group.name
            end

            if event.where == nil
              @mjesto = ""
              @adresa = ""
            else
              @mjesto = s_event.where.name
              @adresa = s_event.where.adress
            end

            @ev = "<p><a href ='/single_event/show."+s_event.id.to_s+"'>Stranica predavanja</a></p>"

            if s_event.odrzano? && s_event.date <= Date.today.strftime("%Y-%m-%d")
              @col = "#00FF00"
            elsif !s_event.odrzano? && s_event.date < Date.today.strftime("%Y-%m-%d")
              @col = "#FF0000"
            elsif !s_event.odrzano? && s_event.date == Date.today.strftime("%Y-%m-%d")
              @col = "#FF9900"
            end




        events << {:id => s_event.id, :color => @col, :ev => @ev,:title => s_event.title, :start => s_event.date+" "+s_event.start,:end =>s_event.date+" "+s_event.end, :vrijeme => "<p><strong>"+s_event.start+" - "+s_event.end+"</strong></p>" ,:grupa => "<p><strong>Predavanje grupe:</strong></p> "+"<p>"+@grupa+"</p>", :mjesto => "<p><strong>Mjesto predavanja:</strong></p> "+"<p>"+@mjesto+"</p>", :adresa => "<p><strong>Adresa:</strong></p> "+"<p>"+@adresa+"</p>" }
    #  else 
       # events << {:id => event.id, :title => event.title, :start =>event.start_date.to_s+" "+event.start.to_s,:end =>event.start_date.to_s+" "+event.end.to_s , :vrijeme => "<p><strong>"+event.start+" - "+event.end+"</strong></p>" , :grupa => "<p><strong>Predavanje grupe:</strong></p> "+"<p>"+@grupa+"</p>", :mjesto => "<p><strong>Mjesto predavanja:</strong></p> "+"<p>"+@mjesto+"</p>", :adresa => "<p><strong>Adresa:</strong></p> "+"<p>"+@adresa+"</p>", :ranges => [{:start => "2000-1-1", :end => "3000-1-1"}] }
    #  end
    end
  end
    render :text => events.to_json
end


def get_all_events #JSON zapis predavanja za kalendar(svi user-i)
      @event = Event.all
    events = []
    @event.each do |event|
        @s_event = event.single_events
        @s_event.each do |s_event|

            @col = "#0066FF"
            @grupa
            @mjesto
            @adresa
            if s_event.group == nil
              @grupa = "";
            else
              @grupa = s_event.group.name
            end

            if event.where == nil
              @mjesto = ""
              @adresa = ""
            else
              @mjesto = s_event.where.name
              @adresa = s_event.where.adress
            end

            @ev = "<p><a href ='/single_event/show."+s_event.id.to_s+"'>Stranica predavanja</a></p>"

           # if s_event.odrzano? && s_event.date <= Date.today.strftime("%Y-%m-%d")
           #   @col = "#00FF00"
           # elsif !s_event.odrzano? && s_event.date < Date.today.strftime("%Y-%m-%d")
           #   @col = "#FF0000"
           # elsif !s_event.odrzano? && s_event.date == Date.today.strftime("%Y-%m-%d")
           #   @col = "#FF9900"
           # end

           if s_event.where.id == 1
            @col =  "#FF0000"
           elsif s_event.where.id == 2
            @col = "#00FF00"
           elsif s_event.where.id == 3
            @col = "#0000FF"
           elsif s_event.where.id == 4
            @col = "#FFCC00"
           elsif s_event.where.id == 5
            @col = "#00CCFF"
           elsif s_event.where.id == 6
            @col = "#C0C0C0"
           elsif s_event.where.id == 7
            @col = "#CC9900"
           elsif s_event.where.id == 8
            @col = "#FF00CC"
           elsif s_event.where.id == 9
            @col = "#000000"
           end

           @profesor = "<p><a href ='/profesors/show."+s_event.profesor.id.to_s+"'>"+s_event.profesor.name+"</a></p>"

        events << {:id => s_event.id, :profesor => "<p><strong>Profesor:</strong></p> "+"<p>"+@profesor+"</p>", :color => @col, :ev => @ev,:title => s_event.title, :start => s_event.date+" "+s_event.start,:end =>s_event.date+" "+s_event.end, :vrijeme => "<p><strong>"+s_event.start+" - "+s_event.end+"</strong></p>" ,:grupa => "<p><strong>Predavanje grupe:</strong></p> "+"<p>"+@grupa+"</p>", :mjesto => "<p><strong>Mjesto predavanja:</strong></p> "+"<p>"+@mjesto+"</p>", :adresa => "<p><strong>Adresa:</strong></p> "+"<p>"+@adresa+"</p>" }
    #  else 
       # events << {:id => event.id, :title => event.title, :start =>event.start_date.to_s+" "+event.start.to_s,:end =>event.start_date.to_s+" "+event.end.to_s , :vrijeme => "<p><strong>"+event.start+" - "+event.end+"</strong></p>" , :grupa => "<p><strong>Predavanje grupe:</strong></p> "+"<p>"+@grupa+"</p>", :mjesto => "<p><strong>Mjesto predavanja:</strong></p> "+"<p>"+@mjesto+"</p>", :adresa => "<p><strong>Adresa:</strong></p> "+"<p>"+@adresa+"</p>", :ranges => [{:start => "2000-1-1", :end => "3000-1-1"}] }
    #  end
    end
  end
    render :text => events.to_json
end


  def index
    if current_user
     @events = current_user.profesor.single_events    
     @user = current_user
     @event_grid = initialize_grid(@events, order: 'single_events.date',order_direction: 'asc')
    else
     redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def show
    @event = SingleEvent.find(params[:format])
  end 

  def update
    @event = SingleEvent.find(params[:id])

    @event.update(event_params)

    flash[:notice] = 'Predavanje izmjenjeno'

    redirect_to event_path(params[:id])
  end

  def edit
    @event = SingleEvent.find(params[:format])
  end

  private
    def event_params
    params.require(:single_event).permit(:start, :end, :where, :date, :odrzano, ucenik_ids: [])
  end

    def press_params
      params.require(:ucenik_event).permit()
    end

end
