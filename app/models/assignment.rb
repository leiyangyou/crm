class Assignment < ActiveRecord::Base
  belongs_to :assignable, :polymorphic => true
  belongs_to :user
  # attr_accessible :title, :body
end
