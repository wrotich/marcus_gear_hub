# Marcus Gear Hub - E-commerce Solution

A customizable bicycle e-commerce platform with Rails API backend, Next.js frontend, and RailsAdmin for business management.

## Architecture Overview

**Tech Stack**: Rails API + Next.js + RailsAdmin + PostgreSQL  
**Key Design**: Sessionless, no authentication, direct admin access

---

## 1. Data Model

### Core Entities & Relationships

- **Products**: Base bicycle model (`name`, `base_price`, `category`, `active`)
- **Parts**: Customizable components (`name`, `part_type`, `description`)
- **PartChoices**: Available options (`name`, `base_price`, `in_stock`)
- **ProductParts**: Links products to customizable parts (`required`, `display_order`)
- **CompatibilityRules**: Business logic for valid combinations (`action`, `conditions`)
- **PricingRules**: Dynamic pricing adjustments (`price_adjustment`, `conditions`)
- **Carts/CartItems**: Session-based shopping cart with JSON configurations

**Key Relationships:**
```
Product → ProductParts → Parts → PartChoices
Product → CompatibilityRules (business logic)
Product → PricingRules (dynamic pricing)
Cart → CartItems (customer selections)
```

**Implementation**: See `db/migrate/` for complete schema, `app/models/` for associations and `erd.pdf` for the models visualization

---

## 2. Main User Actions

### Customer Journey
1. **Browse Products** → View bicycles with base pricing
2. **Select Product** → Choose bicycle to customize  
3. **Configure Options** → Real-time price updates and compatibility checking
4. **Add to Cart** → Session-based persistence of configurations
5. **Review Cart** → View all configured items before checkout

**Key Features**: Dynamic pricing, compatibility enforcement, visual feedback, cart persistence

**Implementation**: See `app/components/ProductConfigurator.js`, `app/controllers/api/v1/`, `app/models/concerns/product_compatibility.rb`

---

## 3. Product Page Implementation

### UI Structure
Product image, configuration panel with part selectors, real-time price summary, and validation for required selections.

### Options Calculation Algorithm
1. Start with all in-stock choices for each part
2. Apply compatibility rules based on current selections
3. Filter out incompatible combinations dynamically
4. Update available options in real-time

### Price Calculation
```
Total = Base Price + Selected Part Costs + Rule Adjustments
```

Rules can apply discounts (negative) or surcharges (positive) based on part combinations.

**Implementation**: See `app/controllers/api/v1/products_controller.rb#available_options`, `app/models/product.rb#calculate_price`, `app/models/concerns/product_compatibility.rb`

---

## 4. Add to Cart Action

### Process Flow
1. **Frontend Validation**: Verify all required parts selected
2. **API Call**: Submit product ID and selections hash
3. **Backend Logic**: Find/create session cart, check for duplicate configurations
4. **Persistence**: Store as CartItem with JSON selections

### Database Changes
- Create/update `CartItem` record
- Link to session-based cart (no user accounts)
- Store configuration as `{"part_id": choice_id}` JSON hash
- Prices calculated dynamically (not stored)

**Implementation**: See `app/controllers/api/v1/cart_items_controller.rb#create`

---

## 5. Administrative Workflows

### Marcus's Operations
- **Daily**: Inventory management, stock updates, order processing
- **Product Management**: Create bicycles, add parts/choices, set rules
- **Pricing**: Individual updates and combination rules
- **Analytics**: Track popular configurations and revenue

### Admin Interface
- **Direct Access**: `http://localhost:3001/admin` (no login required)
- **Professional UI**: RailsAdmin with CRUD, bulk operations, search/filter
- **Real-time Updates**: Changes visible to customers immediately

**Implementation**: See `config/initializers/rails_admin.rb`

---

## 6. New Product Creation

### Required Information
Basic details (name, description, base price, category), part associations, required vs optional designation, and UI display order.

### Database Impact
```sql
INSERT INTO products (name, description, base_price, category, active)
INSERT INTO product_parts (product_id, part_id, required, display_order)
```

New products immediately available for customer configuration.

**Implementation**: RailsAdmin product forms and `app/models/product.rb` validations

---

## 7. Adding New Part Choice

### Example: New Rim Color
1. **Admin Flow**: Parts → Rim Color → Add Choice
2. **Required Data**: Name, additional cost, description, stock status
3. **Immediate Effect**: Available in customer configurator

### Database Change
```sql
INSERT INTO part_choices (part_id, name, base_price, description, in_stock)
```

**Implementation**: RailsAdmin interface and `app/models/part_choice.rb`

---

## 8. Setting Prices

### Individual Pricing
Direct updates to `PartChoice.base_price` via admin interface.

### Combination Pricing
Create `PricingRule` records with:
- **JSON conditions**: Array of required part/choice combinations
- **Price adjustment**: Positive (surcharge) or negative (discount)
- **Examples**: Bundle discounts, premium material surcharges

### Calculation Logic
Real-time computation combines base price, part costs, and applicable rules.

**Implementation**: See `app/models/pricing_rule.rb` and `app/models/product.rb#calculate_price`

---

## Architecture Tradeoffs

### Key Decisions & Alternatives

#### **Domain Driven Design**
- **Chosen**: Model Marcus's business rules explicitly in code
- **Benefit**: Business logic clearly represented, easy to modify
- **Tradeoff**: More complex than simple catalog approach
- **Alternative**: Hard-coded business rules (inflexible)

#### **JSON Storage for Cart Selections**
- **Chosen**: Store `{"part_id": choice_id}` as JSON in PostgreSQL
- **Benefit**: Flexible schema, easy part structure changes
- **Tradeoff**: Less queryable than normalized relations
- **Alternative**: `CartItemSelections` table for complex analytics
- **PostgreSQL Advantage**: Better JSON querying with GIN indexes

#### **RailsAdmin vs Custom Interface**
- **Chosen**: Pre-built admin with zero development time
- **Benefit**: Professional UI, full CRUD, bulk operations
- **Tradeoff**: Limited customization, gem dependency
- **Alternative**: Custom admin for specific business workflows

#### **Real-time Price Calculation**
- **Chosen**: Calculate prices on every request
- **Benefit**: Always accurate, flexible rule changes
- **Tradeoff**: More API calls, CPU overhead
- **Alternative**: Cache prices with smart invalidation
- **PostgreSQL Advantage**: Fast materialized views for price caching

---

## Getting Started

```bash
# Prerequisites
# PostgreSQL installed and running
# Ruby 3.4.2+
# Node.js 18+
# Git

# Backend setup
git clone https://github.com/wrotich/marcus_gear_hub
cd marcus_gear_hub 
bundle install
rails db:setup && rails db:seed
rails server -p 3001

# Frontend setup  
cd marcus_gear_hub/frontend
npm install && npm run dev

# Access points
# Customer: http://localhost:3000
# Admin: http://localhost:3001/admin
```
---