class Question < ApplicationRecord
  belongs_to :user
  # Если установить :optional в true, тогда наличие связанных объектов не будет валидироваться. По умолчанию установлено в false
  belongs_to :author, class_name: 'User', optional: true

  validates :text, presence: true, length: { maximum: 255 }
end
