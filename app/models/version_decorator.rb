Version.class_eval do
  class << self
    def latest(options = {})
      includes(:item, :related, :user).
        where(({:item_type => options[:asset]} if options[:asset])).
        where(({:event     => options[:event]} if options[:event])).
        where(({:whodunnit => options[:user].to_s}  if options[:user])).
        where(({:whodunnit => options[:users]}  if options[:users])).
        where('versions.created_at >= ?', Time.zone.now - (options[:duration] || 2.days)).
        default_order
    end
  end
end

