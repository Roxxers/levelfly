task :report, [:message] => :environment do |t, args|

  puts ":message = #{args.message}"
    
  Admin.list_members('2014-01-01', 'BMCC')
end