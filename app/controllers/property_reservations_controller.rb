class PropertyReservationsController < ApplicationController
  def show
    @property_reservation = PropertyReservation.find(params[:id])
  end

  def create
    @property_reservation = current_user.property_reservations.new(property_reservation_params)
    @property = property = Property.find(params[:property_id])
    @property_reservation.property = Property.find(params[:property_id])
    @property_reservation.save
    PropertyReservationMailer
      .with(reservation: @property_reservation)
      .notify_new_reservation
      .deliver_now
    redirect_to @property_reservation, notice: t('.success')
  end

  def accept
    @property_reservation = PropertyReservation.find(params[:id])
    @property_reservation.accepted!
    redirect_to @property_reservation.property
  end

  def cancel
    @property_reservation = PropertyReservation.find(params[:id])

    begin
      @property_reservation.canceled!
      redirect_to @property_reservation.property, notice: 'Reserva cancelada com sucesso!'
    rescue ActiveRecord::RecordInvalid
      redirect_to @property_reservation, notice: 'Data de cancelamento não permitida!'
    end
  end

  private

  def property_reservation_params
    params.require(:property_reservation).permit(:start_date, :end_date, :guests)
  end
end
