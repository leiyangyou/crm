namespace :weekly do
  task :performance, [:date] => [:environment] do |t, args|
    task = ::CRMTask::Performance::WeeklyTask.new
    task.perform :date => args[:date]
  end
end
