RailsAdmin.config do |config|
  config.asset_source = :sprockets
  # No authentication needed
  config.authenticate_with { }
  config.current_user_method { nil }

  # Configure models
  config.model "Product" do
    list do
      field :id
      field :name
      field :category
      field :base_price
      field :active
      field :created_at
    end

    edit do
      field :name
      field :description, :text
      field :category, :enum do
        enum { [ "bicycle", "ski", "other" ] }
      end
      field :base_price
      field :image_url, :string
      field :active
    end
  end

  config.model "Part" do
    list do
      field :id
      field :name
      field :part_type
      field :created_at
    end

    edit do
      field :name
      field :part_type, :enum do
        enum { [ "frame", "finish", "wheels", "color", "drivetrain", "other" ] }
      end
      field :description, :text
    end
  end

  config.model "PartChoice" do
    list do
      field :id
      field :part
      field :name
      field :base_price
      field :in_stock
    end

    edit do
      field :part
      field :name
      field :base_price
      field :description, :text
      field :in_stock
    end
  end
end
