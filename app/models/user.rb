require 'openssl'

class User < ApplicationRecord
  # Параметры работы для модуля шифрования паролей
  ITERATIONS = 20_000
  CHECK_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  CHECK_USERNAME = /\A\w+\z/
  COLOR = /\A#([a-f0-9]{6}|[a-f0-9]{3})\z/
  DIGEST = OpenSSL::Digest::SHA256.new

  attr_accessor :password

  has_many :questions

  validates :email, :username, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create
  # ИЛИ
  #
  #validates_confirmation_of :password
  # Проверка формата электронной почты пользователя
  validates :email, format: { with: CHECK_EMAIL }
  # Проверка максимальной длины юзернейма пользователя (не больше 40 символов)
  # Проверка формата юзернейма пользователя (только латинские буквы, цифры, и знак _)
  validates :username, length: { maximum: 40 }, format: { with: CHECK_USERNAME }
  # проверка формата воода цвета (hex-запись), разрешиаем пустое значение, чтобы пользователь мог зарегистрироваться не выбирая цвет
  validates :color, format: { with: COLOR }, allow_blank: true

  before_validation :username_downcase
  before_validation :email_downcase

  before_save :encrypt_password


  # Служебный метод, преобразующий бинарную строку в 16-ричный формат,
  # для удобства хранения.
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  # Основной метод для аутентификации юзера (логина). Проверяет email и пароль,
  # если пользователь с такой комбинацией есть в базе возвращает этого
  # пользователя. Если нету — возвращает nil.
  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    user = find_by(email: email)

    # Если пользователь не найдет, возвращаем nil
    return nil unless user.present?

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password

    # Иначе, возвращаем nil
    nil
  end

  # Шифруем пароль, если он задан
  def encrypt_password
    if password.present?
      # создаём соль
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # создаём хэш пароля
      self.password_hash = User.hash_to_string(
          OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  private

  def username_downcase
    username&.downcase!
  end

  def email_downcase
    email&.downcase!
  end
end
