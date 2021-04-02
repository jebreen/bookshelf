class Book < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  accepts_nested_attributes_for :authors, allow_destroy: true
  belongs_to :genre, optional: true

  def names_text
    authors.map(&:name).to_sentence
  end
end
