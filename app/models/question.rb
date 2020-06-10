class Question < ApplicationRecord
  belongs_to :user, optional: true

  validates :user, :text, presence: true
  # ИЛИ
  # belongs_to :user
  # validates :text, presence: true

  # Проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }
end
