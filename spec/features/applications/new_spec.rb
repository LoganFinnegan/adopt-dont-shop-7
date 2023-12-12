require 'rails_helper'

RSpec.describe 'The New Application page', type: :feature do
  describe 'As a visitor' do
    before(:each) do
      # Shelters
      @puppy_hope = Shelter.create!(name: 'Puppy Hope', city: 'Palo Alto',foster_program: true, rank: 1 )
      # Pets
      @pet_1 = Pet.create!(name: 'Sparky', age: 4, breed: 'Chihuahua', adoptable: true, shelter_id: @puppy_hope.id )
      # Applications 
      @app_1 = Application.create!(name: 'Megan Samuels', street_address: '505 E. Happy Pl', city: "Austin", state: "MN", zip: "55912", description: 'I love dogs', status: 0)
      # Pet Applications 
      PetApp.create!(application_id: @app_1.id, pet_id: @pet_1.id)
    end

    # 3. Starting an Application, Form not Completed
    it "returns a error message when form is not completed" do
      # When I visit the new application page
      visit "/applications/new"
      # And I fail to fill in any of the form fields
      # fill_in(:name, with "")
      # fill_in(:street_address, with: "")
      # fill_in(:city, with: "")
      # fill_in(:state, with: "")
      # fill_in(:zip, with: "")
      # fill_in(:description, with: "")
      # And I click submit
      click_on("submit")
      # Then I am taken back to the new applications page
      # ???
      # And I see a message that I must fill in those fields.
      expect(page).to have_content("Application not created: Required information missing.")
      expect(current_path).to eq("/applications/new")
    end
  end
end