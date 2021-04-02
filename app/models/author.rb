class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books
  accepts_nested_attributes_for :books, allow_destroy: true

  def name
    first_name + (other_names.nil? || other_names.empty? ? '' : " #{other_names}") + " #{last_name}"
  end
end
