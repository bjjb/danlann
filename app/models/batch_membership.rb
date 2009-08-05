class BatchMembership < ActiveRecord::Base
  belongs_to :batch
  belongs_to :picture
end
