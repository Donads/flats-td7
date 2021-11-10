require 'rails_helper'

describe 'User cancels reservation' do
  context 'user can cancel reservation' do
    it 'when start_date is one day from now' do
      user = create(:user)
      property = create(:property, title: 'Apartamento bacana na praia')
      reservation = create(:property_reservation, property: property, user: user, start_date: 1.day.from_now)

      login_as user, scope: :user
      visit property_reservation_path(reservation)
      click_link 'Cancelar Reserva'

      expect(current_path).to eq property_path(property)
      expect(page).to have_content('Reserva cancelada com sucesso!')
      expect(page).to have_content('Apartamento bacana na praia')
    end
  end

  context 'user can not cancel reservation' do
    it 'when start_date is current date' do
      user = create(:user)
      property = create(:property, title: 'Apartamento bacana na praia')
      reservation = create(:property_reservation, property: property, user: user, start_date: Date.current)

      login_as user, scope: :user
      visit property_reservation_path(reservation)
      click_link 'Cancelar Reserva'

      expect(current_path).to eq property_reservation_path(reservation)
      expect(page).to have_content('Data de cancelamento não permitida!')
      expect(page).to have_content('Apartamento bacana na praia')
    end

    it 'when start_date is one day ago' do
      user = create(:user)
      property = create(:property, title: 'Apartamento bacana na praia')
      reservation = build(:property_reservation, property: property, user: user, start_date: 1.day.ago)
      reservation.save(validate: false)

      login_as user, scope: :user
      visit property_reservation_path(reservation)
      click_link 'Cancelar Reserva'

      expect(current_path).to eq property_reservation_path(reservation)
      expect(page).to have_content('Data de cancelamento não permitida!')
      expect(page).to have_content('Apartamento bacana na praia')
    end
  end
end
