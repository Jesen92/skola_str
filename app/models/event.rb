class Event < ActiveRecord::Base
	require 'date'
  
  has_paper_trail :ignore => [:updated_at]

	belongs_to :profesor
	belongs_to :group
	has_many :days, through: :picked_days
	has_many :picked_days
	has_many :single_events
	belongs_to :where
  belongs_to :skolska_god
  belongs_to :polje

  validate :provjera_datuma
	validates :start,:end,:start_date, presence: true
 @update=0

  def provjera_datuma
  if repeat?
    @dan = start_date.wday == 7 ? 0 : start_date.wday
    if @dan != days.first.id
      errors.add(:days, "Dan datuma početka predavanja mora biti odabran")
    end
  end
  end


after_create { |event|

    if event.repeat?
        event.title = event.group.name+"/ "+event.skolska_god.name

      if event.polje != "" && event.polje != nil
        event.title = event.title+" / "+event.polje.name
      end

      if event.dodatak != ""
        event.title = event.title+" / "+event.dodatak
      end
    end


      event.save
 
}



    after_update { |event|

        SingleEvent.where({event_id: event.id}).delete_all


      @dani = Array.new(7)
      @i = 0
      @dani_count = 0
      @br = 0
      @zbr = 0

      event.start_date = event.start_date.to_date.strftime(" %Y-%m-%d ")



    if event.repeat?

      @first_day = event.days.first.id
      @d_c = @first_day 

        event.days.each do |day|
          temp = day.id-@d_c
          if temp < 0
            temp = (day.id+7)-@d_c
          end
          date = event.start_date
          @dani[@dani_count] = date+(temp)
          @dani_count+=1
        end

        @ost = event.br_pred % @dani_count

      #if @ost != 0
      #  @t = 0
      #else
      #  @t = -1
      #end

      @br = (event.br_pred/@dani_count)-1
      @i = @br

      @dani_count-=1  
    end



    while @i >= 0 && @dani_count >= 0
      s_event = SingleEvent.new
      s_event.event_id = event.id
    if event.title != nil
      s_event.title = event.title
    elsif 
      s_event.title = event.group.name
    end
      s_event.start = event.start
      s_event.end = event.end

      if event.repeat?
        s_event.date = @dani[@dani_count]+@zbr
      else
        s_event.date = event.start_date.to_date.strftime(" %Y-%m-%d ")
      end

      if event.profesor_id?
        s_event.profesor_id = event.profesor_id
      end

      if event.where_id?
        s_event.where_id = event.where_id
      end

      if event.group_id?
        s_event.group_id = event.group_id
      end

      s_event.save
      @zbr+=7
      @i-=1

      if @i < 0 && @dani_count > 0
        @dani_count-=1

        if @ost == 0
          @i = @br
        else
          if @dani_count <= @ost-1
            @i = @br+1
          else
            @i = @br
          end
        end


        @zbr = 0

 
      end
  end

    }

end
