class User < ApplicationRecord
  encrypts :document, deterministic: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  extend FriendlyId
  enum role: { user: 0, admin: 1 }
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist
  friendly_id :username, use: :slugged
  validates :username, presence: true, uniqueness: true
  validates :document, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  before_validation :generate_initial_username, on: :create
  after_create_commit :notify_slack

  has_many :accounts, dependent: :destroy, inverse_of: :user
  has_many :credit_applications, dependent: :destroy, inverse_of: :user

  def to_param
    username
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def notify_slack
    SlackNotificationJob.perform_async(self.id, "user_created", Current.request_id)
  end

  def generate_initial_username
    return if username.present?
    base_name = "#{first_name}_#{last_name}".parameterize(separator: "-")
    self.username = loop do
      random_username = "#{base_name}-#{SecureRandom.random_number(1000..9999)}"
      break random_username unless User.exists?(username: random_username)
    end
  end
end
