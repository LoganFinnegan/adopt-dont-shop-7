class Application < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :city, 
                        :state,
                        :zip,
                        :description

  enum status: ['In Progress', 'Pending', 'Accepted', 'Rejected']

  has_many :pet_apps, dependent: :destroy
  has_many :pets, through: :pet_apps

  # def found_pets(name)
  #   pets.first.shelter.pets.search(name)
  # end
  
  def submit
  
  end
end