class Ingredient < ActiveRecord::Base
  belongs_to :recipe

  @@units_list = [
    {:us => ["cup", "fl oz", "gal", "lb", "oz", "pt", "qt", "tbsp", "tsp"]},
    {:si => ["L", "g", "kL", "kg", "mL", "mg"],
    {:other => ["dash", "drop", "drops", "handful", "handfuls", "piece", "pieces", "pinch"]}
    # Note: When the user chooses a unit from the :other hash, that unit should have the word "of" after it in the view.
    # That, or just have "of" after EVERY unit.
  ]
end