# Clear existing data in dependency order
puts "Clearing existing data..."
CartItem.destroy_all
Cart.destroy_all
PricingRule.destroy_all
CompatibilityRule.destroy_all
ProductPart.destroy_all
PartChoice.destroy_all
Part.destroy_all
Product.destroy_all
# User.destroy_all

puts "Creating users..."
# Create admin user (Marcus)
marcus = User.create!(
  email: 'marcus@bikeshop.com',
  first_name: 'Marcus',
  last_name: 'Johnson',
  role: 'admin',
  phone: '+1-555-0123',
  active: true
)

# Create customer users
john = User.create!(
  email: 'john.doe@example.com',
  first_name: 'John',
  last_name: 'Doe',
  role: 'customer',
  phone: '+1-555-0124',
  active: true
)

jane = User.create!(
  email: 'jane.smith@example.com',
  first_name: 'Jane',
  last_name: 'Smith',
  role: 'customer',
  phone: '+1-555-0125',
  active: true
)

puts "Creating products..."
# Main bicycle product
bicycle = Product.create!(
  name: "Custom Mountain Bike",
  description: "Build your perfect mountain bike with our extensive customization options. Choose from various frame types, finishes, wheels, and components.",
  base_price: 500.00,
  category: "bicycle",
  active: true,
  image_url: "https://example.com/images/mountain-bike.jpg"
)

# Future products for expansion
road_bike = Product.create!(
  name: "Custom Road Bike",
  description: "Lightweight and fast road bike perfect for racing and long rides.",
  base_price: 450.00,
  category: "bicycle",
  active: true,
  image_url: "https://example.com/images/road-bike.jpg"
)

# Ski product (for future expansion)
skis = Product.create!(
  name: "Custom Alpine Skis",
  description: "High-performance alpine skis customizable for your skiing style.",
  base_price: 800.00,
  category: "ski",
  active: false, # Not yet available
  image_url: "https://example.com/images/alpine-skis.jpg"
)

puts "Creating parts for mountain bike..."

# Frame part
frame_part = Part.create!(
  name: "Frame Type",
  part_type: "frame",
  description: "Choose the frame style that best suits your riding needs"
)

frame_full_suspension = PartChoice.create!(
  part: frame_part,
  name: "Full-suspension",
  base_price: 130.00,
  description: "Maximum comfort and control on rough terrain",
  in_stock: true
)

frame_diamond = PartChoice.create!(
  part: frame_part,
  name: "Diamond",
  base_price: 100.00,
  description: "Classic lightweight frame design",
  in_stock: true
)

frame_step_through = PartChoice.create!(
  part: frame_part,
  name: "Step-through",
  base_price: 110.00,
  description: "Easy mount and dismount design",
  in_stock: true
)

# Frame finish part
finish_part = Part.create!(
  name: "Frame Finish",
  part_type: "finish",
  description: "Choose your preferred frame finish"
)

finish_matte = PartChoice.create!(
  part: finish_part,
  name: "Matte",
  base_price: 35.00,
  description: "Modern matte finish that resists fingerprints",
  in_stock: true
)

finish_shiny = PartChoice.create!(
  part: finish_part,
  name: "Shiny",
  base_price: 30.00,
  description: "Classic glossy finish with deep shine",
  in_stock: true
)

finish_carbon = PartChoice.create!(
  part: finish_part,
  name: "Carbon Fiber",
  base_price: 150.00,
  description: "Premium carbon fiber finish for ultimate performance",
  in_stock: false # Out of stock
)

# Wheels part
wheels_part = Part.create!(
  name: "Wheels",
  part_type: "wheels",
  description: "Select wheels optimized for your riding style"
)

wheels_road = PartChoice.create!(
  part: wheels_part,
  name: "Road wheels",
  base_price: 80.00,
  description: "Lightweight wheels for speed and efficiency",
  in_stock: true
)

wheels_mountain = PartChoice.create!(
  part: wheels_part,
  name: "Mountain wheels",
  base_price: 120.00,
  description: "Durable wheels designed for off-road adventures",
  in_stock: true
)

wheels_fat = PartChoice.create!(
  part: wheels_part,
  name: "Fat bike wheels",
  base_price: 150.00,
  description: "Extra-wide wheels for sand and snow riding",
  in_stock: true
)

# Rim color part
rim_part = Part.create!(
  name: "Rim Color",
  part_type: "color",
  description: "Customize your rim color"
)

rim_red = PartChoice.create!(
  part: rim_part,
  name: "Red",
  base_price: 20.00,
  description: "Bold red accent color",
  in_stock: true
)

rim_black = PartChoice.create!(
  part: rim_part,
  name: "Black",
  base_price: 15.00,
  description: "Classic black for any style",
  in_stock: true
)

rim_blue = PartChoice.create!(
  part: rim_part,
  name: "Blue",
  base_price: 20.00,
  description: "Cool blue accent color",
  in_stock: true
)

rim_silver = PartChoice.create!(
  part: rim_part,
  name: "Silver",
  base_price: 15.00,
  description: "Sleek silver finish",
  in_stock: true
)

# Chain part
chain_part = Part.create!(
  name: "Chain & Gears",
  part_type: "drivetrain",
  description: "Choose your drivetrain configuration"
)

chain_single = PartChoice.create!(
  part: chain_part,
  name: "Single-speed chain",
  base_price: 43.00,
  description: "Simple and low-maintenance single-speed setup",
  in_stock: true
)

chain_8speed = PartChoice.create!(
  part: chain_part,
  name: "8-speed chain",
  base_price: 65.00,
  description: "Versatile 8-speed gearing for varied terrain",
  in_stock: true
)

chain_21speed = PartChoice.create!(
  part: chain_part,
  name: "21-speed chain",
  base_price: 95.00,
  description: "Professional 21-speed system for maximum versatility",
  in_stock: true
)

puts "Linking parts to mountain bike..."
ProductPart.create!(product: bicycle, part: frame_part, required: true, display_order: 1)
ProductPart.create!(product: bicycle, part: finish_part, required: true, display_order: 2)
ProductPart.create!(product: bicycle, part: wheels_part, required: true, display_order: 3)
ProductPart.create!(product: bicycle, part: rim_part, required: true, display_order: 4)
ProductPart.create!(product: bicycle, part: chain_part, required: true, display_order: 5)

puts "Creating parts for road bike..."
# Road bike uses some of the same parts but with different requirements
ProductPart.create!(product: road_bike, part: frame_part, required: true, display_order: 1)
ProductPart.create!(product: road_bike, part: finish_part, required: true, display_order: 2)
ProductPart.create!(product: road_bike, part: wheels_part, required: true, display_order: 3)
ProductPart.create!(product: road_bike, part: rim_part, required: false, display_order: 4) # Optional for road bike
ProductPart.create!(product: road_bike, part: chain_part, required: true, display_order: 5)

puts "Creating compatibility rules..."

# Rule 1: If mountain wheels selected, only full-suspension frame allowed
CompatibilityRule.create!(
  product: bicycle,
  condition_part: wheels_part,
  condition_choice: wheels_mountain,
  target_part: frame_part,
  target_choice: frame_full_suspension,
  action: 'restrict',
  description: 'Mountain wheels require full-suspension frame for optimal performance'
)

# Rule 2: If fat bike wheels selected, red rim color is unavailable
CompatibilityRule.create!(
  product: bicycle,
  condition_part: wheels_part,
  condition_choice: wheels_fat,
  target_part: rim_part,
  target_choice: rim_red,
  action: 'exclude',
  description: 'Fat bike wheels not available with red rim color due to manufacturing constraints'
)

# Rule 3: Road wheels not compatible with full-suspension frame
CompatibilityRule.create!(
  product: bicycle,
  condition_part: wheels_part,
  condition_choice: wheels_road,
  target_part: frame_part,
  target_choice: frame_full_suspension,
  action: 'exclude',
  description: 'Road wheels are not suitable for full-suspension frames'
)

# Rule 4: Single-speed chain not available with road wheels (road bikes need gears)
CompatibilityRule.create!(
  product: bicycle,
  condition_part: wheels_part,
  condition_choice: wheels_road,
  target_part: chain_part,
  target_choice: chain_single,
  action: 'exclude',
  description: 'Road wheels require multi-speed gearing for optimal performance'
)

puts "Creating pricing rules..."

# Rule 1: Matte finish costs more on full-suspension frame (larger surface area)
PricingRule.create!(
  product: bicycle,
  conditions: [
    { 'part_id' => frame_part.id, 'choice_id' => frame_full_suspension.id },
    { 'part_id' => finish_part.id, 'choice_id' => finish_matte.id }
  ],
  price_adjustment: 15.00,
  description: 'Matte finish costs extra on full-suspension frame due to larger surface area'
)

# Rule 2: Discount for basic road setup
PricingRule.create!(
  product: bicycle,
  conditions: [
    { 'part_id' => frame_part.id, 'choice_id' => frame_diamond.id },
    { 'part_id' => wheels_part.id, 'choice_id' => wheels_road.id },
    { 'part_id' => chain_part.id, 'choice_id' => chain_single.id }
  ],
  price_adjustment: -25.00,
  description: 'Discount for basic road bike configuration'
)

# Rule 3: Premium combo discount
PricingRule.create!(
  product: bicycle,
  conditions: [
    { 'part_id' => frame_part.id, 'choice_id' => frame_full_suspension.id },
    { 'part_id' => wheels_part.id, 'choice_id' => wheels_mountain.id },
    { 'part_id' => chain_part.id, 'choice_id' => chain_21speed.id }
  ],
  price_adjustment: -50.00,
  description: 'Premium mountain bike package discount'
)

# Rule 4: Carbon fiber finish gets additional cost with premium components
PricingRule.create!(
  product: bicycle,
  conditions: [
    { 'part_id' => finish_part.id, 'choice_id' => finish_carbon.id },
    { 'part_id' => chain_part.id, 'choice_id' => chain_21speed.id }
  ],
  price_adjustment: 25.00,
  description: 'Premium carbon fiber finish with professional components'
)

puts "Creating sample carts..."

# Create cart for John with mountain bike configuration
john_cart = john.cart
mountain_config = {
  frame_part.id.to_s => frame_full_suspension.id,
  finish_part.id.to_s => finish_matte.id,
  wheels_part.id.to_s => wheels_mountain.id,
  rim_part.id.to_s => rim_blue.id,
  chain_part.id.to_s => chain_8speed.id
}

CartItem.create!(
  cart: john_cart,
  product: bicycle,
  quantity: 1,
  selections: mountain_config
)

# Create a guest cart (no user)
guest_cart = Cart.create!(session_id: 'guest_session_abc123')

basic_config = {
  frame_part.id.to_s => frame_step_through.id,
  finish_part.id.to_s => finish_shiny.id,
  wheels_part.id.to_s => wheels_road.id,
  rim_part.id.to_s => rim_black.id,
  chain_part.id.to_s => chain_8speed.id
}

CartItem.create!(
  cart: guest_cart,
  product: bicycle,
  quantity: 2, # Guest ordering 2 bikes
  selections: basic_config
)

puts "Seed data created successfully!"
puts ""
puts "=" * 60
puts "MARCUS BIKE SHOP - SEED DATA SUMMARY"
puts "=" * 60
puts ""
puts "👥 USERS CREATED:"
puts "  • #{marcus.full_name} (#{marcus.email}) - #{marcus.role.capitalize}"
puts "  • #{john.full_name} (#{john.email}) - #{john.role.capitalize}"
puts "  • #{jane.full_name} (#{jane.email}) - #{jane.role.capitalize}"
puts ""
puts "🚲 PRODUCTS CREATED:"
puts "  • #{Product.active.count} active products: #{Product.active.pluck(:name).join(', ')}"
puts "  • #{Product.where(active: false).count} inactive products: #{Product.where(active: false).pluck(:name).join(', ')}"
puts ""
puts "🔧 PARTS & CHOICES:"
puts "  • #{Part.count} parts with #{PartChoice.count} total choices"
Part.includes(:part_choices).each do |part|
  puts "    - #{part.name}: #{part.part_choices.count} choices (#{part.part_choices.in_stock.count} in stock)"
end
puts ""
puts "⚙️  BUSINESS RULES:"
puts "  • #{CompatibilityRule.count} compatibility rules"
puts "  • #{PricingRule.count} pricing rules"
puts ""
puts "🛒 SAMPLE DATA:"
puts "  • #{Cart.count} carts (#{Cart.joins(:user).count} user carts, #{Cart.where(user: nil).count} guest carts)"
puts "  • #{CartItem.count} items in carts"
puts ""
puts "💰 EXAMPLE PRICING:"
mountain_price = bicycle.calculate_price(mountain_config.transform_keys(&:to_i).transform_values(&:to_i))
basic_price = bicycle.calculate_price(basic_config.transform_keys(&:to_i).transform_values(&:to_i))

puts "  1. Mountain Config: €#{mountain_price}"
puts "     (Full-suspension + Matte + Mountain wheels + Blue rim + 8-speed)"
puts "  2. Basic Config: €#{basic_price}"
puts "     (Step-through + Shiny + Road wheels + Black rim + 8-speed)"
puts ""
puts "🎯 NEXT STEPS:"
puts "  • Visit /admin to manage products and business rules"
puts "  • Use API endpoints to browse products and test configuration"
puts "  • Test compatibility rules (try mountain wheels + non-full-suspension)"
puts "  • Test pricing rules (try different combinations for discounts)"
puts ""
puts "=" * 60
