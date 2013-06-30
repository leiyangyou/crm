UsersHelper.class_eval do
  def users
    @users ||= User.active
  end

  def scoped_users_select(asset, users, description_field = :full_description, method = :assigned_to, options = {}, html_options = {})
    collection_select asset, method, users, :id, description_field, options, html_options
  end
end