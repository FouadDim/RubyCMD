require 'socket'
require 'colorize'

def display_ascii_art
  ascii_art = <<-ART
   _____       _            _____ __  __ _____  
  |  __ \\     | |          / ____|  \\/  |  __ \\ 
  | |__) |   _| |__  _   _| |    | \\  / | |  | |
  |  _  / | | | '_ \\| | | | |    | |\\/| | |  | |
  | | \\ \\ |_| | |_) | |_| | |____| |  | | |__| |
  |_|  \\_\\__,_|_.__/ \\__, |\\_____|_|  |_|_____/ 
                     __/ |                     
                    |___/                      
  ART

  puts ascii_art.colorize(:cyan)
end

def display_help_menu
  puts "=============================".colorize(:yellow)
  puts "        RubyCMD Help".upcase.colorize(:cyan)
  puts "=============================".colorize(:yellow)
  puts
  puts "COMMAND  | DESCRIPTION".colorize(:green)
  puts "-------------------------------------".colorize(:yellow)
  puts "cd       | Change directory".colorize(:light_blue)
  puts "ls       | List all files and folders in the active directory".colorize(:light_blue)
  puts "ip       | Reveals IP Address".colorize(:light_blue)
  puts "open     | Reveals file content".colorize(:light_blue)
  puts "           Eg: open file.txt".colorize(:light_blue)
  puts ""
  puts "new      | Creates a new file".colorize(:light_blue)
  puts "           Eg: new file.txt 'content'".colorize(:light_blue)
  puts ""
  puts "help     | Shows this menu".colorize(:light_blue)
  puts "pwd      | Shows the active directory".colorize(:light_blue)
  puts "-------------------------------------".colorize(:yellow)
  puts
end

def change_directory(path)
  if path.nil? || path.empty?
    puts "No directory specified."
    return
  end

  begin
    Dir.chdir(path)
    puts "Changed directory to #{Dir.pwd}"
  rescue Errno::ENOENT
    puts "Directory not found: #{path}"
  rescue Errno::EACCES
    puts "Permission denied: #{path}"
  end
end

def list_files(path = '.')
  path = '.' if path.nil? || path.empty? # Default to current directory if path is nil or empty

  begin
    list = Dir.children(path)
    puts "\n#{'=' * 30}".colorize(:light_blue)
    puts "Items in #{Dir.pwd}".colorize(:cyan)
    puts "#{'=' * 30}".colorize(:light_blue)
    list.each { |i| puts "|    #{i}".colorize(:light_blue) }
    puts "#{'_' * 30}".colorize(:light_blue)
  rescue Errno::ENOENT
    puts "Directory not found: #{path}"
  rescue Errno::EACCES
    puts "Permission denied: #{path}"
  end
end

def display_ip
  ip = Socket.ip_address_list.detect(&:ipv4_private?)
  puts ip ? ip.ip_address : "No IP address found"
end

def create_file(filename, content = "")
  return puts "No filename specified." if filename.nil? || filename.empty?

  File.open(filename, 'w') { |file| file.write(content) }
  puts "\nCreated new file\nName: #{filename}\n"
end

def open_file(filename)
  return puts "No filename specified." if filename.nil? || filename.empty?

  if File.exist?(filename)
    puts File.read(filename)
  else
    puts "File not found: #{filename}"
  end
end

def main
  display_ascii_art
  display_help_menu

  loop do
    print "#{Dir.pwd} > "
    input = gets.chomp
    parts = input.split(' ', 2) # Split into command and arguments
    command = parts[0]
    arguments = parts[1] ? parts[1].split(' ', 2) : []

    case command
    when 'cd'
      change_directory(arguments[0])
    when 'pwd'
      puts Dir.pwd
    when 'ls'
      list_files(arguments[0])
    when 'exit'
      puts 'Goodbye!'
      break
    when 'ip'
      display_ip
    when 'help'
      display_help_menu
    when 'new'
      create_file(arguments[0], arguments[1])
    when 'open'
      open_file(arguments[0])
    else
      puts "Unknown command: #{command}"
    end
  end
end

main
