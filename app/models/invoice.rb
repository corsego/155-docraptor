class Invoice < ApplicationRecord
  validates :email, :product, :price, :quantity, :total, presence: true

  before_validation :calculate_total
  has_one_attached :pdf_document

  private

  def calculate_total
    return unless price && quantity

    self.total = price * quantity
  end
end
