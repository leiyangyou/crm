namespace :daily do
  task :performance, [:date ] => [:environment] do |t, args|
    task = ::CRMTask::Performance::DailyTask.new
    task.perform :date => args[:date]
  end
end