class DataCollector < Model
  attr_reader :user

  def initialize(user = nil)
    super

    @user = user
  end

  def valid?
    !!user
  end

  def username
    user.try(:username)
  end

  alias_method :id, :username

  def first_name
    user.try(:first_name)
  end

  def last_name
    user.try(:last_name)
  end

  def attributes
    super.merge(
      username: username,
      first_name: first_name,
      last_name: last_name
    )
  end
end
