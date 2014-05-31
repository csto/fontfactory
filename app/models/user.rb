class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :fonts, dependent: :destroy

  validates_presence_of :email, :password_digest, unless: :guest?
  validates_confirmation_of :password
  
  after_create :create_first_font
  
  def create_first_font
    self.fonts.create
  end

  def self.new_guest
   new { |u| u.guest = true }
  end

  def move_to(user)
   tasks.update_all(user_id: user.id)
  end
end
