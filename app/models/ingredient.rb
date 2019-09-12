class Ingredient < ActiveRecord::Base
  has_many :recipes, through: :recipe_ingredients
end

# Save this for later (I might make an Amount model with quantity and units and seed the DB)

# UNITS_LIST = {
#   :us => ["cup", "cups", "fl oz", "gal", "lb", "oz", "pt", "qt", "tbsp", "tsp"],
#   :si => ["g", "kg", "kL", "L", "mg", "mL"],
#   :other => ["dash", "dollop", "dollops", "drop", "drops", "handful", "handfuls", "piece", "pieces", "pinch", "scoop", "scoops", "slice", "slices"]
# }
# Note: When the user chooses a unit from the :other hash, that unit should have the word "of" after it in the view.
# That, or just have "of" after EVERY unit.

# def self.units_list # This should protect @@units_list and its arrays of units from unwanted changes.
#   Hash.new.tap do |hash|
#     UNITS_LIST.each do |unit_system, units|
#       hash[unit_system] = units.freeze
#     end
#   end.freeze
# end

# ---------------- New Features --------------------

# I want the user to be able to write their own unit and save it into their list of units (and maybe make it available to others).
# Is it possible for any changes to @@units_list to be saved into the ingredients database?
#
# @@units_list = {
#   :us => ["cup", "fl oz", "gal", "lb", "oz", "pt", "qt", "tbsp", "tsp"],
#   :si => ["L", "g", "kL", "kg", "mL", "mg"],
#   :other => ["dash", "drop", "drops", "handful", "handfuls", "piece", "pieces", "pinch"]
# }
# 
# def self.units_list # This should protect @@units_list from unwanted changes.
#   @@units_list.dup.freeze
# end
# 
# def self.add_unit_to_list(unit) # This is intended to let users SAFELY add their own units to @@units_list.
#   unless already_in_list?(unit)
#     units_list[:other] << unit
#     units_list[:other].sort! # Sort @@units_list[:other] alphabetically after adding the unit.
#   end
# end
# 
# def self.already_in_list?(unit) # Is the unit in @@units_list?
#   units_list.detect do |unit_system, units|
#     units.include?(unit)
#   end
# end
 