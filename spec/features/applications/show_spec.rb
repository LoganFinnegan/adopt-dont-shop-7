require 'rails_helper'

RSpec.describe 'The Application Show Page', type: :feature do
  describe 'As a visitor' do
    before(:each) do
      # Shelters
      @puppy_hope = Shelter.create!(name: 'Puppy Hope', city: 'Palo Alto',foster_program: true, rank: 1 )
      # Pets
      @pet_1 = Pet.create!(name: 'Sparky', age: 4, breed: 'Chihuahua', adoptable: true, shelter_id: @puppy_hope.id )
      @pet_2 = Pet.create!(name: 'Spot', age: 1, breed: 'Angus', adoptable: true, shelter_id: @puppy_hope.id )
      # Applications 
      @app_1 = Application.create!(name: 'Megan Samuels', street_address: '505 E. Happy Pl', city: "Austin", state: "MN", zip: "55912", description: 'I love dogs', status: 0)
      # Pet Applications 
      PetApp.create!(application_id: @app_1.id, pet_id: @pet_1.id)
    end

    # 1. Application Show Page
    it "displays the applicant information" do
      # When I visit an applications show page
      visit "/applications/#{@app_1.id}"
      # Then I can see the following:
      # - Name of the Applicant
      expect(page).to have_content(@app_1.name)
      # - Full Address of the Applicant including street address, city, state, and zip code
      expect(page).to have_content(@app_1.street_address)
      expect(page).to have_content(@app_1.city)
      expect(page).to have_content(@app_1.state)
      expect(page).to have_content(@app_1.zip)
      # - Description of why the applicant says they'd be a good home for this pet(s)
      expect(page).to have_content(@app_1.description)
      # - names of all pets that this application is for (all names of pets should be links to their show page)
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_link(@pet_1.name)
      # - The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"
      expect(page).to have_content("In Progress")
      within '.pets-on-app' do
        click_on(@pet_1.name)
        expect(current_path).to eq("/pets/#{@pet_1.id}")
      end
    end

    # 4. Searching for Pets for an Application
    it "can search and display pet names" do
      # When I visit an application's show page
      visit "/applications/#{@app_1.id}"
      # And that application has not been submitted,
      expect(page).to_not have_content("Spot")
      # Then I see a section on the page to "Add a Pet to this Application"
      within '.find-pets' do
        expect(page).to have_content("Add a Pet to this Application")
        # In that section I see an input where I can search for Pets by name
        expect(page).to have_content("Search for Pet:")
        # When I fill in this field with a Pet's name
        fill_in :search_name, with: "Spot"
        # And I click submit,
        click_on("submit")
      end

      # Then I am taken back to the application show page
      expect(current_path).to eq("/applications/#{@app_1.id}")
      # And under the search bar I see any Pet whose name matches my search
      within '.found-pets' do
        expect(page).to have_content(@pet_2.name)
      end
    end

    # 5. Add a Pet to an Application
    it "adds an adpot button to pets" do
      # When I visit an application's show page
      visit "/applications/#{@app_1.id}"

      within '.find-pets' do
        # And I search for a Pet by name
        fill_in :search_name, with: "Spot"
        click_on("submit")
      end
        
      within '.found-pets' do
        # And I see the names Pets that match my search
        expect(page).to have_content(@pet_2.name)

        within "#pet-#{@pet_2.id}" do
          # Then next to each Pet's name I see a button to "Adopt this Pet"
          expect(page).to have_button("Adopt this Pet")
          # When I click one of these buttons
          click_on("Adopt this Pet")
        end
      end
      # Then I am taken back to the application show page
      expect(current_path).to eq("/applications/#{@app_1.id}")
      # And I see the Pet I want to adopt listed on this application
      within '.pets-on-app' do
        expect(page).to have_content(@pet_2.name)
      end
    end

    # 6. Submit an Application
    it "asks why applicant would be a good owner" do
      # When I visit an application's show page
      visit "/applications/#{@app_1.id}"

      # And I have added one or more pets to the application
      within '.find-pets' do
        fill_in :search_name, with: "Spot"
        click_on("submit")
      end
      within '.found-pets' do
        within "#pet-#{@pet_2.id}" do
          click_on("Adopt this Pet")
        end
      end
      #within '.submit-application' do
        # Then I see a section to submit my application
        expect(page).to have_button("Submit Application")
        # And in that section I see an input to enter why I would make a good owner for these pet(s)
        expect(page).to have_content("Why I would make a good owner for these pet(s)?:")
        # When I fill in that input
        fill_in :reason_to_adopt, with: "I will cook them into a soup."
        # And I click a button to submit this application
        click_on("Submit Application")
      #end
      # Then I am taken back to the application's show page
      expect(current_path).to eq("/applications/#{@app_1.id}")
      # And I see an indicator that the application is "Pending"
      expect(page).to have_content("Pending")
      # And I see all the pets that I want to adopt
      expect(page).to have_content(@pet_2.name)
      p (@app_1)
      # And I do not see a section to add more pets to this application
      expect(page).to_not have_content("Add a Pet to this Application")
    end
  end
end
#delete this