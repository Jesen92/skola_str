class UceniksController < ApplicationController
	  	before_filter :authenticate_user!
  def index
  end

  def show
  	@ucenik = Ucenik.find(params[:format])
  	@page_title = @ucenik.name
  	@ucenik_grid = initialize_grid(@ucenik.payments, include: :event ,order: 'payments.date',order_direction: 'asc') #conditions: ["single_events.odrzano = '0'"] // ako zelim ispisati samo sa ne

  end

  def edit
  	@payment = Payment.find(params[:format])
  end

  def update
  	@pay = Payment.find(params[:id])

    @pay.update(payment_params)

    flash[:notice] = 'Upisano plaćanje'

    redirect_to ucenik_path(params[:id])
  end

  private
    def payment_params
    params.require(:payment).permit(:uplaceno, :uplata)
  end

end
