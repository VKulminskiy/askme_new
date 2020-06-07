class UsersController < ApplicationController
  def show
  	@time = Time.now
	@hello = "Как здорово, что все мы здеь сегодня собрались!"
  end
end
