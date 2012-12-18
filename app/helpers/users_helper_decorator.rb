UsersHelper.class_eval do
  def scoped_users_select(asset, users, description_field = :full_description)
    collection_select asset, :assigned_to, users, :id, description_field
  end
end