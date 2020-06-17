class UsersController < ApplicationController
  def index
    @users = [
      User.new(
      id: 1,
      name: 'Viacheslav',
      username: 'slavjan',
      avatar_url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS5w0jXPEZumrhYIsJS_kL8RNPN8hxp7OfwEx000lrx2weiKySU&usqp=CAU'
      ),
      User.new(id: 2, name: 'Misha', username: 'aristofun')
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Viacheslav',
      username: 'slavjan',
      avatar_url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS5w0jXPEZumrhYIsJS_kL8RNPN8hxp7OfwEx000lrx2weiKySU&usqp=CAU'
      )

    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('27.03.2016')),
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('27.03.2016'))
    ]

    @new_question = Question.new
  end
end
