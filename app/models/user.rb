class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create_commit :notify_slack

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  extend FriendlyId
  enum role: { user: 0, admin: 1 }
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  friendly_id :username, use: :slugged
  # 1. Ensure username is unique and present (for the slug)
  validates :username, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true

  # 2. Run the generator only when the user is first created
  before_validation :generate_initial_username, on: :create

  has_many :accounts, dependent: :destroy, inverse_of: :user
  has_many :credit_applications, dependent: :destroy, inverse_of: :user

  # 3. Use the username for URLs (slug)
  def to_param
    username
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def notify_slack
    SlackNotificationJob.perform_async(self.id, Current.request_id)
  end

  def generate_initial_username
    return if username.present? # Allow manual entry if provided in the form

    # Format: john_doe_1234
    base_name = "#{first_name}_#{last_name}".parameterize(separator: "-")

    # We use SecureRandom to ensure uniqueness before we have an ID
    self.username = loop do
      random_username = "#{base_name}-#{SecureRandom.random_number(1000..9999)}"
      break random_username unless User.exists?(username: random_username)
    end
  end
end
