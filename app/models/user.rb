class User < ApplicationRecord
  before_save :before_saving
  attr_accessor :remember_token

  has_many :products
  has_many :employees
  has_many :warehouses
  has_many :all_events

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

    def all_without_admins
      self.all.where(admin: false)
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

  def destroy_user
    self.warehouses.destroy_all
    self.all_events.each do |event|
      case event.event_type
      when 'shopping'
        event.shopping_events.destroy_all
      when 'start_work_session'
        event.start_work_session_event.destroy
      when 'throwing'
        event.throwing_events.destroy_all
      when 'giving'
        event.giving_events.destroy_all
      when 'end_work_session'
        event.end_work_session_event.destroy
      when 'selling'
        event.selling_events.destroy_all
      when 'taking'
        event.taking_events.destroy_all
      when 'employee_salary'
        event.employee_salary_event.destroy
      when 'other_expense'
        event.other_expense_event.destroy
      when 'fare'
        event.fare_event.destroy
      when 'equipment'
        event.equipment_event.destroy
      when 'tax'
        event.tax_event.destroy
      end
    end
    self.all_events.destroy_all
    self.employees.destroy_all
    self.products.destroy_all
    self.destroy
  end

end
