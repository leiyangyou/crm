module ParticipationsHelper
  def link_to_attend participation
    link_to( t(:attend), attend_participation_path(participation),
             :method => :post,
             :remote => true
    )
  end
end
