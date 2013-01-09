module ParticipationsHelper
  def link_to_attend participation
    link_to( t(:attend), attend_participation_path(participation),
             :method => :post,
             :confirm => t("view.participation.attend_confirm"),
             :remote => true
    )
  end
end
