class Ucenik < ActiveRecord::Base
	has_paper_trail :ignore => [:updated_at]

	has_many :events, through: :group_uceniks
	has_many :group_uceniks

	has_many :ucenik_events
	has_many :single_events, through: :ucenik_events

	has_many :payments

	has_many :ucenik_books
	has_many :books, through: :ucenik_books
	
	accepts_nested_attributes_for :ucenik_books

	validates :name, presence: true

		before_save{ |ucenik| 


			@fee = 0
			@pay = Payment.where({ucenik_id: ucenik.id})

			ucenik.events.each do |event|
				@fee = @fee + event.group.cijena
			end

			ucenik.cijena_prije_popusta = @fee


			@fee = @fee - (@fee*(ucenik.popust ? ucenik.popust : 0)/100)


			ucenik.cijena = @fee

				@pay.each do |p|
					if p.uplata != nil
						@fee = @fee - p.uplata
					end
				end


			ucenik.preostalo_za_platiti= @fee
			

			if ucenik.placanje_na_rate?
				ucenik.events.each do |group|
					@i = 0
					@indicator = 0

					payments = Payment.all

					payments.each do |pay| #provjera da li uplate vec postoje u bazi
						if pay.ucenik_id == ucenik.id && pay.event_id == group.id
							@indicator = 1
							break
						end 
					end


					while @i < ucenik.br_rata && @indicator == 0
						payment = Payment.new

						payment.ucenik_id = ucenik.id
						payment.event_id = group.id

						if ucenik.popust != 0
							payment.default_uplata = (group.cijena-(group.cijena*ucenik.popust/100))/ucenik.br_rata
						elsif
							payment.default_uplata = group.group.cijena/ucenik.br_rata
						end
							

						payment.date = ucenik.prvi_mj_placanja + @i.month
						payment.default_date = ucenik.prvi_mj_placanja + @i.month
						payment.ime_ucenika = ucenik.name
						payment.title = ucenik.name+" "+group.title

						payment.save
						@i+=1
					end
				end
			end




	}

end
