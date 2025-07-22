module ProductCompatibility
  extend ActiveSupport::Concern

  def available_options(current_selections = {})
    available = {}

    parts.each do |part|
      available_choices = part.part_choices.in_stock

      compatibility_rules.each do |rule|
        # Forward compatibility: Check if this rule affects the current part
        if rule.target_part_id == part.id
          selected_choice_id = current_selections[rule.condition_part_id.to_s]
          # Apply rule if condition is met
          if selected_choice_id.present? && selected_choice_id.to_i == rule.condition_choice_id
            available_choices = apply_compatibility_rule(available_choices, rule)
          end
        end

        # Reverse compatibility: If selecting this part's choice would conflict with existing selections
        if rule.condition_part_id == part.id
          conflicting_selection = current_selections[rule.target_part_id.to_s]

          # If user has already selected something that would conflict, remove the conflicting choice
          if conflicting_selection.present? && conflicting_selection.to_i == rule.target_choice_id && rule.action == "exclude"
            available_choices = available_choices.where.not(id: rule.condition_choice_id)
          end
        end
      end

      available[part.id] = available_choices.to_a
    end

    available
  end

  private

  def apply_compatibility_rule(available_choices, rule)
    case rule.action
    when "restrict"
      rule.target_choice_id.present? ? available_choices.where(id: rule.target_choice_id) : available_choices
    when "exclude"
      rule.target_choice_id.present? ? available_choices.where.not(id: rule.target_choice_id) : available_choices
    else
      available_choices
    end
  end
end
