# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  notified    :boolean          default(FALSE), not null
#  url         :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord
  after_commit :notify, on: [:update]

  def mark_notified!
    self.update!(notified: true)
  end

  def unmark_notified!
    self.update!(notified: false)
  end

  private

  def notify
    return if previous_changes[:notified].blank?

    if previous_changes[:notified].last
      ProductInStockMailer.with(product: self).default_message.deliver_now
    else
      ProductNoLongerInStockMailer.with(product: self).default_message.deliver_now
    end
  end
end
