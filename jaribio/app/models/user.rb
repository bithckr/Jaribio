class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
    :confirmable,
    :recoverable, 
    :registerable,
    :rememberable, 
    :trackable, 
    :validatable,
    :token_authenticatable

  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :test_cases
  has_many :suites
  has_many :plans
  has_many :executions
end
