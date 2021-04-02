class Genre < ApplicationRecord
  belongs_to :genre, optional: true
  has_many :books

  def path
    if genre_id.nil?
      (fiction ? 'F' : 'Non-f') + 'iction > ' + description
    else
      Genre.find(genre_id).path + " > #{description}"
    end
  end
end
