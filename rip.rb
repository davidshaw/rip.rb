#!/usr/bin/ruby
###############################################
##
## this software is released under the GNU GPL
## if you have any questions about the GPL,
## http://lmgtfy.com/?q=GNU%20GPL
## 
## @author: dave
## @date:   december 1, 2009
##
################################################



require 'socket'

puts "-----------------------------------------"
puts "- rip.rb -- by dshaw                    -"
puts "-                                       -"
puts "- rips artist/title from internet radio -"
puts "-                                       -"
puts "-----------------------------------------\n"

if ARGV.length != 2 then

puts "-                                       -"
puts "- usage: ./rip.rb [HOST] [PORT]         -"
puts "-                                       -"
puts "- [HOST] should be the IP of the server -"
puts "- [PORT] is the port it's listening on  -"
puts "-                                       -"
puts "- you can find this information by      -"
puts "- opening the .pls file with a text     -"
puts "- editor.                               -"
puts "-----------------------------------------\n"
Process.exit

end

# i switched to dynamic streams.
host = ARGV[0]
port = ARGV[1]

# create a socket
puts "[+] creating socket"
s = TCPSocket.new(host, port) # open the socket

# announce ourselves
puts "[+] requesting stream..."
s.write("GET / HTTP/1.0\r\n")
s.write("Icy-MetaData:1\r\n")
s.write("User-Agent: ripClient/0.1\r\n")
s.write("\r\n")

metacount = 0
metaint = 0
str = s.gets
title = ""

while true do

	str = s.gets
	
	if str[4..6] == "nam" then
		name = str[9..str.length]
		print "[+] found stream ", name
	end
	
	if str[4..6] == "gen" then
		genre = str[10..str.length].chomp
		print "[+] found genre ", genre, "\n"
	end
	
	if str[4..6] == "met" then
		if str[12] == " " then
			metaint = str[13..str.length].to_i
			#print "[+] found metaint data: ", metaint, " waiting for signal\n"
		else
			metaint = str[12..str.length].to_i
			#print "[+] found metaint data: ", metaint, " waiting for signal\n"
		end
	end
	

	found = false
	
	while not found and metaint != 0 do
		bizyte = s.getc
		metacount += 1
		
		if metacount == metaint then
			
			str = ""
			str2 = ""
			getm = 0
			
			while not str.include? "StreamTitle=" do
				str = s.gets()	
				
				if str.include? "StreamTitle=" then
					
					first = 0
					last = 0
					
					first = str.index("StreamTitle=")
					str2 = str[first+13..str.length]
					
					last = str2.index("'")
					
					if title != "" then
						temp = title
					end
					
					title = str2[0..last-1]
					
					if temp == title then
						print "[+] found duplicate title\n"
					else
						print "[!] found title ", title, "\n"
						songFile = File.new(genre, "a")
						songFile.write(title)
						songFile.write("\n")
						songFile.close
					end
					
					found = true
					
					print "[+] closing socket\n"
					s.close
					
					print "[+] sleeping for 120 seconds...\n"
					
					sleep(120)
					
					puts "[+] creating socket"
					s = TCPSocket.new(host, port) # (re)open the socket
					
					print "[+] waking up!\n\n"
					puts "[+] requesting stream..."
					s.write("GET / HTTP/1.0\r\n")
					s.write("Icy-MetaData:1\r\n")
					s.write("User-Agent: ripClient/0.1\r\n")
					s.write("\r\n")
			
					metacount = 0
					metaint = 0
			
				end			
			end
		end
	
	end
	
end

s.close # close the socket
