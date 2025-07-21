class CompatibilityRule < ApplicationRecord
  belongs_to :product
  belongs_to :condition_part, class_name: "Part"
  belongs_to :condition_choice, class_name: "PartChoice"
  belongs_to :target_part, class_name: "Part", optional: true
  belongs_to :target_choice, class_name: "PartChoice", optional: true

  validates :action, inclusion: { in: %w[restrict exclude] }
  validates :condition_part_id, presence: true
  validates :condition_choice_id, presence: true

  # restrict: only allow target_choice for target_part
  # exclude: don't allow target_choice for target_part
end
