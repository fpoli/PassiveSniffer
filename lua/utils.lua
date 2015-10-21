-- calling tostring() on random FieldInfo's can cause an error, so this func handles it
function getstring(finfo)
	local ok, val = pcall(tostring, finfo)
	if not ok then val = "" end
	return val
end

function hex2ascii(data)
	decoded = ""
	for hex_char in string.gmatch(data, "([0-9a-f][0-9a-f])") do
		new_char = string.char(tonumber(hex_char, 16))
		decoded = decoded .. new_char
	end
	return decoded
end

function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t, i-1
end

function get_readable(str)
	local s = ""
	local separator = " "
	local word_finished = false
	for i = 1, str:len() do
		if str:byte(i) >= 32 and str:byte(i) <= 126 then
			if word_finished then
				s = s .. separator
				word_finished = false
			end
			s = s .. str:sub(i,i)
		else
			word_finished = true
		end
	end
	return s
end

function isempty(s)
	return s == nil or s == ''
end

function is_private_ip(ip)
	if isempty(ip) then
		return nil
	elseif ip:match(":") then
		-- IPv6
		-- TODO
		return nil
	else
		-- IPv4
		if ip:sub(1,3) == '10.' then
			return true
		elseif ip:sub(1,4) == '172.' then
			-- TODO
			return nil
		elseif ip:sub(1,8) == '192.168.' then
			return true
		elseif ip:sub(1,9) == '127.0.0.1' then
			return true
		elseif ip:sub(1,8) == '169.254.' then
			return true
		elseif ip:sub(1,2) == '0.' then
			return true
		else
			-- TODO?
			return false
		end
	end
end


function truncate_with_ellipsis(str, num)
	local ellipsis = "..."
	if str:len() <= num then
		return str
	else
		return str:sub(1, num-3) .. "..."
	end
end
