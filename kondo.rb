# - - - - Kondo.rb - - - -
# This is designed to remove files with a specified file extension in one sweep.
# It's focused on regular directories associated with a user account on a computer (Documents, Downloads, Desktop)
# Use case: handling customer data on a local machine. The files have a specific extension. This script ensures that I'm sweeping and removing the files so that I'm doing my due diligence as a support engineer.

require 'fileutils'
# Find files of a specific extension in the file system...

puts "Provide a file extension"
print ">> "
extension = $stdin.gets.chomp
path = ENV['HOME'] + '/{Documents,Downloads,Desktop}/**/*.' + extension.to_s
Dir.glob(path).each do |file|
  p file
end

# Files are pushed to this array for holding and handling in the loop that follows.
queue = []
Dir.glob(path) do |move|
  queue.push(move)
end

# Loop that provides conditional branches to continue or quit based on whether the files exist, and whether the user actually wants to Do The Thing.
while true
  if queue == []
    puts "No #{extension.to_s} files found..."
    break
  end
  # If there are files that the user may want to delete...
  puts "Delete these files? [ y / n ]"
  print ">> "
  queue_request = $stdin.gets.chomp
  # If the user doesn't want to queue up the listed files for deletion, this breaks the loop and ends the script.
  # This instant break behavior is a little aggressive...
  if queue_request == "n"
    break
  end
  # If the user wants to move to the next stage of deleting the files...
  if queue_request == "y"
    puts "Files queued for deletion. Type 'delete' to confirm, or press any key to terminate without deletion"
    puts "* * * This is permanent and cannot be undone. * * *"
    print ">> "
    commit_to_deletion = $stdin.gets.chomp
    # Fixed - 19 August
    if commit_to_deletion == 'delete'
      queue.each do |remove|
        FileUtils.rm_rf(remove)
      end
      puts "Files deleted."
    elsif commit_to_deletion != 'delete'
      puts "Script terminated."
    end
  end
  break
end
