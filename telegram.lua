json = require('json.json')
coro = require('coro-http')
file = io.open('./token.txt', 'r')
if not (file) then
	print('token.txt not found')
end
token = file:read('*a')
file:close()
telegram = 'bot' .. token
tusername = 'put your name here or nothing will be read'
function telbot()
    tbl = json.decode(http_get('https://api.telegram.org/bot' .. telegram .. '/getUpdates'))
    file = io.open('./telegram.txt', 'r')
    if not (file) then
    	file = io.open('./telegram.txt', 'w')
    	file:write('0')
    	file:close()
    	file = io.open('./telegram.txt', 'r')
    end
    rec = file:read('*a')
    file:close()
    if (tbl.result[#tbl.result].message.forward_from_chat ~= nil) then
    	if (tbl.result[#tbl.result].message.forward_from_chat.username == tusername) then
	    	if not (rec == tbl.result[#tbl.result].update_id) then
	    		--do shit
	    		file = io.open('./telegram.txt', 'w')
	    		file:write(tbl.result[#tbl.result].message.message_id)
	    		file:close()
	    		if (tbl.result[#tbl.result].message.photo ~= nil) then
			    	ttbl = json.decode(http_get('https://api.telegram.org/bot' .. telegram .. '/getFile?file_id=' .. tbl.result[#tbl.result].message.photo[#tbl.result[#tbl.result].message.photo].file_id))
			    	fpath = ttbl.result.file_path
			    	body = http_get('https://api.telegram.org/file/bot' .. telegram .. '/' .. fpath)
			    	file = io.open("./telegram.jpg", "w")
					file:write(body)
					file:close()
					if (tbl.result[#tbl.result].message.caption ~= nil) then
						text = tbl.result[#tbl.result].message.caption
					end
	    			--do something with file, will remain loaded as the 'body' variable if you dont want to do anything with the file
				else
					text = tbl.result[#tbl.result].message.text
				end
	    		-- do something with the text variable
	    	end
    	end
    end
end