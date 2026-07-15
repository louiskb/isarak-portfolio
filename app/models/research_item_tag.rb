class ResearchItemTag < ApplicationRecord
  belongs_to :research_item
  belongs_to :tag
end
