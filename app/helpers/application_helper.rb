module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def color_default(user)
    if user.color == nil
      '#005a55'
    else
      user.color
    end
  end

  def words_form(number, enot, enota, enotov)
    ostatok = number % 10

    return enotov if number.between?(11, 14) || (number % 100).between?(11, 14)

    return enot if ostatok == 1

    return enota if ostatok.between?(2, 4)

    return enotov if ostatok.between?(5, 9) || ostatok == 0
  end

   # Хелпер, рисующий span тэг с иконкой из font-awesome
  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end
end
