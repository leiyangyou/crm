module ParticipationsHelper
  def link_to_attend participation
    link_to( t(:attend), attend_participation_path(participation),
             :method => :post,
             :confirm => t("view.participation.attend_confirm"),
             :remote => true
    )
  end

  def link_to_transfer participation
    link_to( t(:transfer), new_lesson_transfer_account_lesson_path(participation.account, participation.lesson),
             :method => :get,
             :remote => true
    )
  end
end
