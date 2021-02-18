# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  url         :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord
  def mark_notified!
    self.update!(notified: true)
  end

  def unmark_notified!
    self.update!(notified: false)
  end
end
