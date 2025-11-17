class Employee < ApplicationRecord
  belongs_to :account
  belongs_to :location
  belongs_to :user
end
