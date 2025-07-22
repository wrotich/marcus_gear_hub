class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role, presence: true

  enum :role, { customer: "customer", admin: "admin", super_admin: "super_admin" }

  scope :active, -> { where(active: true) }
  scope :customers, -> { where(role: "customer") }
  scope :admins, -> { where(role: [ "admin", "super_admin" ]) }
  scope :recent, -> { order(created_at: :desc) }

  after_create :create_cart
  before_save :normalize_email

  def full_name
    "#{first_name} #{last_name}"
  end

  def display_name
    full_name
  end

  def initials
    "#{first_name[0]}#{last_name[0]}".upcase
  end

  def admin?
    admin_role? || super_admin?
  end

  def customer?
    role == "customer"
  end

  def can_manage_products?
    admin? || super_admin?
  end

  def can_manage_users?
    super_admin?
  end

  def can_view_all_orders?
    admin?
  end

  def can_manage_compatibility_rules?
    admin?
  end

  def can_manage_pricing_rules?
    admin?
  end

  def can_access_admin_panel?
    admin?
  end

  def ensure_cart
    self.cart || create_cart
  end

  def cart_item_count
    cart&.item_count || 0
  end

  def cart_total
    cart&.total_price || 0.0
  end

  def recent_orders(limit = 5)
    orders.includes(:order_items).order(created_at: :desc).limit(limit)
  end

  def total_spent
    orders.where.not(status: "cancelled").sum(:total_amount)
  end

  def order_count
    orders.where.not(status: "cancelled").count
  end

  def has_orders?
    orders.exists?
  end

  def activate!
    update!(active: true)
  end

  def deactivate!
    update!(active: false)
  end

  def toggle_active!
    update!(active: !active)
  end

  def self.find_by_email(email)
    find_by(email: email.downcase.strip)
  end

  def self.search(query)
    return all if query.blank?

    where(
      "LOWER(first_name) LIKE :query OR
       LOWER(last_name) LIKE :query OR
       LOWER(email) LIKE :query",
      query: "%#{query.downcase}%"
    )
  end

  def self.total_customers
    customers.active.count
  end

  def self.recent_signups(days = 7)
    where(created_at: days.days.ago..Time.current).count
  end

  def self.top_customers(limit = 10)
    joins(:orders)
      .where.not(orders: { status: "cancelled" })
      .group("users.id")
      .order("SUM(orders.total_amount) DESC")
      .limit(limit)
  end

  private

  def create_cart
    Cart.create!(user: self) unless cart.present?
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create cart for user #{id}: #{e.message}"
  end

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
