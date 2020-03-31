class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :products
  has_many :employees

  before_save :before_saving

  def before_saving
    self.email.strip!
    self.email.downcase!

    self.name.strip!
    self.name.capitalize!
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, length: {minimum: 2, maximum: 50}
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}, allow_blank: true
  has_secure_password

  class << self
    def digest(string)
      BCrypt::Password.create(string, cost: BCrypt::Engine.cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token=User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest) == remember_token
  end

  def active_products
    Product.active.where(user_id: self.id)
  end

  def inactive_products
    Product.inactive.where(user_id: self.id)
  end

  def self.all_without_admins
    self.all.where(admin: false)
  end

  def active_employees
    Employee.active.where(user_id: self.id)
  end

  def inactive_employees
    Employee.inactive.where(user_id: self.id)
  end

  def active_working_employees
    Employee.active_working.where(user_id: self.id)
  end

  def active_free_employees
    Employee.active_free.where(user_id: self.id)
  end

end
