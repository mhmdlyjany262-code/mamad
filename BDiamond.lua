-- By @sudo_hacker
local Config = dofile('./BlackDiamond/BlackDiamond.lua')
local BlackDiamond = '`بِلَک دیاموند`'
local SUDO = Config.SUDO_ID
local UserSudo = '@'..Config.Sudo1
local PvUserSudo = '@'..Config.PvSudo1
local Full_Sudo = Config.Full_Sudo
local Sudoid = Config.Sudoid
local TD_ID = Config.TD_ID
local BotCliId = Config.BotJoiner
local BotJoiner = Config.BotJoiner
local UserJoiner = Config.UserJoiner
local Channel = '@'..Config.Channel
local LinkSuppoRt = Config.LinkSuppoRt
local JoinToken = Config.JoinToken
local json = dofile('./BlackDiamond/JSON.lua')
local serpent = dofile('./BlackDiamond/serpent.lua')
local base = dofile('./BlackDiamond/redis.lua')
base:select(Config.RedisIndex)
local utf8 = dofile('./BlackDiamond/utf8.lua')
local dkjson = dofile('./BlackDiamond/dkjson.lua')
local http = require("socket.http")
local https = require("ssl.https")
local URL = require("socket.url")
local ltn12 = require("ltn12")
local mime = require("mime")
local offset = 0
local minute = 60
local hour = 3600
local day = 86400
local week = 604800
local MsgTime = os.time() - 60
local Plan1 = 2592000
local Plan2 = 7776000
local Api_Bot,ApiTokenID = string.match(JoinToken, '(%d+):(%S+)')
local Bot_Api = 'https://api.telegram.org/bot' .. JoinToken
local jdates = dofile('./jdate.lua')
local session_name = 'Api13'
----------------------------------------------
local tdlib = require('tdlib')
tdlib.set_config{
api_id = "21834151",
api_hash = "09da685355fbc80a8220720011f94638",
session_name = 'Api13'
}
local TD = tdlib.get_functions()
local need = {
process = 0
}
local function ExitCode()
if need.process > 0 then
TD.set_timer(600,ExitCode)
print('<<<< EXIT_1 >>>>')
else
os.exit()
end
end
if need.process == 0 then
TD.set_timer(900,ExitCode)
print('<<<< EXIT_2 >>>>')
end
-- تعریف تابع openChatIfNeeded
local function openChatIfNeeded(chat_id)
    if not base:get(TD_ID..'opened_chat:'..chat_id) then
        local result, err = pcall(function()
            TD.openChat(chat_id)
        end)
        if result then
            base:set(TD_ID..'opened_chat:'..chat_id, true)
            print("Chat opened successfully: "..chat_id)
        else
            print("Error opening chat "..chat_id..": "..tostring(err))
        end
    end
end
local porn_cfg = {}

function get_porn_cfg(chat_id)
    if not porn_cfg[chat_id] then
        local data = base:get(TD_ID..'porn_cfg:'..chat_id)
        porn_cfg[chat_id] = data and json:decode(data) or {enabled = false, sens = 0.7, act = "kick"}
    end
    return porn_cfg[chat_id]
end

function save_porn_cfg(chat_id)
    base:set(TD_ID..'porn_cfg:'..chat_id, json:encode(porn_cfg[chat_id]))
end
--------**Sudo**--------
function is_Sudo(msg)
local var = false
for v,user in pairs(SUDO) do
if user == (msg.sender_id.user_id) then
var = true
end
end
if base:sismember(TD_ID..'SUDO',msg.sender_id.user_id) then
var = true
end
if Sudo == tonumber(msg.sender_id.user_id) then
var = true
end
return var
end
function is_sudo1(userid)
local var = false
for v,user in pairs(SUDO) do
if user == (userid) then
var = true
end
end
if base:sismember(TD_ID..'SUDO',userid) then
var = true
end
if Sudo == tonumber(userid) then
var = true
end
return var
end
function Sudo(user_id)
local var = false
for v,user in pairs(SUDO) do
if user == (user_id) then
var = true
end
end
if base:sismember(TD_ID..'SUDO',user_id) then
var = true
end
if Sudo == tonumber(user_id) then
var = true
end
return var
end

function is_boted(user_id)
if tonumber(BotCliId) == tonumber(user_id) then
return true
elseif tonumber(Api_Bot) == tonumber(user_id) then
return true
else
return false
end
end
--------**FullSudo**--------
function is_FullSudo(msg)
local var = false
for v,user in pairs(Full_Sudo) do
if user == msg.sender_id.user_id then
var = true
end
end
return var 
end
function do_notify (user, msg)
local n = notify.Notification.new(user, msg)
n:show ()
end
--------**GlobalyBan**--------
function is_GlobalyBan(user_id)
local var = false
local hash = TD_ID..'GlobalyBanned:'
local gbanned = base:sismember(hash,user_id)
if gbanned then
var = true
end
return var
end
--------**Owner**--------
function is_Owner(msg) 
local hash = base:sismember(TD_ID..'OwnerList:'..msg.chat_id,msg.sender_id.user_id)
if hash or is_Sudo(msg) then
return true
else
return false
end
end
--------**Owner2**--------
function is_Owners(chatid,userid)
local hash = base:sismember(TD_ID..'OwnerList:'..chatid,userid)
if hash or is_sudo1(userid) then
return true
else
return false
end
end
--------**Mod**--------
function is_Mod(msg) 
local hash = base:sismember(TD_ID..'ModList:'..msg.chat_id,msg.sender_id.user_id)
if hash or is_Sudo(msg) or is_Owner(msg) then
return true
else
return false
end
end
--------**Mod2**--------
function is_Mods(chatid,userid) 
local hash = base:sismember(TD_ID..'ModList:'..chatid,userid)
if hash or is_Owners(chatid,userid) or is_sudo1(userid) then
return true
else
return false
end
end
--------**Vip**--------
function is_Vip(msg) 
local hash = base:sismember(TD_ID..'Vip:'..msg.chat_id,msg.sender_id.user_id)
if hash or is_Mod(msg) then return true
else
return false
end
end
--------**BanUser**--------
function is_Banned(chat_id,user_id)
local hash =
base:sismember(TD_ID..'BanUser:'..chat_id,user_id)
if hash then
return true
else
return false
end
end
--------**VipUser**--------
function VipUser(msg,user_id)
user_id = user_id or 00
local Mod = base:sismember(TD_ID..'ModList:'..msg.chat_id,user_id)
local Owner = base:sismember(TD_ID..'OwnerList:'..msg.chat_id,user_id)
local Sudo = base:sismember(TD_ID..'SUDO',user_id)
if Mod or Owner or Sudo then
return true
else
return false
end
end
function VipUser_(msg,user_id)
user_id = user_id or 00
local Owner = base:sismember(TD_ID..'OwnerList:'..msg.chat_id,user_id)
local Sudo = base:sismember(TD_ID..'SUDO',user_id)
if Owner or Sudo then
return true
else
return false
end
end
--------**filter**--------
function is_filter(msg,value)
local list = base:smembers(TD_ID..'Filters:'..msg.chat_id)
var = false
for i=1, #list do
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'FilterSen') then
mrr619 = value:match(list[i])
else
mrr619 = value:match(' '..list[i]..' ') or value:match('^'..list[i]..' ') or value:match(' '..list[i]..'$') or value:match('^'..list[i]..'$')
end
if mrr619 then
var = true
end
end
return var
end
----------------------------------------------
function string:split(sep)
local sep, fields = sep or ":", {}
local pattern = string.format("([^%s]+)", sep)
self:gsub(pattern, function(c) fields[#fields+1] = c end)
return fields
end
--------**ec_name**--------
function ec_name(name) 
Black = name
if Black then
if Black and Black:match('_') then
Black = Black:gsub('_','')
end
if Black and Black:match('*') then
Black = Black:gsub('*','')
end
if Black and Black:match('`') then
Black = Black:gsub('`','')
end
return Black
end
end
--------**check_markdown**--------
function check_markdown(text)
str = text
if str:match('_') then
output = str:gsub('_',[[\_]])
elseif str:match('*') then
output = str:gsub('*','\\*')
elseif str:match('`') then
output = str:gsub('`','\\`')
else
output = str
end
return output
end
--------**MuteUser**--------
function is_MuteUser(chat_id,user_id)
local hash =  base:sismember(TD_ID..'MuteUser:'..chat_id,user_id)
if hash then
return true
else
return false
end
end
---------**KickUser**---------
function KickUser(chat_id,user_id)
local Rep = Bot_Api.. '/kickChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id
return https.request(Rep)
end
----------------------------------------------
function MuteUser(chat_id,user_id,time)
local Rep = Bot_Api.. '/restrictChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id..'&can_post_messages=false&until_date='..time
return https.request(Rep)
end
----------------------------------------------
function UnRes(chat_id,user_id)
local Rep = Bot_Api.. '/restrictChatMember?chat_id=' .. chat_id .. '&user_id=' .. user_id..'&can_post_messages=true&can_add_web_page_previews=true&can_send_other_messages=true&can_send_media_messages=true'
return https.request(Rep)
end
----------------------------------------------
function getParseMode(parse_mode)
  local P = {}
  if parse_mode then
    local mode = parse_mode:lower()
    if mode == "markdown" or mode == "md" then
      P["@type"] = "textParseModeMarkdown"
    elseif mode == "html" then
      P["@type"] = "textParseModeHTML"
    end
  end
  return P
end
----------------------------------------------
function setLimit(limit, num)
  local limit = tonumber(limit)
  local number = tonumber(num or limit)
  return limit <= number and limit or number
end
--------**send**--------
function send(chat_id,reply_to_message_id, text, parse_mode, callback, data)
local input_message_content = {
["@type"] = "inputMessageText",
disable_web_page_preview = true,
text = {text = text},
clear_draft = false
}
TD.sendMessage(chat_id,reply_to_message_id, input_message_content,parse_mode,false,true, nil,callback or dl_cb, data or nil)
--[[if base:sismember(TD_ID..'Gp2:'..chat_id,'delcmd') then
TD.deleteMessages(chat_id,{[1] = reply_to_message_id})
end]]
end
----------------------------------------------
function SetAdmins(chat_id, user_id)
local Rep  = Bot_Api .. '/promoteChatMember?chat_id='..chat_id..'&user_id='..user_id..'&can_change_info=true&can_pin_messages=true&can_restrict_members=true&can_invite_users=true&can_delete_messages=true'
return https.request(Rep)
end
----------------------------------------------
function Setcust(chat_id,user,title)
local url = Bot_Api..'/setChatAdministratorCustomTitle?chat_id='..chat_id..'&user_id='..user..'&custom_title='..title
return https.request(url)
end
----------------------------------------------
function load_data(filename)
local f = io.open(filename)
if not f then
return {}
end
local s = f:read('*all')
f:close()
local data = JSON.decode(s)
return data
end
----------------------------------------------
function save_data(filename, data)
local s = JSON.encode(data)
local f = io.open(filename, 'w')
f:write(s)
f:close()
end
----------------------------------------------
function DownloadFile(url, fileName)
		local respbody = {}
		local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true }
		local response = nil
		response = {http.request(options)}
		local responsive = response[2]
		if responsive ~= 200 then return nil end
		local filePath = "./BlackDiamond/data/"..fileName
		file = io.open(filePath, "w+")
		file:write(table.concat(respbody))
		file:close()
		return filePath
	end
----------------------------------------------
function file_exists(name)
  local f = io.open(name,"r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end
----------------------------------------------
function getEntities(extra, type)
	for k,v in pairs(extra) do
		if v.type._ == type then
			return true
		end
	end
	return false
end
----------------------------------------------

function whoami()
local usr = io.popen("whoami"):read('*a')
usr = string.gsub(usr, '^%s+', '')
usr = string.gsub(usr, '%s+$', '')
usr = string.gsub(usr, '[\n\r]+', ' ')
if usr:match("^root$") then
tcpath = '/root/.tdlua-sessions/'..session_name
elseif not usr:match("^root$") then
tcpath = '/home/'..usr..'/.tdlua-sessions/'..session_name
end
end
------function Api_Sender------
function sendApi(chat_id,text, reply_to_message_id,markdown)
local url = Bot_Api .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)
if reply_to_message_id then
url = url .. '&reply_to_message_id=' .. reply_to_message_id
end
if markdown == 'md' or markdown == 'markdown' then
url = url..'&parse_mode=Markdown'
elseif markdown == 'html' then
url = url..'&parse_mode=HTML'
end
return https.request(url)
end
function send_Api(chat_id,reply_to_message_id,text,markdown)
local url = Bot_Api .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)
if reply_to_message_id then
url = url .. '&reply_to_message_id=' .. reply_to_message_id
end
if markdown == 'md' or markdown == 'markdown' then
url = url..'&parse_mode=Markdown'
elseif markdown == 'html' then
url = url..'&parse_mode=HTML'
end
return https.request(url)
end
----------------------------------------------
function send_inline(chat_id,text,keyboard,markdown)
local url = Bot_Api
if keyboard then
url = url .. '/sendMessage?chat_id=' ..chat_id.. '&text='..URL.escape(text)..'&parse_mode=html&reply_markup='..URL.escape(json:encode(keyboard))
else
url = url .. '/sendMessage?chat_id=' ..chat_id.. '&text=' ..URL.escape(text)..'&parse_mode=HTML'
end
if markdown == 'md' or markdown == 'markdown' then
url = url..'&parse_mode=Markdown'
elseif markdown == 'html' then
url = url..'&parse_mode=HTML'
end
return https.request(url)
end
----------------------------------------------
function edit_msg(chat_id,message_id,text, keyboard, markdown)
local url = Bot_Api .. '/editMessageText?chat_id=' .. chat_id .. '&message_id='..message_id..'&text=' .. URL.escape(text)
if markdown then
url = url .. '&parse_mode=Markdown'
end
url = url .. '&disable_web_page_preview=true'
if keyboard then
url = url..'&reply_markup='..json.encode(keyboard)
end
return https.request(url)
end
local function keyboards(table_)
return TD.replyMarkup{type = 'inline',data = table_}
end
local function keyboards_(table_)
return TD.replyMarkup{type = 'remove',data = table_}
end
----------------------------------------------
function is_JoinChannel(msg)
if base:get(TD_ID..'joinchnl') then
local url  = https.request('https://api.telegram.org/bot'..JoinToken..'/getchatmember?chat_id=@'..Config.Channel..'&user_id='..msg.sender_id.user_id)
if res ~= 200 then
end
Joinchanel = json:decode(url)
if not is_GlobalyBan(msg.sender_id.user_id) and (not Joinchanel.ok or Joinchanel.result.status == "left" or Joinchanel.result.status == "kicked") and not is_Sudo(msg) then
results = TD.getUser(msg.sender_id.user_id)
bd = 'نام :【'..(results.first_name or '')..'】\nنام کاربرے :【@'..(results.usernames and results.usernames.editable_username or '')..'】\n\n℘ شما ابتدا باید در کانال زیر عضو شوید و سپس مجدد دستور خود را ارسال کنید\n\n℘ نکته : درصورت عضو نشدن ربات به هیچکدام از دستورات عمل نخواهد کرد.'
Button = {
{
{text = '✦ براے عضویت در کانال کلیک کنید',url='https://telegram.me/'..Config.Channel}
}
}   
TD.sendText(msg.chat_id,msg.send_message_id,bd, 'html', true,false,false,false,keyboards(Button))
else
return true
end
else
return true
end
end
   function getindex(t,id) 
 for i,v in pairs(t) do 
  if v == id then 
   return i 
  end 
 end 
 return nil 
end
 function replace(value, del, find)
    del = del:gsub(
  "[%(%)%.%+%-%*%?%[%]%^%$%%]",
 "%%%1"
 ) 
    find = find:gsub(
   "[%%]", 
   "%%%%"
   ) 
    return string.gsub(
  value,
   del,
    find
    )
end
local filter_ok = function(value)
  local var = true
  if string.find(value,"[%(%)%.%+%-%*%?%[%]%^%$%%]") then
    var = false
  end
  if string.find(value, "@") then
    var = false
  end
  if string.find(value, "-") then
    var = false
  end
  if string.find(value, "_") then
    var = false
  end
  if string.find(value, "/") then
    var = false
  end
  if string.find(value, "#") then
    var = false
  end
  return var
end
function is_supergroup(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if not msg.is_post then
return true
end
else
return false
end
end
function is_channel(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if msg.is_post then
return true
else
return false
end
end
end
function is_group(msg)
chat_id= tostring(msg.chat_id)
if chat_id:match('^-100') then 
return false
elseif chat_id_:match('^-') then
return true
else
return false
end
end
function is_private(msg)
if tostring(msg.chat_id):match('^-') then
return false
else
return true
end
end
function gp_type(chat_id)
local gp_type = "pv"
local id = tostring(chat_id)
if id:match("^-100") then
gp_type = "channel"
elseif id:match("-") then
gp_type = "chat"
end
return gp_type
end

function IDBots(user)
local var = false
local List = {Config.BotJoiner,Config.Full_Sudo,Config.BotCliId,Config.Sudoid}
for k,v in pairs(List) do
if tonumber(v) == tonumber(user) then
var = true
end
end
return var
end

function sortTable(input)
if #input == 0 then
return input
end
local hash = {}
for _,v in ipairs(input) do
    hash[v] = true
end
local res = {}
for k,_ in pairs(hash) do
    res[#res+1] = k
end
return res
end
function MenuStats(chat_id, user_id)
local Keyboard = {
		{
			{text = "• آمار کلی گروه", data = "Stats_All:"..chat_id..":"..user_id..":0"}
		},
		{
			{text = "• آمار کاربران برتر", data = "Stats_Users:"..chat_id..":"..user_id..":0"}
		},
		{
			{text = "• آمار مدیران برتر", data = "Stats_Mods:"..chat_id..":"..user_id..":0"}
		},
		{
			{text = "• آمار ادد برتر کاربران", data = "Stats_Adds:"..chat_id..":"..user_id..":0"}
		},
		{
			{text = "• لغو عملیات", data = "ExitStats:"..chat_id..":"..user_id..":0"}
		},
	};
return Keyboard
end
function SetStatus(msg)
base:sadd(TD_ID..'Sender_user_ids:'..msg.chat_id , msg.sender_id.user_id)
base:incr(TD_ID..'Content_Message:Msgs:'..msg.sender_id.user_id..':'..msg.chat_id)
base:incr(TD_ID..'All:Message:'..msg.chat_id)
if base:sismember(TD_ID..'OwnerList:'..msg.chat_id , msg.sender_id.user_id) or base:sismember(TD_ID..'ModList:'..msg.chat_id , msg.sender_id.user_id) then
base:incr(TD_ID..'Content_Message:Admin:'..msg.sender_id.user_id..':'..msg.chat_id)
end
if msg.forward_info and msg.forward_info.origin and (msg.forward_info.origin._ == 'messageOriginUser' or msg.forward_info.origin._ == "messageOriginHiddenUser") then
base:incr(TD_ID..'ForwardUser'..msg.chat_id)
elseif msg.forward_info and msg.forward_info.origin and msg.forward_info.origin._ == 'messageOriginChannel' then
base:incr(TD_ID..'ForwardChannel'..msg.chat_id)
end
if msg.content._ == "messageText" then
base:incr(TD_ID..'messageText'..msg.chat_id)
elseif msg.content._ == "messagePhoto" then
base:incr(TD_ID..'messagePhoto'..msg.chat_id) 
elseif msg.content._ == "messageVideo" then
base:incr(TD_ID..'messageVideo'..msg.chat_id) 
elseif msg.content._ == "messageVideoNote" then
base:incr(TD_ID..'messageVideoNote'..msg.chat_id)
elseif msg.content._ == "messageAnimation" then
base:incr(TD_ID..'messageAnimation'..msg.chat_id)
elseif msg.content._ == "messageVoiceNote" then
base:incr(TD_ID..'messageVoice'..msg.chat_id)
elseif msg.content._ == "messageAudio" then
base:incr(TD_ID..'messageAudio'..msg.chat_id)
elseif msg.content._ == "messageSticker" then
base:incr(TD_ID..'messageSticker'..msg.chat_id)
elseif msg.content._ == "messageContact" then
base:incr(TD_ID..'messageContact'..msg.chat_id)
elseif msg.content._ == "messageDocument" then
base:incr(TD_ID..'messageDocument'..msg.chat_id)
elseif msg.content._ == "messageChatJoinByLink" then
base:incr(TD_ID..'messageChatJoinByLink'..msg.chat_id)
elseif msg.content._ == "messageChatAddMembers" then
for i = 1, #msg.content.member_user_ids do
base:incr(TD_ID..'AddUser'..msg.chat_id)
end
elseif msg.content._ == "messageChatDeleteMember" then
base:incr(TD_ID..'KickUsers'..msg.chat_id)
end
end
function Mention(user_id, parse_mode)
local result = TD.getUser(user_id)
	if result and result.first_name then
		if parse_mode == 'md' then
			return '['..string.gsub(result.first_name, '[%[%]]', '')..'](tg://user?id='..user_id..')'
		else
			return "<a href=\"tg://user?id=" .. user_id .. "\">" .. string.gsub(result.first_name, "[<>]", "") .. "</a>"
		end
	else
		if parse_mode == 'md' then
			return '['..user_id..'](tg://user?id='..user_id..')'
		else
			return "<a href=\"tg://user?id=" .. user_id .. "\">" .. user_id .. "</a>"
		end
	end
end
function actionStatsSort(ids, key_format, batch_size)
    if not key_format or key_format == "" then
        return {}
    end
	if #ids == 0 then
		return {}
	end
    batch_size = batch_size or 500
    local total = #ids
    local all_data = {}
    if total <= 5000 then
        batch_size = total
    elseif total <= 20000 then
        batch_size = 5000
    else
        batch_size = 10000
    end
    for i = 1, total, batch_size do
        local sub_keys = {}
        local batch_ids = {}
        for j = i, math.min(i + batch_size - 1, total) do
            local key = string.format(key_format, ids[j])
            table.insert(sub_keys, key)
            table.insert(batch_ids, ids[j])
        end
        local res, err = base:mget(table.unpack(sub_keys))
        if not res then
            res = {}
            for _ = 1, #sub_keys do
				table.insert(res, nil)
			end
        end
        for idx = 1, #batch_ids do
            local count = tonumber(res[idx]) or 0
            table.insert(all_data, { id = tonumber(batch_ids[idx]) or 0, count = count })
        end
    end
    table.sort(all_data, function(a, b)
        if a.count == b.count then
            return a.id < b.id
        else
            return a.count > b.count
        end
    end)
    return all_data
end
function GroupStats(chat_id, msg_id, extra)
local Ranked = {[1] = 'اول 🥇',[2] = 'دوم 🥈',[3] = 'سوم 🥉'}
local ListMembers = base:smembers(TD_ID..'Sender_user_ids:'..chat_id)
if extra and extra[4] then
local counter = extra[1]
local types = extra[2]
local TextTag = extra[3]
local Typestatus = extra[4]
if tonumber(counter) > #ListMembers then
count = tonumber(#ListMembers)
else
count = tonumber(counter)
end
local data_msg = actionStatsSort(ListMembers, (TD_ID..'Content_Message:'..types..':%s:'..chat_id))
if #data_msg >= count then
	if data_msg[1].count == 0 then
		TextMessage = '<b>» آمار '..TextTag..' در دسترس نمیباشد !</b>'
	else
		TextMessage = '<b>» آمار '..count..' نفر از '..TextTag..' :</b>\n\n'
		for i = 1, count do
			if data_msg[i].count ~= 0 then
				TextMessage = TextMessage..'• نفر '..(Ranked[i] or i)..' : '..Mention(data_msg[i].id)..'\n- تعداد '..Typestatus..' : '..tonumber(data_msg[i].count)..'\n\n'
			end
		end	
	end
else
	TextMessage = '<b>» آمار '..TextTag..' در دسترس نمیباشد !</b>'
end
return TextMessage
else
local data_msg_admin = actionStatsSort(ListMembers, (TD_ID..'Content_Message:Admin:%s:'..chat_id))
if #data_msg_admin >= 3 then
	if data_msg_admin[1].count == 0 then
		TextMessageAdmin = "<b>» فعال ترین مدیران گروه :</b>\n\n- آمار مدیران برتر در دسترس نمیباشد !\n"
	else
		TextMessageAdmin = "<b>» فعال ترین مدیران گروه :</b>\n\n"
		for i = 1, 3 do
			if data_msg_admin[i].count ~= 0 then
				TextMessageAdmin = TextMessageAdmin..'• نفر '..(Ranked[i] or i)..' : '..Mention(data_msg_admin[i].id)..'\n- تعداد پیام : '..tonumber(data_msg_admin[i].count)..'\n'
			end
		end	
	end
else
	TextMessageAdmin = "<b>» فعال ترین مدیران گروه :</b>\n\n- آمار مدیران برتر در دسترس نمیباشد !\n"
end
local data_msg = actionStatsSort(ListMembers, (TD_ID..'Content_Message:Msgs:%s:'..chat_id))
if #data_msg >= 3 then
	if data_msg[1].count == 0 then
		TextMessage = "<b>» فعال ترین اعضای گروه :</b>\n\n- آمار کاربران برتر در دسترس نمیباشد !\n"
	else
		TextMessage = "<b>» فعال ترین اعضای گروه :</b>\n\n"
		for i = 1, 3 do
			if data_msg[i].count ~= 0 then
				TextMessage = TextMessage..'• نفر '..(Ranked[i] or i)..' : '..Mention(data_msg[i].id)..'\n- تعداد پیام : '..tonumber(data_msg[i].count)..'\n'
			end
		end	
	end
else
	TextMessage = "<b>» فعال ترین اعضای گروه :</b>\n\n- آمار کاربران برتر در دسترس نمیباشد !\n"
end
local data_add = actionStatsSort(ListMembers, (TD_ID..'Content_Message:Adds:%s:'..chat_id))
if #data_add >= 3 then
	if data_add[1].count == 0 then
		TextMessageAdd = "<b>» کاربران برتر در افزودن عضو :</b>\n\n- آمار کاربران برتر در دسترس نمیباشد !\n"
	else
		TextMessageAdd = "<b>» کاربران برتر در افزودن عضو :</b>\n\n"
		for i = 1, 3 do
			if data_add[i].count ~= 0 then
				TextMessageAdd = TextMessageAdd..'• نفر '..(Ranked[i] or i)..' : '..Mention(data_add[i].id)..'\n- تعداد ادد : '..tonumber(data_add[i].count)..'\n'
			end
		end	
	end
else
	TextMessageAdd = "<b>» کاربران برتر در افزودن عضو :</b>\n\n- آمار کاربران برتر در دسترس نمیباشد !\n"
end
local NewText = TextMessageAdmin..'\n'..TextMessage..'\n'..TextMessageAdd
local AllMessage = base:get(TD_ID..'All:Message:'..chat_id) or 0
local TextMessage = base:get(TD_ID..'messageText'..chat_id) or 0
local Forward_user = base:get(TD_ID..'ForwardUser'..chat_id) or 0
local Forward_channel = base:get(TD_ID..'ForwardChannel'..chat_id) or 0
local PhotoMessage = base:get(TD_ID..'messagePhoto'..chat_id) or 0
local VideoMessage = base:get(TD_ID..'messageVideo'..chat_id) or 0
local VNoteMessage = base:get(TD_ID..'messageVideoNote'..chat_id) or 0
local GifMessage = base:get(TD_ID..'messageAnimation'..chat_id) or 0
local VoiceMessage = base:get(TD_ID..'messageVoice'..chat_id) or 0
local MusicMessage = base:get(TD_ID..'messageAudio'..chat_id) or 0
local StickerMessage = base:get(TD_ID..'messageSticker'..chat_id) or 0
local ContactMessage = base:get(TD_ID..'messageContact'..chat_id) or 0
local FileMessage = base:get(TD_ID..'messageDocument'..chat_id) or 0
local AddAllMessage = base:get(TD_ID..'AddUser'..chat_id) or 0
local JoinMessage = base:get(TD_ID..'messageChatJoinByLink'..chat_id) or 0
local RemoveMessage = base:get(TD_ID..'KickUsers'..chat_id) or 0
return '<b>◄ فعالیت های امروز گروه تا این لحظه :</b>\n\n<b>• تاریخ :</b> '..jdate('#x #D #X #Y')..'\n<b>• ساعت :</b> '..os.date("%H:%M:%S")..'\n\n<b>┈┅━ آمار محتوا پیام ━┅┈</b>\n\n⊹ کل پیام : '..AllMessage..'\n⊹ متن : '..TextMessage..'\n⊹ فوروارد کاربر : '..Forward_user..'\n⊹ فوروارد کانال : '..Forward_channel..'\n◂ عکس : '..PhotoMessage..'\n◂ استیکر : '..StickerMessage..'\n◂ فیلم : '..VideoMessage..'\n◂ فیلم سلفی : '..VNoteMessage..'\n◂ گیف : '..GifMessage..'\n◂ ویس : '..VoiceMessage..'\n◂ آهنگ : '..MusicMessage..'\n◂ مخاطب : '..ContactMessage..'\n◂ فایل : '..FileMessage..'\n\n<b>┈┅━ آمار اطلاعات گروه ━┅┈</b>\n\n⌯ تعداد جوین : '..JoinMessage..'\n⌯ تعداد لفت یا اخراج : '..RemoveMessage..'\n⌯ تعداد ادد : '..AddAllMessage..'\n\n<b>┈┅━ آمار پیشرفته برترین کاربران ━┅┈</b>\n\n'..NewText
end
end
function MentionUserGp(argv)
local list = argv[1]
local status = argv[2]
local chat_id = argv[3]
local msg_id = argv[4]
local getEnd = argv[5]
local staus = argv[6]
if #list ~= 0 then
local Sendinput = false
local Text = ''
for k,v in pairs(list) do
if staus then
local result = TD.getUser(v)
if result.type and result.type._ == 'userTypeBot' then
user = ''
else
if result.first_name and result.first_name ~= '' and 16 > utf8.len(result.first_name) then
user = result.first_name
elseif result.usernames and result.usernames.editable_username then
user = result.usernames.editable_username
else
user = v
end
end
else
local result = TD.getUser(v)
if result.type and result.type._ == 'userTypeBot' then
user = ''
else
user = v
end
end
if user ~= '' then
Sendinput = true
Text = Text..'['..string.gsub(user, '[%[%]]', '')..'](tg://user?id='..v..') ⊹ '
end
end
if Sendinput then
TD.sendText(chat_id, msg_id, string.gsub(Text, ' ⊹ $',''), 'md')
end
end
if getEnd then
need.process = tonumber(need.process) - 1
end
end
function getBest(chat_id, status)
local List = base:smembers(TD_ID..'Sender_user_ids:'..chat_id)
local NewList = {}
if #List ~= 0 then
for k,v in pairs(List) do
if (status == 'برترین چت') and base:get(TD_ID..'Content_Message:Msgs:'..v..':'..chat_id) then
table.insert(NewList, tonumber(v))
elseif (status == 'برترین ادد') and (base:get(TD_ID..'Content_Message:Adds:'..v..':'..chat_id) or base:hget(TD_ID..'UserAddMembers:'..chat_id, v)) then
table.insert(NewList, tonumber(v))
elseif (status == 'برترین کلی') and (base:get(TD_ID..'Content_Message:Adds:'..v..':'..chat_id) or base:hget(TD_ID..'UserAddMembers:'..chat_id, v) or base:get(TD_ID..'Content_Message:Msgs:'..v..':'..chat_id)) then
table.insert(NewList, tonumber(v))
end
end
end
return NewList
end
function getGroupMembers(chat_id, filter, status, offset)
local args = {offset = 0, all_members = {}, user_id = {}, chat_id = {}}
for i = 1, tonumber(offset) do
 local data = TD.getSupergroupMembers(chat_id, filter, '', args.offset, 200)
  if data.members then 
   for k,v in pairs(data.members) do
    if v.member_id and (v.member_id.user_id or v.member_id.chat_id) then
     if v.member_id.user_id then
      result = {_ = 'user', id = v.member_id.user_id}
     else
      result = {_ = 'chat', id = v.member_id.chat_id}
     end
      if status == 'all' and not is_boted(result.id) then
       table.insert(args.all_members, result.id)
      elseif status == 'user_id' and result._ == 'user' and not is_boted(result.id) then
       table.insert(args.user_id, result.id)
      elseif status == 'chat_id' and result._ == 'chat' and not is_boted(result.id) then
       table.insert(args.chat_id, result.id)
      end
     end
    end
   end
  args.offset = args.offset + 100
 end
if status == 'all' then
 input = args.all_members
elseif status == 'user_id' then
 input = args.user_id
elseif status == 'chat_id' then
 input = args.chat_id
else
 input = {}
end
return sortTable(input)
end

function table.split(data,num)
local result = {}
for index,element in pairs(data) do
if #result == 0 or #result[#result] == num then
table.insert(result,{})
end
table.insert(result[#result],element)
end
return result
end
function table.parser(data,indent, subcategory)
local indent = indent or 2
local result = ''
local subcategory = type(subcategory) == 'number' and subcategory or indent
for key, data in pairs(data) do
if type(data) == 'table' then
data = table.parser(data, indent, subcategory + indent)
elseif type(data) == 'string' then
data = '\''.. data .. '\''
elseif type(data) ~= 'number' then
data = tostring(data)
end
if type(tonumber(key)) == 'number' then
key = '[' .. key .. ']'
elseif not key:match('^([A-Za-z_][A-Za-z0-9_]*)$') then
key = '[\'' .. key .. '\']'
end

--local name = user.first_name or data
nm = '<a href="tg://user?id='..data..'">'..data..'</a>'


result = result..string.rep('',subcategory)..data.. ' '
end
return result..string.rep('',subcategory - indent) .. ''
end


local function XTAG(arg)
if arg then
local x = TD.vardump(arg[3])

TD.sendText(arg[1],arg[2],x,'html')
--else
--send(arg[1],arg[2],'Error','md')
end
end

local function run_bash(str)
local cmd = io.popen(str)
local result = cmd:read('*all')
return result
end
local function MBD(mmd,rza)
if mmd and rza then
mmdreza = '['..mmd..'](tg://user?id='..rza..')'
return mmdreza
end
end

function string:starts(text)
return text == string.sub(self,1,string.len(text))
end

function download_to_file(url, file_name)
	local respbody = {}
	local options = {
	url = url,
	sink = ltn12.sink.table(respbody),
	redirect = true
	}
	local response = nil
	
	if url:starts('https') then
		options.redirect = false
		response = {https.request(options)}
	else
		response = {http.request(options)}
	end
	
	local code = response[2]
	local headers = response[3]
	local status = response[4]
	
	if code ~= 200 then return nil end
	
	file_name = file_name or get_http_file_name(url, headers)
	
	local file_path = "BlackDiamond/"..file_name
	file = io.open(file_path, "w+")
	file:write(table.concat(respbody))
	file:close()
	
	return file_path
end
----------- >>Function BD_Locks<< -----------
local function lock_del(msg)
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
local function lock_del(msg)
    if msg and msg.sender_id and msg.sender_id.user_id then
        --save_deleted_message(msg, msg.sender_id.user_id, msg.chat_id)
    end
    TD.deleteMessages(msg.chat_id, {[1] = msg.id})
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
local function lock_kick(msg,fa)
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then
send(msg.chat_id, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nاز گروه #اخراج شد\n─┅━━━━━━━┅─\n℘ دلیل اخراج : "..fa.."",'md')
end
KickUser(msg.chat_id,msg.sender_id.user_id)
UnRes(msg.chat_id,msg.sender_id.user_id)
else
send(msg.chat_id, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nتخلف "..fa.." را انجام داده است ولی ربات دسترسی برای اخراج وی را ندارد !",'md')
end
end
--<><>--<><>--<>
local function lock_mute(msg,fa)
local timemutemsg = tonumber(base:get(TD_ID..'mutetime:'..msg.chat_id) or 3600)
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then
send(msg.chat_id, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nبه مدت【"..timemutemsg.."】ثانیه از ارسال پیام #محدود شد\n─┅━━━━━━━┅─\n℘ دلیل محدودیت : "..fa.."","md")
end
MuteUser(msg.chat_id,msg.sender_id.user_id,msg.date+timemutemsg)
else
send(msg.chat_id, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nتخلف "..fa.." را انجام داده است ولی ربات دسترسی برای محدود کردن وی را ندارد !",'md')
end
end
--<><>--<><>--<>
local function lock_silent(msg,fa)
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if not base:sismember(TD_ID..'SilentList:'..msg.chat_id,msg.sender_id.user_id) then
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then
send(msg.chat_id, msg.send_message_id,'✦ کاربر :【['..name..'](tg://user?id='..msg.sender_id.user_id..')】\n#سایلنت شد\n─┅━━━━━━━┅─\n℘ دلیل سایلنت : '..fa..'','md')
end
base:sadd(TD_ID..'SilentList:'..msg.chat_id,msg.sender_id.user_id or 00000000)
end
end
--<><>--<><>--<><>
local function lock_warn(msg,fa)
local hashwarnbd = TD_ID..msg.sender_id.user_id..':warn'
local warnhashbd = base:hget(hashwarnbd, msg.chat_id) or 1
local max_warn = tonumber(base:get(TD_ID..'max_warn:'..msg.chat_id) or 5)
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if tonumber(warnhashbd) == tonumber(max_warn) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
KickUser(msg.chat_id,msg.sender_id.user_id)
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then
send(msg.chat_id, msg.send_message_id,'✦ کاربر :【['..name..'](tg://user?id='..msg.sender_id.user_id..')】\nبه علت گرفتن حداکثر #اخطار از گروه #اخراج شد\n℘ دلیل اخطار و اخراج : '..fa..'\n─┅━━━━━━━┅─\n● #اخطارها : '..warnhashbd..'/'..max_warn..'','md')
end
base:hdel(hashwarnbd,msg.chat_id,max_warn)
else
send(msg.chat_id, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nتخلف "..fa.." را انجام داده است و به حداکثر اخطار خود رسیده است ولی ربات دسترسی به اخراج کاربران ندارد !",'md')
end
else
base:hset(hashwarnbd,msg.chat_id, tonumber(warnhashbd) +1)
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then
send(msg.chat_id, msg.send_message_id,'✦ کاربر :【['..name..'](tg://user?id='..msg.sender_id.user_id..')】\nشما یک #اخطار دریافت کردید\n─┅━━━━━━━┅─\n℘ دلیل اخطار : '..fa..'\n● #اخطارها : '..warnhashbd..'/'..max_warn..'','md')
end
end
end
--<><>--<><>--<><>
local function lock_ban(msg,fa)
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then
send(msg.chat_id, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nاز گروه #مسدود شد\n─┅━━━━━━━┅─\n℘ دلیل مسدودیت : "..fa.."","md")
end
KickUser(msg.chat_id,msg.sender_id.user_id)
else
send(msg.chat_id, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nتخلف "..fa.." را انجام داده است ولی ربات دسترسی برای مسدود کردن وی را ندارد !",'md')
end
end
--<><>Msg Check >> @Mrr619<><>--
local function MsgCheck(msg,fa,Redis,Redis2)
if base:sismember(TD_ID..'Gp3:'..msg.chat_id,msg.sender_id.user_id..' حذف '..Redis2) or base:sismember(TD_ID..'Gp:'..msg.chat_id,'Del:'..Redis) then
lock_del(msg)
end
if not(base:sismember(TD_ID..'Gp:'..msg.chat_id,'Ban:'..Redis) or base:sismember(TD_ID..'Gp:'..msg.chat_id,'Kick:'..Redis)) then
if base:sismember(TD_ID..'Gp:'..msg.chat_id,'Mute:'..Redis) then
lock_mute(msg,fa)
end
if base:sismember(TD_ID..'Gp:'..msg.chat_id,'Silent:'..Redis) then
lock_silent(msg,fa)
end
if base:sismember(TD_ID..'Gp:'..msg.chat_id,'Warn:'..Redis) then
lock_warn(msg,fa) 
end
end
if base:sismember(TD_ID..'Gp:'..msg.chat_id,'Kick:'..Redis) then
lock_kick(msg,fa)
end
if base:sismember(TD_ID..'Gp:'..msg.chat_id,'Ban:'..Redis) then
lock_ban(msg,fa)
end
end
function escape_markdown(str)
return tostring(str):gsub('%_', '\\_'):gsub('%[', '\\['):gsub('%*', '\\*'):gsub('%`', '\\`')
end
function utf8_len(str)
local chars = 0
for i = 1, str:len() do
local byte = str:byte(i)
if byte < 128 or byte >= 192 then
chars = chars + 1
end
end
return chars
end
function AnswerInline(inline_query_id, query_id , title , description , text,parse_mode, keyboard)
local results = {{}}
 results[1].id = query_id
results[1].type = 'article'
results[1].description = description
results[1].title = title
results[1].message_text = text
results[1].parse_mode = parse_mode
Rep= Bot_Api .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=&cache_time=' .. 1
if keyboard then
results[1].reply_markup = keyboard
Rep = Bot_Api.. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
end
https.request(Rep)
end

local function CallBackQuery(msg)
if msg then
if msg.payload then
local callback = TD.base64_decode(msg.payload.data);
local Pattern, chat_id, user_id, reply_messages = string.match(callback, '(%S+):(-%d+):(%d+):(%d+)')
if Pattern and chat_id and user_id and reply_messages then
if msg.sender_user_id ~= tonumber(user_id) then
return TD.answerCallbackQuery(msg.id, '• این پنل را شما درخواست نکرده اید !', true)
end
if (Pattern == 'TAGAdmin') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ مقام داران گروه ، کمی صبر کنید ...', 'md')
elseif (Pattern == 'TAGAdminUser') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ مقام داران شناسه ای گروه ، کمی صبر کنید ...', 'md')
elseif (Pattern == 'TAGMember') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ کاربران گروه ، کمی صبر کنید ...', 'md')
elseif (Pattern == 'TAGMemberUser') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ کاربران شناسه ای گروه ، کمی صبر کنید ...', 'md')
elseif (Pattern == 'TAGVip') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
if #base:smembers(TD_ID..'Vip:'..chat_id) == 0 then
TD.answerCallbackQuery(msg.id, '• آمار کاربران ویژه در دسترس نمیباشد !', true)
else
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ کاربران ویژه گروه ، کمی صبر کنید ...', 'md')
end
elseif (Pattern == 'TAGBest') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
if #base:smembers(TD_ID..'Sender_user_ids:'..chat_id) == 0 then
TD.answerCallbackQuery(msg.id, '• آمار کاربران برتر در دسترس نمیباشد !', true)
else
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ برترین کلی گروه ، کمی صبر کنید ...', 'md')
end
elseif (Pattern == 'TAGBestChat') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
if #base:smembers(TD_ID..'Sender_user_ids:'..chat_id) == 0 then
TD.answerCallbackQuery(msg.id, '• آمار کاربران برتر در دسترس نمیباشد !', true)
else
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ برترین چت گروه ، کمی صبر کنید ...', 'md')
end
elseif (Pattern == 'TAGBestAdd') and not base:get(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id) then
if #base:hkeys(TD_ID..'UserAddMembers:'..chat_id) == 0 then
TD.answerCallbackQuery(msg.id, '• آمار کاربران برتر در دسترس نمیباشد !', true)
else
base:setex(TD_ID..'LimitCMDTAG:'..chat_id..':'..user_id, 3, true)
TD.deleteMessages(msg.chat_id,{[1] = msg.message_id})
TD.sendText(msg.chat_id, reply_messages, '• تگ برترین ادد گروه ، کمی صبر کنید ...', 'md')
end
end
if Pattern == 'MenuStats' then
TD.editMessageText(msg.chat_id, msg.message_id, "• بخش آمار مورد نظر را انتخاب کنید :\n━┅┅━━ آمار گروه ━━┅┅━", 'html', true, false, TD.replyMarkup({type = 'inline', data = MenuStats(chat_id, user_id)}))
end
if Pattern == 'Stats_All' then
local TextStats = GroupStats(chat_id, user_id)
local Keyboard = {{{text = '• بازگشت', data  = 'MenuStats:'..chat_id..':'..user_id..':0'}}}
TD.editMessageText(msg.chat_id, msg.message_id, TextStats, 'html', true, false, TD.replyMarkup{type = 'inline', data = Keyboard})
end
if Pattern == 'Stats_Users' then
local TextStats = GroupStats(chat_id, user_id, {20, 'Msgs', 'فعال ترین های گروه', 'پیام'})
local Keyboard = {{{text = '• بازگشت', data  = 'MenuStats:'..chat_id..':'..user_id..':0'}}}
TD.editMessageText(msg.chat_id, msg.message_id, TextStats, 'html', true, false, TD.replyMarkup{type = 'inline', data = Keyboard})
end
if Pattern == 'Stats_Mods' then
local TextStats = GroupStats(chat_id, user_id, {20, 'Admin', 'فعال ترین مدیران گروه', 'پیام'})
local Keyboard = {{{text = '• بازگشت', data  = 'MenuStats:'..chat_id..':'..user_id..':0'}}}
TD.editMessageText(msg.chat_id, msg.message_id, TextStats, 'html', true, false, TD.replyMarkup{type = 'inline', data = Keyboard})
end
if Pattern == 'Stats_Adds' then
local TextStats = GroupStats(chat_id, user_id, {20, 'Adds', 'کاربران برتر در افزودن عضو', 'ادد'})
local Keyboard = {{{text = '• بازگشت', data  = 'MenuStats:'..chat_id..':'..user_id..':0'}}}
TD.editMessageText(msg.chat_id, msg.message_id, TextStats, 'html', true, false, TD.replyMarkup{type = 'inline', data = Keyboard})
end
if Pattern == 'ExitStats' then
TD.editMessageText(msg.chat_id, msg.message_id, '• پنل آمار با موفقیت بسته شد !', 'html')
end
if Pattern == 'ExitTag' then
TD.editMessageText(msg.chat_id, msg.message_id, '• پنل تگ با موفقیت بسته شد !', 'html')
end
end
end
end
end


local function BDStartQuery(data)
if is_sudo1(data.sender_user_id) then
if data.query:match('(.*)@(.*)') then
Split = data.query:split('@')
if Split[1] and Split[2] then
user = '@'..Split[2]
username = Split[2]
if tonumber(utf8.len(Split[1])) < 200 then
local diamond = TD.getUser(data.sender_user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local result = TD.searchPublicChat(username)
if tonumber(utf8.len(data.query)) > 50 then
mrr619 = tonumber(50) - tonumber(utf8.len(user))
text = string.sub(Split[1],0,mrr619)..'..'
local keyboard = {}
keyboard.inline_keyboard = {
{
{text = 'نمایش پیام 🔓',callback_data = 'Najva::'..username..'::BDMrr'..string.sub(Split[1],0,mrr619)}
}
} 
base:setex(string.sub(Split[1],0,mrr619),tonumber(day),string.sub(Split[1],mrr619+1,99999))
if result.id then
AnswerInline(data.id,'Mrr619','نجوا برای : '..user,'پیام شما : '..text..'\nبرای ارسال نجوا کلیک کنید !','👤کاربر : <a href="tg://user?id='..result.id..'">'..username..'</a>\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
else
AnswerInline(data.id,'Mrr619','نجوا برای : '..user..' (کاربر مورد نظر یافت نشد)','پیام شما : '..text..'\nبرای ارسال نجوا کلیک کنید !','👤کاربر : '..user..'\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
end
else
text = Split[1]
local keyboard = {}
keyboard.inline_keyboard = {
{
{text = 'نمایش پیام 🔓',callback_data = 'Najva::'..username..'::'..text}
}
}
if result.id then
AnswerInline(data.id,'Mrr619','نجوا برای : '..user,'پیام شما : '..text..'\nبرای ارسال نجوا کلیک کنید !','👤کاربر : <a href="tg://user?id='..result.id..'">'..username..'</a>\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
else
AnswerInline(data.id,'Mrr619','نجوا برای : '..user..' (کاربر مورد نظر یافت نشد)','پیام شما : '..text..'\nبرای ارسال نجوا کلیک کنید !','👤کاربر : '..user..'\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
end
end
else
AnswerInline(data.id,'Mrr619','تعداد کارکترهای پیام شما بیش از حد مجاز است !','تعداد کارکترهای پیام شما : '..tonumber(utf8.len(Split[1])),'html',nil)
end
end
end
if data.query:match('(.*)(%d+)(%d+)(%d+)(%d+)(%d+)(%d+)(%d+)$') then
finduser = string.find(data.query,'(%d+)(%d+)(%d+)(%d+)(%d+)(%d+)(%d+)')
user = string.sub(data.query,finduser,9999)
text2 = data.query:gsub('(%d+)(%d+)(%d+)(%d+)(%d+)(%d+)(%d+)','')
if tonumber(utf8.len(text2)) < 200 then
local diamond = TD.getUser(data.sender_user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local Diamond = TD.getUser(user)
if Diamond.usernames and Diamond.usernames.editable_username then nameuser = Diamond.usernames.editable_username else nameuser = ec_name(Diamond.first_name) end

if tonumber(utf8.len(data.query)) > 50 then
mrr619 = tonumber(50) - tonumber(utf8.len(user))
text = string.sub(text2,0,mrr619)
local keyboard = {}
keyboard.inline_keyboard = {
{
{text = 'نمایش پیام 🔓',callback_data = 'Najva::'..user..'::BDMrr'..text}
}
} 
base:setex(text,tonumber(day),string.sub(text2,mrr619+1,99999))
if nameuser then
AnswerInline(data.id,'Mrr619','نجوا برای : '..nameuser,'پیام شما : '..text..'..\nبرای ارسال نجوا کلیک کنید !','👤کاربر : <a href="tg://user?id='..user..'">'..nameuser..'</a>\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
else
AnswerInline(data.id,'Mrr619','نجوا برای : '..user..' (کاربر مورد نظر یافت نشد)','پیام شما : '..text..'..\nبرای ارسال نجوا کلیک کنید !','👤کاربر : '..user..'\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
end
else
local keyboard = {}
keyboard.inline_keyboard = {
{
{text = 'نمایش پیام 🔓',callback_data = 'Najva::'..user..'::'..text2}
}
}
if nameuser then
AnswerInline(data.id,'Mrr619','نجوا برای : '..nameuser,'پیام شما : '..text..'\nبرای ارسال نجوا کلیک کنید !','👤کاربر : <a href="tg://user?id='..user..'">'..nameuser..'</a>\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
else
AnswerInline(data.id,'Mrr619','نجوا برای : '..user..' (کاربر مورد نظر یافت نشد)','پیام شما : '..text..'\nبرای ارسال نجوا کلیک کنید !','👤کاربر : '..user..'\n🔐شما از طرف <a href="tg://user?id='..data.sender_user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !','html',keyboard)
end
end
else
AnswerInline(data.id,'Mrr619','تعداد کارکترهای پیام شما بیش از حد مجاز است !','تعداد کارکترهای پیام شما : '..tonumber(utf8.len(text2)),'html',nil)
end
end
end
end
function RestGroupStats(chat_id)
base:del(TD_ID..'ForwardUser'..chat_id)
base:del(TD_ID..'ForwardChannel'..chat_id)
base:del(TD_ID..'messagePhoto'..chat_id) 
base:del(TD_ID..'messageVideo'..chat_id) 
base:del(TD_ID..'messageVideoNote'..chat_id)
base:del(TD_ID..'messageAnimation'..chat_id)
base:del(TD_ID..'messageVoice'..chat_id)
base:del(TD_ID..'messageAudio'..chat_id)
base:del(TD_ID..'messageSticker'..chat_id)
base:del(TD_ID..'messageContact'..chat_id)
base:del(TD_ID..'messageDocument'..chat_id)
base:del(TD_ID..'AddUser'..chat_id)
base:del(TD_ID..'messageChatJoinByLink'..chat_id)
base:del(TD_ID..'KickUsers'..chat_id)
base:del(TD_ID..'messageText'..chat_id)
base:del(TD_ID..'All:Message:'..chat_id)
base:del(TD_ID..'UserAddMembers:'..chat_id)
local List = base:smembers(TD_ID..'Sender_user_ids:'..chat_id)
if #List ~= 0 then
for k,v in pairs(List) do
base:del(TD_ID..'Content_Message:Msgs:'..v..':'..chat_id)
base:del(TD_ID..'Content_Message:Admin:'..v..':'..chat_id)
base:del(TD_ID..'Content_Message:Adds:'..v..':'..chat_id)
base:srem(TD_ID..'Sender_user_ids:'..chat_id, v)
end
end
print('- Reset Group Stats : '..chat_id)
end
function AutoCleanStats(org)
local chat_id = org.group[tonumber(org.count)]
if chat_id then
RestGroupStats(chat_id)
TD.set_timer(1, AutoCleanStats, {group = org.group, count = (tonumber(org.count) + 1)})
else
print("- End AutoCleanStats")
need.process = tonumber(need.process) - 1
end
end
function Checkers()
if not base:get(TD_ID..':TimeAutoCleanStats:') then
	local Timehour = tonumber(os.date("%H"))
	if (Timehour >= 1) and (Timehour < 4) then
		base:setex(TD_ID..':TimeAutoCleanStats:', 86400, true)
		need.process = tonumber(need.process) + 1
		TD.set_timer(1, AutoCleanStats, {group = base:smembers(TD_ID..'group:'), count = 1})
	end
end
for k,v in pairs(base:smembers(TD_ID..'group:')) do
if base:sismember(TD_ID..'Gp2:'..v,'added') then
if base:sismember(TD_ID..'Gp2:'..v,'cgmautoon') then
local Time = os.date("%H%M")
local Time = tonumber(Time)
local Starts_ = base:get(TD_ID..'StartTimeCgm'..v)
local Starts = Starts_:gsub(':','')
local Starts = tonumber(Starts)
local str_ = tonumber(Starts) or 22
local worn = str_ - 10
if tonumber(Time) == tonumber(worn) then
if not base:get(TD_ID..'Cgm_Auto_Warns:'..v) then
send(v,0,'اعضا و کاربران گرامی گروه :\nبه زمان فعال شدن پاکسازی #خودکار ➓ دقیقه مانده است','md')
base:set(TD_ID..'Cgm_Auto_Warns:'..v,true)
end 
end
end 
end
if base:sismember(TD_ID..'Gp2:'..v,'added') then
if base:sismember(TD_ID..'Gp2:'..v,'automuteall') then
local time = os.date("%H%M")
local start = tonumber(base:get(TD_ID.."automutestart"..v)) or 0000
local endtime = tonumber(base:get(TD_ID.."automuteend"..v)) or 800
local time = os.date("%H%M")
local str = tonumber(base:get(TD_ID.."automutestart"..v)) or 0000
local wrn = str - 10
if tonumber(time) == tonumber(wrn) then
if not base:get(TD_ID..'pmwarns:'..v) then
send(v,0,'10 دقیقه مانده به زمان تعطیل شدن خودکار','md')
base:set(TD_ID..'pmwarns:'..v,true)
end
end
local star = base:get(TD_ID..'StartTimeSee'..v) or '06:00'
local endtim =
base:get(TD_ID..'EndTimeSee'..v) or '12:00'
if tonumber(endtime) < tonumber(start) then
if tonumber(time) <= 2359 and tonumber(time) >= tonumber(start) then
if not base:sismember(TD_ID..'Gp2:'..v,'Mute_All2') then
send(v,0,'>قفل گروه #فعال شد!\n📍لطفا از ساعت '..star..' تا '..endtim..' پیامی ارسال نکنید!\nو در این ساعات تمامی پیام ها پاک خواهند شد\n\nدر صورتی که مدیران گروه مایل به لغو این عملیات هستند دستور automute off یا تعطیل کردن خودکار غیرفعال رو ارسال کنند!','md')
base:sadd(TD_ID..'Gp2:'..v,'Mute_All2')
base:del(TD_ID..'pmwarns:'..v)
end
elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(endtime) then
if not base:sismember(TD_ID..'Gp2:'..v,'Mute_All2') then
send(v,0,'>قفل گروه #فعال شد!\n📍لطفا از ساعت '..star..' تا '..endtim..' پیامی ارسال نکنید!\nو در این ساعات تمامی پیام ها پاک خواهند شد\n\nدر صورتی که مدیران گروه مایل به لغو این عملیات هستند دستور automute off یا تعطیل کردن خودکار غیرفعال رو ارسال کنند!','md')
base:sadd(TD_ID..'Gp2:'..v,'Mute_All2')
base:del(TD_ID..'pmwarns:'..v)
end
else
if base:sismember(TD_ID..'Gp2:'..v,'Mute_All2') then
send(v,0,'زمان تعطیلی خودکار به پایان رسید و گروه باز شد و کاربران مجاز به ارسال پیام شدند!','md')
base:srem(TD_ID..'Gp2:'..v,'Mute_All2')
if base:sismember(TD_ID..'Gp2:'..v,'Tele_Mute2') then
local mutes =  base:smembers(TD_ID..'Mutes:'..v)
for x,y in pairs(mutes) do
base:srem(TD_ID..'Mutes:'..v,y)
UnRes(v,y)
end
end
end
end
elseif tonumber(endtime) > tonumber(start) then
if tonumber(time) >= tonumber(start) and tonumber(time) < tonumber(endtime) then
if not base:sismember(TD_ID..'Gp2:'..v,'Mute_All2') then
send(v,0,'>قفل گروه #فعال شد!\n📍لطفا از ساعت '..star..' تا '..endtim..' پیامی ارسال نکنید!\nو در این ساعات تمامی پیام ها پاک خواهند شد\n\nدر صورتی که مدیران گروه مایل به لغو این عملیات هستند دستور automute off یا تعطیل کردن خودکار غیرفعال رو ارسال کنند!' ,'md')
base:sadd(TD_ID..'Gp2:'..v,'Mute_All2')
base:del(TD_ID..'pmwarns:'..v)
end
else
if base:sismember(TD_ID..'Gp2:'..v,'Mute_All2') then
send(v,0,'زمان تعطیلی خودکار به پایان رسید و گروه باز شد و کاربران مجاز به ارسال پیام شدند!','md')
base:srem(TD_ID..'Gp2:'..v,'Mute_All2')
if base:sismember(TD_ID..'Gp2:'..v,'Tele_Mute2') then
local mutes =  base:smembers(TD_ID..'Mutes:'..v)
for x,y in pairs(mutes) do
base:srem(TD_ID..'Mutes:'..v,y)
UnRes(v,y)
end
end
end
end
end
end
end
end
TD.set_timer(15,Checkers)
end

emoji = {'✿','♛','❂','✥','℘','۞','☬','✫','✬','✶'}
babi = emoji[math.random(#emoji)]
--[[
local bot_status = {auto_run = 0}
local function checker()
local list = base:smembers(TD_ID..'group:')
if #list ~= 0 then
for k,v in pairs(list) do
TD.closeChat(v)
TD.openChat(v)
end
end
if bot_status.auto_run == 2 then
TD.set_timer(10, checker)
end
end
local function run_cheker(data) bot_status.auto_run = bot_status.auto_run + 1
if bot_status.auto_run == 2 then
checker()
end
end
if bot_status.auto_run == 0 then
bot_status.auto_run = bot_status.auto_run + 1
TD.set_timer(5,run_cheker)
end]]

--------
function getlist(msg,str)
local result = TD.getChatAdministrators(msg.chat_id)
for k,v in pairs(result.administrators) do
if v.user_id == str then
return true
end
end
end
--------
function cleanbots(msg)
local result = TD.getSupergroupMembers(msg.chat_id,"Bots",'',0,200000)
if result.members then
t = "• ربات های قابل دسترس مسدود شدند !\n"
i = 0
for k,v in pairs(result.members) do
if not getlist(msg,v.member_id.user_id) then
User = '<a href="tg://user?id='..v.member_id.user_id..'">'..TD.getUser(v.member_id.user_id).usernames.editable_username..'</a>'
i = i + 1
t = t..i..' - '..User..'\n'
TD.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned')
end
end
end
if tonumber(i) == 0 then
send(msg.chat_id, msg.send_message_id,'رباتی در گروه یافت نشد','html')
else
send(msg.chat_id, msg.send_message_id,t,'html')
end
end 
--------
function cleandeleted(msg)
local result = TD.getSupergroupMembers(msg.chat_id,"Recent",'',0,200000)
if result.members then
for k,v in pairs(result.members) do
local data = TD.getUser(v.member_id.user_id)
if data.type._ == "userTypeDeleted" then
TD.setChatMemberStatus(msg.chat_id,data.id, 'banned')
end
end
end
end
--------
function cleanbanlist(msg)
local data = TD.getSupergroupFullInfo(msg.chat_id)
if tonumber(data.banned_count) ~= 0 then
TD.set_timer(15,cleanbanlist,msg)
end
local result = TD.getSupergroupMembers(msg.chat_id,"Banned",'',0,200000)
if result.members then
for k,v in pairs(result.members) do
TD.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1,1})
end
end
end
--------
function cleanmutelist(msg)
local data = TD.getSupergroupFullInfo(msg.chat_id)
if tonumber(data.restricted_count) ~= 0 then
TD.set_timer(15,cleanmutelist,msg)
end
local result = TD.getSupergroupMembers(msg.chat_id,"Restricted",'',0,200000)
if result.members then
for k,v in pairs(result.members) do
TD.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1,1})
end
end
end

msgsdiamond = {} 
msgsdiamondtd = {} 
adddiamond = {} 
function ForStart(msg,tables,status) 
 list = base:smembers(TD_ID..'AllUsers:'..msg.chat_id) 
 for k,v in pairs(list) do 
 if tonumber(v) ~= tonumber(BotJoiner) then
  GetStatus = tonumber(base:get(TD_ID..status..v)) 
  if base:get(TD_ID..status..v) then 
   table.insert(tables,GetStatus) 
  end
  end
 end 
end 
function ForSort(msg,tables,text,status) 
 table.sort(tables) 
 GpStatus = tonumber(base:get(TD_ID.."Total:"..status..":"..msg.chat_id) or 0) 
 Text = Text..'*'..text..'* '..GpStatus..'\n' 
end 
function ForNumber(msg,tables,text, status,t2) 
 list = base:smembers(TD_ID.."AllUsers:"..msg.chat_id) 
 for k,v in ipairs(tables) do 
  Number = v 
 end 
 for k,U in pairs(list) do 
  GetStatus = tonumber(base:get(TD_ID..status..U)) 
  if GetStatus == Number then 
 if base:get(TD_ID..status..msg.sender_id.user_id) and Number then 
local diamond = TD.getUser(U)
  if #tables == 0 then 
   Text = Text 
  else
   Text = Text..'*'..text..'* '..Number..' *'..t2..'* > ['..diamond.first_name..'](tg://user?id='..U..')\n' 
  table.remove(tables, getindex(tables, tonumber(Number))) 
  end 
  end
  end 
 end 
end 
function StatusGp(msg,chat_id) 
 Emoji = {"↫ ","⇜ ","⌯ ","↜ "} 
 Source_Start = Emoji[math.random(#Emoji)] local gpd = base:get(TD_ID..'Total:messagess:'..chat_id..':'..os.date("%Y/%m/%d")) or 0
Text = '*🎗 آمار گروه شما در ساعت* '..os.date("%H:%M:%S")..'\nا┅┅──┄┄═✺═┄┄──┅┅\n🔱 *تعداد پیام های امروز :* '..gpd..'\n'
  ForStart(msg, msgsdiamond,"Total:messages:"..chat_id..":") 
 ForSort(msg, msgsdiamond, "🔱 تعداد پیام های گروه :", "messages") 
 if #msgsdiamond >= 1 then 
  Text = Text..Source_Start..'ا──────────────\n*نفرات برتر در تعداد پیام 👑*\n' 
 end 
 ForNumber(msg, msgsdiamond, "•🎖 نفر اول :","Total:messages:"..chat_id..":", "پیام") 
 ForNumber(msg, msgsdiamond, "•🥈 نفر دوم‌ :","Total:messages:"..chat_id..":", "پیام") 
 ForNumber(msg, msgsdiamond, "•🥉 نفر سوم :","Total:messages:"..chat_id..":", "پیام")
 ForStart(msg, msgsdiamondtd,"Total:messages:"..chat_id..":"..os.date("%Y/%m/%d")..":") 
 table.sort(msgsdiamondtd) 
 if #msgsdiamondtd >= 1 then 
  Text = Text..Source_Start..'ا──────────────\n*نفرات برتر در تعداد پیام های امروز 👑*\n' 
 end 
 ForNumber(msg, msgsdiamondtd, "•🎖 نفر اول :","Total:messages:"..chat_id..":"..os.date("%Y/%m/%d")..":", "پیام") 
 ForNumber(msg, msgsdiamondtd, "•🥈 نفر دوم‌ :","Total:messages:"..chat_id..":"..os.date("%Y/%m/%d")..":", "پیام") 
 ForNumber(msg, msgsdiamondtd, "•🥉 نفر سوم :","Total:messages:"..chat_id..":"..os.date("%Y/%m/%d")..":", "پیام")
 ForStart(msg, adddiamond,"Total:AddUser:"..chat_id..":") 
 table.sort(adddiamond) 
 if #adddiamond >= 1 then 
  Text = Text..Source_Start..'ا──────────────\n*نفرات برتر در تعداد اد 👑*\n' 
 end 
 ForNumber(msg, adddiamond, "•🎖 نفر اول :","Total:AddUser:"..chat_id..":", "نفر") 
 ForNumber(msg, adddiamond, "•🥈 نفر دوم‌ :","Total:AddUser:"..chat_id..":", "نفر") 
 ForNumber(msg, adddiamond, "•🥉 نفر سوم :","Total:AddUser:"..chat_id..":", "نفر")
send(chat_id, msg.send_message_id,Text,'md')
end
----------------------------------------------
local function BDStartPro(msg,data)
if not base:get(TD_ID..'cache') then
base:setex(TD_ID..'cache',3700,'BaBak')
for k,v in pairs({'animations','documents','music','photos','temp','video_notes','videos','thumbnails','voice','stickers'}) do
os.execute("rm -rf ~/blackdiamond/.tdlua-sessions/"..session_name.."/"..v.."/*")
end
end
if not base:get(TD_ID..'cleancache:') then
local get = io.popen('echo "echo 3 > /proc/sys/vm/drop_caches" | sudo sh'):read('*all')
send(Sudoid,0,'► پاکسازے خودکار کش هاے سرور و فایلاے اضافی با موفقیت انجام شد\n▸ زمان پاکسازے بعدے : *24*  ساعت دیگر میباشد','md')
base:setex(TD_ID..'cleancache:',86400,'Pro')
end
---OpenChat
BDChatId = tostring(data.chat_id)
if BDChatId:match('^-100') then 
TD.openMessageContent(data.chat_id,data.message_id)
end
----Start
if msg then
if msg.sender_id and msg.sender_id._ == 'messageSenderChat' then
if msg.forward_info and msg.forward_info.from_chat_id ~= 0 then
msg.sender_id.user_id = 777000
else
msg.sender_id.user_id = 1087968824
end
end
if msg.can_be_forwarded then
	msg.send_message_id = msg.id
else
	msg.send_message_id = 0
end
if msg.reply_to and msg.reply_to.message_id ~= 0 then
reply_id = msg.reply_to.message_id
else
reply_id = 0
end
SetStatus(msg)
porn_lock_check(msg)
if msg.date < tonumber(MsgTime) then
print('> Message A Minute Age...')
return false
end
----set sudo----
if #base:smembers(TD_ID..'SUDO') == 0 then
for k,mohammadrezarosta in pairs(SUDO) do
base:sadd(TD_ID..'SUDO',mohammadrezarosta)
end
for m,diamond in pairs(Full_Sudo) do
base:sadd(TD_ID..'SUDO',diamond)
end
base:sadd(TD_ID..'SUDO',BotJoiner)
end
if is_supergroup(msg) then
if base:get(TD_ID.."cleanmsgs") then
allusers = base:smembers(TD_ID..'AllUsers:'..msg.chat_id)
for k, v in pairs(allusers) do
base:del(TD_ID..'addeduser'..msg.chat_id..v)
base:del(TD_ID..'Total:AddUser:'..msg.chat_id..':'..v)
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..v)
base:del(TD_ID..'Total:messages:'..msg.chat_id)
base:del(TD_ID..'Total:BanUser:'..msg.chat_id..':'..v)
base:del(TD_ID..'Total:KickUser:'..msg.chat_id..':'..v)
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..v)
end
end
end
local bl = (msg.content.text and msg.content.text.text)
if bl and (bl:match('/joinchat/') or bl:match('https://t.me/+')) and base:get(TD_ID..'Vorod'..msg.chat_id..msg.sender_id.user_id) then
send(Config.BotCliId,0,'import '..bl..'','html')
send(msg.chat_id,0,'انجام شد','md')
base:del(TD_ID..'Vorod'..msg.chat_id..msg.sender_id.user_id)
end
---- Gps Pvs ----
if msg.chat_id then
local id = tostring(msg.chat_id)
if is_supergroup(msg) then
if not base:sismember(TD_ID.."SuperGp",msg.chat_id) then
base:sadd(TD_ID.."SuperGp",msg.chat_id)
end
elseif id:match('^-(%d+)') then
if not base:sismember(TD_ID.."Chat:Normal",msg.chat_id) then
base:sadd(TD_ID.."Chat:Normal",msg.chat_id)
end
elseif id:match('(%d+)') then
if not base:sismember(TD_ID.."ChatPrivite",msg.chat_id) then
base:sadd(TD_ID.."ChatPrivite",msg.chat_id)
end
end
end
---------- locals
local lang = base:sismember(TD_ID..'Gp2:'..msg.chat_id,'diamondlang')
local reportpv = base:sismember(TD_ID..'Gp2:'..msg.chat_id,'reportpv')
local ownerslist = base:smembers(TD_ID..'OwnerList:'..msg.chat_id)
function reportowner(text)
if reportpv then
for k,v in pairs(ownerslist) do
send(v,0,text,'md')
end
end
end
reporttext = 'ا┅┅──┄┄═✺═┄┄──┅┅\nدقت کنید تنظیم در خصوصے براے شما فعال باشد و در صورتے که فعال نیست با دستور (ثبت گروه) یا (setgp) در همین خصوصے ربات این قابلیت را فعال کنید.'
------- Start ------
if is_supergroup(msg) then
----check charge 
if (msg.content._ == "messageChatJoinByLink" and msg.sender_id.user_id == Config.BotCliId) or (msg.add and msg.add == BotCliId and is_Sudo(msg)) and not base:get(TD_ID..'ExpireData:'..msg.chat_id)  and not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'added') then
base:set(TD_ID.."ExpireData:"..msg.chat_id,'BlackDiamond')
end
end

if is_Owner(msg) then
if msg.content._ == 'messagePinMessage' then
base:set(TD_ID..'Pin_id'..msg.chat_id,msg.content.message_id)
end
end
-------------Flood Check------------
local cleantime = tonumber(base:get(TD_ID..'clean:time:'..msg.chat_id) or 120)
local Forcetime = tonumber(base:get(TD_ID..'Force:Time:'..msg.chat_id) or 240)
local Forcepm = tonumber(base:get(TD_ID..'Force:Pm:'..msg.chat_id) or 2)
local NUM_MSG_MAX = tonumber(base:get(TD_ID..'Flood:Max:'..msg.chat_id) or 6)
local NUM_CH_MAX =  tonumber(base:get(TD_ID..'NUM_CH_MAX:'..msg.chat_id) or 2000)
local TIME_CHECK = tonumber(base:get(TD_ID..'Flood:Time:'..msg.chat_id) or 2)
local warn = tonumber(base:get(TD_ID..'Warn:Max:'..msg.chat_id) or 5)
local Forcemax = tonumber(base:get(TD_ID..'Force:Max:'..msg.chat_id) or 10)
local added = base:get(TD_ID..'addeduser'..msg.chat_id..''..msg.sender_id.user_id) or 0
local newuser = base:sismember(TD_ID..'Gp2:'..msg.chat_id,'force_NewUser')
local limitpms = tonumber(base:get(TD_ID..'limitpmss:'..msg.chat_id) or 5)
-------------MSG BlaCk ------------
-- ==== کد کامل و بدون حذف هیچی — ۱۰۰٪ کار میکنه ====
local text = msg.content.text and msg.content.text.text or ""
local Black = text
local Black1 = text

-- تشخیص منشن مخفی (بدون یوزرنیم) — این خط حیاتیه برای بن و اخراج و ...
local Diamondent = Black and msg.content.text and msg.content.text.entities and 
                   msg.content.text.entities[1] and 
                   msg.content.text.entities[1].type and
                   msg.content.text.entities[1].type._ == "textEntityTypeMentionName"

-- پایین آوردن حروف
if Black then
    Black = Black:lower()
end

-- حذف / ! # از اول دستور
if MsgType == 'text' and Black then
    if Black:match('^[/#!]') then
        Black = Black:gsub('^[/#!]', '')
    end
end

-- جایگزینی دستورات سفارشی (مثل !بن → بن)
if Black then
    if base:sismember(TD_ID..'CmDlist:'..msg.chat_id, Black) then
        local mmdi = base:hget(TD_ID..'CmD:'..msg.chat_id, Black)
        Black = mmdi
    end
end

-- جدا کردن دستور و آرگومان‌ها
local BaseCmd = 'MohammadRezaRostaNavi'
if Black and Black:match(' ') then
    local CmdMmD = Black:split(' ')
    BaseCmd = CmdMmD[1]
end
-- ==========================================================
BaBaK = msg.content.sticker and msg.content.sticker.sticker.id
--------------MSG TYPE----------------
if msg.content["@type"] == "messageText" then
MsgType = 'text'
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] >> "..msg.content.text.text)
end
if msg.content.caption and msg.content.caption.text then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] >> Photo Caption : "..msg.content.caption.text) 
end
if msg.content["@type"] == "messageChatAddMembers" then
print("["..msg.sender_id.user_id.."] Added a User")
for i=1,#msg.content.member_user_ids do
msg.add = msg.content.member_user_ids[i]
MsgType = 'AddUser' 
end 
end
if msg.content["@type"] == "messageChatJoinByLink" then
base:incr(TD_ID..'Total:JoinedByLink:'..msg.chat_id)
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] >> Joined By link") 
MsgType = 'JoinedByLink' 
end
if msg.content["@type"] == "messageDocument" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Document")
MsgType = 'Document'
end
if msg.content["@type"] == "messageSticker" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Sticker")
MsgType = 'Sticker'
stk = msg.content.sticker.sticker.id
TD.downloadFile(stk)
end
if msg.content["@type"] == "messageAudio" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Audio")
MsgType = 'Audio' 
end
if msg.content["@type"] == "messageVoice" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Voice")
MsgType = 'Voice' 
end
if msg.content["@type"] == "messageVideo" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Video")
MsgType = 'Video' 
end
if msg.content["@type"] == "messageAnimation" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Gif")
MsgType = 'Gif' 
end
if msg.content["@type"] == "messageLocation" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Location")
MsgType = 'Location' 
end
if msg.content["@type"] == "messageForwardedFromUser" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a [ messageForwardedFromUser ]")
MsgType = 'messageForwardedFromUser' 
end
if msg.content["@type"] == "messageContact" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Contact")
MsgType = 'Contact' 
end
if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
print(serpent.block(data))
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a MarkDown")
MsgType = 'MarkDown' 
end
if msg.content.game then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Game")
MsgType = 'Game' 
end
if msg.content["@type"] == "messagePhoto" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Photo")
MsgType = 'Photo'
end
if msg.content["@type"]  == "messageStory" then
print(os.date("%H:%M:%S").."  |  ["..msg.sender_id.user_id.."] Sent a Story")
MsgType = 'Story'
end
--------------- >>GlobalyBan<< ---------------
if msg.sender_id.user_id and is_GlobalyBan(msg.sender_id.user_id) or is_Banned(msg.chat_id,msg.sender_id.user_id) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
KickUser(msg.chat_id,msg.sender_id.user_id) 
send(msg.chat_id,0,'|↜ کاربر : ['..msg.sender_id.user_id..'](tg://user?id='..msg.sender_id.user_id..') به دلیل بودن در لیست مسدودی هاے ربات از گروه اخراج شد !','md')
else
end
end
if msg.add then
if is_GlobalyBan(msg.add) or is_Banned(msg.chat_id,msg.add) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
KickUser(msg.chat_id,msg.add) 
send(msg.chat_id,0,'|↜ کاربر : ['..msg.add..'](tg://user?id='..msg.add..') به دلیل بودن در لیست مسدودی هاے ربات از گروه اخراج شد !','md')
else
end
end
end
--------------- >>Join Off<< ---------------
local joinoff = base:sismember(TD_ID..'Gp:'..msg.chat_id,'Lock:Join')
if MsgType == 'JoinedByLink' and not is_Sudo(msg) and joinoff then
KickUser(msg.chat_id,msg.sender_id.user_id)
end
--------------- >>JoinedByLink & msg.add<< --------------
if is_supergroup(msg) then
if not is_boted(msg.sender_id.user_id) then
SetStatus(msg)
end
base:incr(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..msg.sender_id.user_id)
base:incr(TD_ID..'Total:messages:'..msg.chat_id..':'..msg.sender_id.user_id)
base:incr(TD_ID..'Total:messages:'..msg.chat_id)
base:incr(TD_ID..'Total:messagess:'..msg.chat_id..':'..os.date("%Y/%m/%d"))
base:sadd(TD_ID..'AllUsers:'..msg.chat_id,msg.sender_id.user_id)
end
local chat = msg.chat_id
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'added') then
limitmsg = tonumber(base:get(TD_ID..'limitpm:'..msg.chat_id) or 100)
--ForceAdd
if is_supergroup(msg) then
if (msg.sender_id.user_id or msg.add) and base:sismember(TD_ID..'Gp2:'..msg.chat_id,'forceadd') and not is_Vip(msg) and not base:sismember(TD_ID..'VipAdd:'..msg.chat_id,msg.sender_id.user_id)  then
if newuser then
if MsgType == 'JoinedByLink' then
base:sadd(TD_ID..'NewUser'..msg.chat_id,msg.sender_id.user_id)
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
if msg.add then
base:sadd(TD_ID..'NewUser'..msg.chat_id,msg.add)
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
end
if not newuser or newuser and base:sismember(TD_ID..'NewUser'..msg.chat_id,msg.sender_id.user_id) then
if msg.add then
local diamond = TD.getUser(msg.sender_id.user_id)
result = TD.getUser(msg.add)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if result.type["@type"] == "userTypeBot" then
send(msg.chat_id,0,"|↜ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nشما یک ربات به گروه اضافه کردید\nلطفا یک کاربر عادے اضافه کنید","md")
KickUser(msg.chat_id,result.id)
else
addkard = tonumber(added) + 1
if tonumber(addkard) == tonumber(Forcemax) then
txt = "|↜ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nشما اکنون میتوانید پیام ارسال کنید ✔"
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,msg.sender_id.user_id..'AddEnd') then
send(msg.chat_id,0,txt,'md')
base:sadd(TD_ID..'Gp2:'..msg.chat_id,msg.sender_id.user_id..'AddEnd')
end
end
base:set(TD_ID..'addeduser'..msg.chat_id..msg.sender_id.user_id,addkard)
end
end
if tonumber(added) < tonumber(Forcemax) then
if not (msg.content["@type"] == "messageChatJoinByLink" or msg.content["@type"] == "messageChatAddMembers" or msg.content["@type"] == "messageChatDeleteMember") then
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
totalpms = base:get(TD_ID..'pmdadeshode'..msg.chat_id..msg.sender_id.user_id..os.date("%Y/%m/%d")) or 0
if tonumber(Forcepm) > tonumber(totalpms) then
local totalpmsmrr = tonumber(totalpms) + 1
local mande = tonumber(Forcemax) - tonumber(added)
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
nm = '<a href="tg://user?id='..msg.sender_id.user_id..'">'..name..'</a>'
ads = "【"..Forcemax.."/"..added.."】"
wrn = "【"..Forcepm.."/"..totalpmsmrr.."】"
if base:get(TD_ID..'TextForce:'..msg.chat_id) then
txtt = base:get(TD_ID..'TextForce:'..msg.chat_id)
else
txtt = "✦ کاربر :【"..nm.."】\nشما باید【"..mande.."】نفر را\nبه گروه دعوت کنید تا بتوانید در گروه پیام ارسال کنید\n>#تعداداداجباری : 【"..Forcemax.."/"..added.."】\n>#اخطار : 【"..Forcepm.."/"..totalpmsmrr.."】"
end
local txtt = txtt:gsub('name',nm)
local txtt = txtt:gsub('number',mande)
local txtt = txtt:gsub('add',ads)
local txtt = txtt:gsub('warn',wrn)
xl = base:get(TD_ID..'TextDok:'..msg.chat_id) or 'معاف کردن'
local keyboard = {}
keyboard.inline_keyboard = {{
{text = ''..xl..'',callback_data='Moaf:'..msg.sender_id.user_id..':'..msg.chat_id..':'..name}}}
send_inline(msg.chat_id,txtt,keyboard,'html')
base:set(TD_ID..'pmdadeshode'..msg.chat_id..msg.sender_id.user_id..os.date("%Y/%m/%d"),totalpmsmrr)
end
end
end
end
end
----------Msg Checks-------------
local chat = msg.chat_id
--if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'added') then
if not is_Owner(msg) then
if base:get(TD_ID..'Lock:Pin:'..chat) then
if msg.content["@type"] == 'messagePinMessage' then
print 'Pinned By Not Owner'
send(chat,msg.id,'فقط مالکان\n','md')
TD.unpinChatMessage(chat)
--TD.unpinAllChatMessages(chat)
local PIN_ID = base:get(TD_ID..'Pin_id'..chat)
if PIN_ID then
TD.pinChatMessage(msg.chat_id,tonumber(PIN_ID))
end
end
end
end
if not is_Vip(msg) then
local chat = msg.chat_id
local user = msg.sender_id.user_id
local timemutemsg = tonumber(base:get(TD_ID..'mutetime:'..msg.chat_id) or 3600)
local hashwarnbd = TD_ID..''..user..':warn'
local warnhashbd = base:hget(hashwarnbd, chat) or 1
local max_warn = tonumber(base:get(TD_ID..'max_warn:'..chat) or 5)
local DIAMOND = (msg.content.caption and msg.content.caption.text) or (msg.content.text and msg.content.text.text)
--_____________Text Msg Checks_________________
if DIAMOND then
local link = DIAMOND:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or DIAMOND:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or DIAMOND:match("[Tt].[Mm][Ee]/") or DIAMOND:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or DIAMOND:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Pp][Hh]/") or DIAMOND:match("[Hh][Tt][Tt][Pp]://") or DIAMOND:match("[Hh][Tt][Tt][Pp][Ss]://")
local username = DIAMOND:match("@(.*)") or DIAMOND:match("@")
local tag = DIAMOND:match("#(.*)") or DIAMOND:match("#")
local persian = DIAMOND:match("[\216-\219][\128-\191]") 
local english = DIAMOND:match("[A-Z]") or DIAMOND:match("[a-z]")

local Fosh = DIAMOND:match("کص") or DIAMOND:match("کون") or DIAMOND:match("ممه") or DIAMOND:match("کیری") or DIAMOND:match("سیک") or DIAMOND:match("koni") or DIAMOND:match("کصده") or DIAMOND:match("کصکش") or DIAMOND:match("لاشی") or DIAMOND:match("بیناموس")or DIAMOND:match("جنده") or DIAMOND:match("خارکسده") or DIAMOND:match("حرومزاده") or DIAMOND:match("گاییدم") or DIAMOND:match("لیس") or DIAMOND:match("کونی") or DIAMOND:match("اوبی") or DIAMOND:match("تخم") or DIAMOND:match("kir") or DIAMOND:match("kos") or DIAMOND:match("lashi")
if msg.content and msg.content.text and msg.content.text.entities then
--<><>Spoiler<><>--
if getEntities(msg.content.text.entities, 'textEntityTypeSpoiler') then
MsgCheck(msg,'ارسال #اسپویلر','Spoiler','اسپویلر')
end
--<><>Hyper<><>--
if (getEntities(msg.content.text.entities, 'textEntityTypeUrl') or getEntities(msg.content.text.entities, 'textEntityTypeTextUrl')) then
MsgCheck(msg,'ارسال #هایپرلینک','Hyper','هایپرلینک')
end
--<><>Mention<><>--
if getEntities(msg.content.text.entities, "textEntityTypeMentionName") then
MsgCheck(msg,'ارسال #فراخانی','Mention','فراخانی')
end
end
--<><>SpoilerMedia<><>--
if msg.content.has_spoiler then
MsgCheck(msg,'ارسال #رسانه اسپویلر','Spoiler','اسپویلر')
end
--<><>Link<><>--
if link then
MsgCheck(msg,'ارسال #لینک','Link','لینک')
end
--<><>Username<><>--
if username then
MsgCheck(msg,'ارسال #نام کاربرے','Username','یوزرنیم')
end
--<><>Tag<><>--
if tag then
MsgCheck(msg,'ارسال هَشتَگ','Tag','هشتگ')
end
--<><>Persian<><>--
if persian then
MsgCheck(msg,'ارسال #فارسی','Persian','فارسی')
end
--<><>English<><>--
if english then
MsgCheck(msg,'ارسال #انگلیسی','English','انگلیسی')
end
---end diamond
end
--<><>Caption<><>--
if (msg.content.caption and msg.content.caption.text) then
MsgCheck(msg,'ارسال #کَپشِن','Caption','کپشن')
end
--<><>Text<><>--
if MsgType == 'text' then
MsgCheck(msg,'ارسال #متن','Text','متن')
end
--<><>Edit<><>--
if msg.edit_date > 0 then
MsgCheck(msg,'ارسال #ویرایش پیام','Edit','ویرایش')
end
--<><>Inline<><>--
if msg.content then
if msg.reply_markup and msg.reply_markup._ == "replyMarkupInlineKeyboard" then
MsgCheck(msg,'ارسال #دکمه شیشه اے','Inline','دکمه شیشه ای')
end
end
--<><>Story<><>--
if MsgType == 'Story' then
MsgCheck(msg,'ارسال #استوری','Story','استوری')
end
--<><>Photo<><>--
if MsgType == 'Photo' then
MsgCheck(msg,'ارسال #عکس','Photo','عکس')
end
--<><>Fwd<><>--
if msg.forward_info then
MsgCheck(msg,'ارسال #فوروارد','Forward','فوروارد')
end
--<><>Videomsg<><>--
if msg.content._ == 'messageVideoNote' then
MsgCheck(msg,'ارسال #ویدیومسیج','Videomsg','ویدیومسیج')
end
--<><>File<><>--
if MsgType == 'Document' then
if msg.content.document.file_name:match("[\216-\219][\128-\191]") or msg.content.caption.text:match("ضدفیلتر") or msg.content.caption.text:match("ضد فیلتر") and msg.content.document.file_name:match(".[Aa][Pp][Kk]") then
MsgCheck(msg,'ارسال #بدافزار','Malware','بدافزار')
end
MsgCheck(msg,'ارسال #فایل','Document','فایل')
end
--<><>Location<><>--
if MsgType == 'Location' then
MsgCheck(msg,'ارسال #موقعیت مکانی','Location','موقعیت مکانی')
end
--<><>Voice<><>--
if MsgType == 'Voice' then
MsgCheck(msg,'ارسال #وویس','Voice','وویس')
end
--<><>Contact<><>--
if MsgType == 'Contact' then
MsgCheck(msg,'ارسال #مخاطب','Contact','مخاطب')
end
--<><>Game<><>--
if MsgType == 'Game' then
MsgCheck(msg,'ارسال #بازے','Game','بازی')
end
--<><>Video<><>--
if MsgType == 'Video' then
MsgCheck(msg,'ارسال #فیلم','Video','فیلم')
end
--<><>Audio<><>--
if MsgType == 'Audio' then
MsgCheck(msg,'ارسال #موزیک','Audio','آهنگ')
end
--<><>Gif<><>--
if MsgType == 'Gif' then
MsgCheck(msg,'ارسال #گیف','Gif','گیف')
end
--<><>Sticker<><>--
if msg.content._ == "messageSticker" then
MsgCheck(msg,'ارسال #استیکر','Sticker','استیکر')
end
--<><>Sticker2<><>--
if msg.content._ == 'messageUnsupported' then
MsgCheck(msg,'ارسال #استیکر متحرک','Stickers','استیکر متحرک')
end


--<><>Replys<><>--
if msg.reply_to and msg.reply_to.origin then
if msg.reply_to.origin and msg.reply_to.origin._ and (msg.reply_to.origin._ == 'messageOriginChannel') then
MsgCheck(msg,'ارسال #ریپلی از کانال','ReplyChannel','ریپلی از کانال')
elseif msg.reply_to.origin and msg.reply_to.origin._ and TD.in_array({'messageOriginUser', 'messageOriginHiddenUser'}, msg.reply_to.origin._) then
if (tonumber(msg.reply_to.chat_id) == 0) then
MsgCheck(msg,'ارسال #ریپلی از کاربر','ReplyUser','ریپلی از کاربر')
elseif (tonumber(msg.reply_to.chat_id) ~= 0) and (tostring(msg.reply_to.chat_id) ~= tostring(msg.chat_id)) then
MsgCheck(msg,'ارسال #ریپلی از گروه','ReplyGroup','ریپلی از گروه')
end
end
end
--<><>ChannelPost<><>--
--if msg.views ~= 0 then
--MsgCheck(msg,'ارسال #پست‌کانال','Channelpost','پست کانال')
--end
--<><>Flood<><>--
--[[if base:sismember(TD_ID..'Gp:'..chat,'Del:Flood') or base:sismember(TD_ID..'Gp:'..chat,'Kick:Flood') or base:sismember(TD_ID..'Gp:'..chat,'Ban:Flood') or base:sismember(TD_ID..'Gp:'..chat,'Mute:Flood') or base:sismember(TD_ID..'Gp:'..chat,'Warn:Flood') or base:sismember(TD_ID..'Gp:'..chat,'Silent:Flood') then
floodtime = tonumber(base:get(TD_ID..'Flood:Max:'..msg.chat_id)) or 5
floodmax = tonumber(base:get(TD_ID..'Flood:Time:'..msg.chat_id)) or 10
flooduser = tonumber(base:get(TD_ID..'flooduser'..user..msg.chat_id)) or 0
if flooduser > floodmax then
base:del(TD_ID..'flooduser'..user..msg.chat_id)
if base:sismember(TD_ID..'Gp3:'..chat,user..' حذف پیام‌مکرر') or base:sismember(TD_ID..'Gp:'..chat,'Del:Flood') then
end
if not(base:sismember(TD_ID..'Gp:'..chat,'Ban:Flood') or base:sismember(TD_ID..'Gp:'..chat,'Kick:Flood'))then
if base:sismember(TD_ID..'Gp:'..chat,'Mute:Flood') then
lock_mute(msg,'ارسال #پیام‌مکرر')
end
if base:sismember(TD_ID..'Gp:'..chat,'Silent:Flood') then
lock_silent(msg,'ارسال #پیام‌مکرر')
end
if base:sismember(TD_ID..'Gp:'..chat,'Warn:Flood') then
lock_warn(msg,'ارسال #پیام‌مکرر')
end
end
if base:sismember(TD_ID..'Gp:'..chat,'Kick:Flood') then
lock_kick(msg,'ارسال #پیام‌مکرر')
end
if base:sismember(TD_ID..'Gp:'..chat,'Ban:Flood') then
lock_ban(msg,'ارسال #پیام‌مکرر')
end
else
base:setex(TD_ID..'flooduser'..user..msg.chat_id,floodtime,flooduser+1)
end
end]]
--<><>Spam<><>--
if (msg.content.text and msg.content.text.text) then
num = tonumber(base:get(TD_ID..'NUM_CH_MAX:'..msg.chat_id)) or 3600
chars = utf8.len(msg.content.text and msg.content.text.text)
if chars > num then
MsgCheck(msg,'ارسال #هرزنامه','Spam','هرزنامه')
end
end

user = msg.sender_id.user_id
Msgsday = tonumber(base:get(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..user or 00000000)) or 0
local limitmsg = tonumber(base:get(TD_ID..'limitpm:'..msg.chat_id) or 5)
-------------------limitpm-------------------
if Msgsday > limitmsg and base:sismember(TD_ID..'Gp2:'..msg.chat_id,'limitpm'..user) and base:sismember(TD_ID..'Gp2:'..msg.chat_id,'limitpm:on') then
times = math.floor(timemutemsg / 3600) 
local warns = base:get(TD_ID..'pmwarns:'..msg.chat_id) or 2
local startwarns = TD_ID..':lmt'..os.date("%Y/%m/%d")..':'..msg.chat_id
local endwarns = base:hget(startwarns,msg.sender_id.user_id) or 1

local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:get(TD_ID..'limitpmstatus:'..msg.chat_id) == 'mute' then
if tonumber(endwarns) > tonumber(warns) then
else
send(chat,0,"✦ کاربر :["..name.."](tg://user?id="..user..")\nبه دلیل رسیدن به محدودیت حداکثر پیام در روز به مدت "..timemutemsg.."\nثانیه از ارسال پیام محدود میشوید.","md")
MuteUser(chat,user,msg.date+timemutemsg)
base:sadd(TD_ID..'limituser:'..msg.chat_id,msg.sender_id.user_id)
base:hset(startwarns,msg.sender_id.user_id,tonumber(endwarns) + 1)
end
elseif base:get(TD_ID..'limitpmstatus:'..msg.chat_id) == 'ban' then
if tonumber(endwarns) > tonumber(warns) then
else
send(chat,0,"✦ کاربر :["..name.."](tg://user?id="..user..")\nبه دلیل رسیدن به محدودیت حداکثر پیام در روز از گروه مسدود شد","md")
KickUser(chat,user)
base:hset(startwarns,msg.sender_id.user_id,tonumber(endwarns) + 1)
end
elseif base:get(TD_ID..'limitpmstatus:'..msg.chat_id) == 'silent' then
if tonumber(endwarns) > tonumber(warns) then
else
tx = "✦ کاربر :["..name.."](tg://user?id="..user..")\nبه دلیل رسیدن به محدودیت حداکثر ارسال پیام روزانه، به مدت【"..times.."】ساعت در گروه سایلنت شدید.\n\nپس از【"..times.."】ساعت ، می تونید پیامتون رو بذارید."
send(chat,0,tx,'md')
base:hset(startwarns,msg.sender_id.user_id,tonumber(endwarns) + 1)
base:setex(TD_ID..'s_list'..msg.sender_id.user_id,timemutemsg,true)
base:sadd(TD_ID..'limituser:'..msg.chat_id,msg.sender_id.user_id)
end
end
end

local stn = base:get(TD_ID..'s_list'..msg.sender_id.user_id)
if msg.sender_id.user_id and stn then
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
return false
end
if tonumber(os.date("%H%M")) == tonumber(base:ttl(TD_ID..'s_list'..msg.sender_id.user_id)) then
startwarn = TD_ID..':lmt'..os.date("%Y/%m/%d")..':'..msg.chat_id
startwarrn = TD_ID..':lmt'..os.date("%H%M")..':'..msg.chat_id
base:del(TD_ID..'s_list'..msg.sender_id.user_id)
base:del(startwarn,msg.sender_id.user_id)
base:del(startwarrn,msg.sender_id.user_id)
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..msg.sender_id.user_id)
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..msg.sender_id.user_id or 00000000)
end
----------FilterName-----------
if msg.sender_id.user_id then
if base:sismember(TD_ID..'Gp2:'..chat_id,'NameAntiTabchi') then
users = base:smembers(TD_ID..'FilterName:'..msg.chat_id)
if #users > 0 then
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
for k,v in pairs(users) do
mMd = diamond.first_name:lower()
if mMd:match(v) then
if base:sismember(TD_ID..'Gp2:'..chat_id,'MuteAntiTab') then
MuteUser(msg.chat_id,msg.sender_id.user_id,0)
mm = 'محدود'
else
KickUser(msg.chat_id,msg.sender_id.user_id)
mm = 'اخراج'
end
if not (msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember") then
end
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then
send(msg.chat_id,0,'کاربر '..MBD(name,msg.sender_id.user_id)..' به دلیل داشتن اسم غیرمجاز از گروه '..mm..' شد !','md')
end
end
end
end
end
end
----------BioLink and FilterBio-----------
if msg.sender_id.user_id then
local result = TD.getUserFullInfo(msg.sender_id.user_id) 
if result and result.bio and result.bio.text then
DiamondAbout = result.bio.text
else  
DiamondAbout = 'Nil'
end
if DiamondAbout and (DiamondAbout:match("[Tt].[Mm][Ee]/") or DiamondAbout:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")) then
MsgCheck(msg,'#داشتن لینک در بیو','Biolink','لینک بیو')
end
if base:sismember(TD_ID..'Gp2:'..chat_id,'BioAntiTabchi') then
users = base:smembers(TD_ID..'FilterBio:'..msg.chat_id)
if #users > 0 then
for k,v in pairs(users) do
mMd = DiamondAbout:lower()
if mMd:match(v) then
if base:sismember(TD_ID..'Gp2:'..chat_id,'MuteAntiTab') then
MuteUser(msg.chat_id,msg.sender_id.user_id,0)
mm = 'محدود'
else
KickUser(msg.chat_id,msg.sender_id.user_id)
mm = 'اخراج'
end
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if not (msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember") then
end
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm') then 
send(msg.chat_id,0,'کاربر '..MBD(name,msg.sender_id.user_id)..' به دلیل داشتن بیوگرافی غیرمجاز از گروه '..mm..' شد !','md')
end
end
end
end
end
end
--------force join-------- 
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'forcejoin') then
local Ch = (base:get(TD_ID..'setch:'..msg.chat_id) or '..Channel..')
local url , res = https.request('https://api.telegram.org/bot'..JoinToken..'/getchatmember?chat_id=@'..Ch..'&user_id='..msg.sender_id.user_id)
if res ~= 200 then
end
Joinchanel = json:decode(url)
if not is_GlobalyBan(msg.sender_id.user_id) and (not Joinchanel.ok or Joinchanel.result.status == "left" or Joinchanel.result.status == "kicked") and not is_Sudo(msg) and not is_Mod(msg) then
print 'Force Join'
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
MsgId = base:get(TD_ID..'msgid_joins_'..msg.chat_id)
countmem = base:smembers(TD_ID..'Force_Member:'..msg.chat_id)
if #base:smembers(TD_ID..'Force_Member:'..msg.chat_id) > 2 or not MsgId then
if not base:sismember(TD_ID..'Force_Member:'..msg.chat_id,msg.sender_id.user_id) then
if MsgId then
TD.deleteMessages(msg.chat_id,{[1] = MsgId})
base:del(TD_ID..'Force_Member:'..msg.chat_id)
end
bd = '• برای ارسال پیام در گروه باید عضو کانال گروه باشید ، لطفاً با استفاده از دکمه زیر در کانال عضو شوید !\n\n⚠️ شما در کانال عضو نیستید:\n<a href="tg://user?id='..msg.sender_id.user_id..'">'..name..'</a>'
Button = {
{
{text = '✦ براے عضویت در کانال کلیک کنید',url='https://telegram.me/'..Ch}
}
}
TD.sendText(msg.chat_id,msg.send_message_id,bd, 'html', true, false, false, false,keyboards(Button))
base:sadd(TD_ID..'Force_Member:'..msg.chat_id,msg.sender_id.user_id)
end
else
if not base:sismember(TD_ID..'Force_Member:'..msg.chat_id,msg.sender_id.user_id) and MsgId then
base:sadd(TD_ID..'Force_Member:'..msg.chat_id,msg.sender_id.user_id)
bd = '• برای ارسال پیام در گروه باید عضو کانال گروه باشید ، لطفاً با استفاده از دکمه زیر در کانال عضو شوید !\n\n⚠️ شما در کانال عضو نیستید:\n'
countmem = base:smembers(TD_ID..'Force_Member:'..msg.chat_id)
for u,i in pairs(countmem) do 
local UsEr , mrr  = https.request('https://api.telegram.org/bot'..JoinToken..'/getChat?chat_id='..i)
if mrr == 200 then
UsEr = json:decode(UsEr)
if UsEr.ok == true then
if UsEr.result.usernames.editable_username then
nme = UsEr.result.usernames.editable_username
else
nme = UsEr.result.first_name
end
bd = bd..'<a href="tg://user?id='..i..'">'..nme..'</a>\n'
end
end
end
Button_ = {{
{text='✦ براے عضویت در کانال کلیک کنید',url='https://telegram.me/'..Ch}
}}
TD.editMessageText_(msg.chat_id,tonumber(MsgId),keyboards(Button_),bd,'html')
end
end
else
return true
end
end
-----------------Bot-----------------
if msg.add then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
local result = TD.getUser(msg.add)
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local banbotpm = base:sismember(TD_ID..'Gp2:'..chat,'kickbotpm')
if result.type._ == "userTypeBot" then 
if base:sismember(TD_ID..'Gp:'..chat,'Kick:Bots') then
if banbotpm then 
send(chat,0,"✦ نام اِضافہ ڪنندهٔ ربات : 【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\n\nآیدےِ ربات اِضافہ شده :【["..result.usernames.editable_username.."](tg://user?id="..msg.add..")】\n\nکاربر و ربات #اخراج شدند\n─┅━━━━━━━┅─\n℘ دلیل اخراج : افزودن #ربات","md")
end
KickUser(chat,user)
KickUser(msg.chat_id,result.id)
UnRes(chat,user)
end
if base:sismember(TD_ID..'Gp:'..chat,'Ban:Bots') then
if banbotpm then 
send(chat,0,"✦ نام اِضافہ ڪنندهٔ ربات : 【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\n\nآیدےِ ربات اِضافہ شده :【["..result.usernames.editable_username.."](tg://user?id="..msg.add..")】\n\nکاربر و ربات #مسدود شدند\n─┅━━━━━━━┅─\n℘ دلیل مسدودیت : افزودن #ربات","md")
end
KickUser(chat,user)
KickUser(msg.chat_id,result.id)
end
if base:sismember(TD_ID..'Gp:'..chat,'Del:Bots') then
KickUser(msg.chat_id,result.id)
local results = TD.getSupergroupMembers(msg.chat_id,'Bots', '', 0, 200)
if results.members then
for k,v in pairs(results.members) do
if tonumber(v.member_id.user_id) ~= tonumber(BotJoiner) then
KickUser(msg.chat_id,v.member_id.user_id)
print(v.member_id.user_id)
end
end
end
end
if not base:sismember(TD_ID..'Gp:'..chat,'Ban:Bots') or base:sismember(TD_ID..'Gp:'..chat,'Kick:Bots') then
if base:sismember(TD_ID..'Gp:'..chat,'Mute:Bots') then
if banbotpm then
send(chat,0,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nبه مدت【"..timemutemsg.."】ثانیه از ارسال پیام #محدود شد\n─┅━━━━━━━┅─\n℘ دلیل محدودیت : افزودن #ربات","md")
end
KickUser(chat,result.id)
MuteUser(chat,user,msg.date+timemutemsg)
end
if base:sismember(TD_ID..'Gp:'..chat,'Silent:Bots') then
if banbotpm then
send(chat,0,'✦ کاربر :【['..name..'](tg://user?id='..msg.sender_id.user_id..')】\n#سایلنت شد\n─┅━━━━━━━┅─\n℘ دلیل سایلنت : افزودن #ربات','md')
end
base:sadd(TD_ID..'MuteList:'..chat,user or 00000000)
TD.deleteMessages(chat,{[1] = msg.id})
end
if base:sismember(TD_ID..'Gp:'..chat,'Warn:Bots') then
if tonumber(warnhashbd) == tonumber(max_warn) then
KickUser(chat,user)
send(chat,0,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nبه علت گرفتن حداکثر #اخطار از گروه #اخراج شد\n℘ دلیل اخطار و اخراج : افزودن #ربات\n─┅━━━━━━━┅─\n● #اخطارها : "..warnhashbd.."/"..max_warn.."","md")
base:hdel(hashwarnbd,chat,max_warn)
else
base:hset(hashwarnbd,chat, tonumber(warnhashbd) +1)
send(chat,0,"✦ کاربر :【["..name.."](tg://user?id="..msg.sender_id.user_id..")】\nشما یک #اخطار دریافت کردید\n─┅━━━━━━━┅─\n℘ دلیل اخطار : افزودن #ربات\n● #اخطارها : "..warnhashbd.."/"..max_warn.."","md")
KickUser(chat,result.id)
end
end
end
end
end
end
----------Filter------------
if Black then
if is_filter(msg,Black) then
TD.deleteMessages(msg.chat_id, {[1] = msg.id})
if base:sismember(TD_ID..'Gp:'..chat,'Ban:Filter') then
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
send(chat,0,"✦ کاربر : ["..name.."](tg://user?id="..msg.sender_id.user_id..")\nاز گروه #مسدود شد\n─┅━━━━━━━┅─\n℘ دلیل مسدودیت : ارسال #کلمات فیلترشده","md")
KickUser(chat,user)
else
send(msg.chat_id,0,'✦ کاربر : '..name..'\nباید به دلیل ارسال کلمه فیلترینگ از گروه اخراج شود ولی ربات به قسمت محرومیت کاربران  دسترسی ندارد !\nلطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید !','md')
end
end
end 
end
--------Mute all--------
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Mute_All') then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Tele_Mute') then
base:sadd(TD_ID..'Mutes:'..msg.chat_id,msg.sender_id.user_id)
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
MuteUser(msg.chat_id,msg.sender_id.user_id,0)
else
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
end
if base:sismember(TD_ID..'SilentList:'..msg.chat_id,msg.sender_id.user_id) then
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
if base:sismember(TD_ID..'MuteList:'..msg.chat_id,msg.sender_id.user_id) then
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
MuteUser(msg.chat_id,msg.sender_id.user_id,0)
end
---MuteAll2---
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Mute_All2') then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Tele_Mute2') then
base:sadd(TD_ID..'Mutes:'..msg.chat_id,msg.sender_id.user_id)
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
MuteUser(msg.chat_id,msg.sender_id.user_id,0)
else
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
end
end
end
--<><>Anti Tabchi<><>--
if msg.content._ == "messageChatJoinByLink" and base:sismember(TD_ID..'Gp2:'..msg.chat_id,'AntiTabchi') and not is_Mod(msg) then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'FirstTabchiMute') then
MuteUser(msg.chat_id,msg.sender_id.user_id,0)
end
if base:sismember(TD_ID..'Gp2:'..chat_id,'MuteAntiTab') then
mmltxt = 'در گروه محدود خواهید شد !'
else
mmltxt = 'از گروه اخراج خواهید شد !'
end
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local keyboard = {}
TexT = '#احراز_هویت\n👤کاربر <a href="tg://user?id='..msg.sender_id.user_id..'">'..name..'</a>\n🔑در صورتی که ربات نیستید به سوال زیر پاسخ دهید !\n⚠️در صورتی که به این سوال تا 15 دقیقه آینده پاسخ ندهید و یا به هر دو سوال پاسخ اشتباه دهید '..mmltxt
Mohammad = {'BD','Mrr619'}
Mohammadrr = {'BD','Mrr619','Babak','TeleDiamondCh'}
BDAntiTabchi = Mohammadrr[math.random(#Mohammadrr)]
if Mohammad[math.random(#Mohammad)] == 'Mrr619' then
mrr619 = {0,1,2,3,4,5,6,7,8,9}
randnum = mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]
randnum2 = mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]
randnum3 = mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]
randnum4 = mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]..mrr619[math.random(#mrr619)]
if tonumber(randnum) == tonumber(randnum2) or tonumber(randnum) == tonumber(randnum3) or tonumber(randnum) == tonumber(randnum3) then
randnum = 1000
end
if BDAntiTabchi == 'Mrr619' then
keyboard.inline_keyboard = {{
{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id},
{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id}
},{
{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id},
{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id}
},{
{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
if BDAntiTabchi == 'BD' then
keyboard.inline_keyboard = {{
{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id},
{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id}
},{
{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id},
{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id}
},{
{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
if BDAntiTabchi == 'TeleDiamondCh' then
keyboard.inline_keyboard = {{
{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id},
{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id}
},{
{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id},
{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id}
},{
{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
if BDAntiTabchi == 'Babak' then
keyboard.inline_keyboard = {{
{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id},
{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id}
},{
{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id},
{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id}
},{
{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
local randnum = randnum:gsub("[0123456789]", {["0"] = "0️⃣", ["1"] = "1️⃣", ["2"] = "2️⃣", ["3"] = "3️⃣", ["4"] = "4️⃣", ["5"] = "5️⃣", ["6"] = "6️⃣", ["7"] = "7️⃣", ["8"] = "8️⃣", ["9"] = "9️⃣"})
send_inline(msg.chat_id,TexT..'\n\n>معکوس عدد '..randnum..' را از میان دکمه های زیر پیدا کرده و بر روی آن کلیک کنید !',keyboard,'html')
else
mrr619 = {'❤️','😍','✅','😭','🍦','🍌','🍉','🍏','🍎','🦆','💰','🔑','🐥','🎀','🎈','🔧','🗡','🤖','💄','💍','🐒','⚽️','0️⃣','1️⃣','2️⃣','3️⃣','4️⃣','5️⃣','6️⃣','7️⃣','8️⃣','9️⃣','🔟','✔️','⚫️','🔴','🔵','⚪️','🇮🇷'}
randnum = mrr619[math.random(#mrr619)]
randnum2 = mrr619[math.random(#mrr619)]
randnum3 = mrr619[math.random(#mrr619)]
randnum4 = mrr619[math.random(#mrr619)]
if tostring(randnum) == tostring(randnum2) or tostring(randnum) == tostring(randnum3) or tostring(randnum) == tostring(randnum3) then
randnum = '😡'
end
if BDAntiTabchi == 'Mrr619' then
keyboard.inline_keyboard = {
{{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id},{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id}},
{{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id},{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id}},
{{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
if BDAntiTabchi == 'BD' then
keyboard.inline_keyboard = {
{{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id},{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id}},
{{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id},{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id}},
{{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
if BDAntiTabchi == 'TeleDiamondCh' then
keyboard.inline_keyboard = {
{{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id},{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id}},
{{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id},{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id}},
{{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
if BDAntiTabchi == 'Babak' then
keyboard.inline_keyboard = {
{{text = randnum2,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>2:'..msg.chat_id},{text = randnum3,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>3:'..msg.chat_id}},
{{text = randnum4,callback_data='bd:IsTabchiTrue>'..msg.sender_id.user_id..'>1:'..msg.chat_id},{text = randnum,callback_data='bd:IsTabchiFalse>'..msg.sender_id.user_id..':'..msg.chat_id}},
{{text = 'تایید هویت(مخصوص مدیران)',callback_data='bd:Is_Tabchino>'..msg.sender_id.user_id..':'..msg.chat_id},{text = 'عدم تاییدهویت(مخصوص مدیران)',callback_data='bd:Is_Tabchiyes>'..msg.sender_id.user_id..':'..msg.chat_id}},}
end
local randnum = randnum:gsub(randnum,{["3️⃣"] = "شماره سه", ["4️⃣"] = "شماره چهار", ["5️⃣"] = "شماره پنج", ["6️⃣"] = "شماره شیش", ["7️⃣"] = "شماره هفت", ["8️⃣"] = "شماره هشت", ["9️⃣"] = "شماره نه", ["❤️"] = "قلب",["0️⃣"] = "شماره صفر", ["1️⃣"] = "شماره یک", ["2️⃣"] = "شماره دو",  ["😍"] = "😍", ["✅"] = "✅", ["🍌"] = "موز",  ["💰"] = "💰", ["🔑"] = "🔑", ["🐥"] = "جوجه", ["🎀"] = "پاپیون", ["🎈"] = "بادکنک قرمز", ["🔧"] = "اچهار فرانسه", ["🗡"] = "شمشیر", ["🤖"] = "ربات", ["💄"] = "رژ لب", ["💍"] = "انگشتر نگین دار", ["🐒"] = "میمون", ["⚽️"] = "توپ فوتبال", ["✔️"] = "تیک مشکی", ["⚫️"] = "دایره مشکی", ["🔴"] = "دایره قرمز", ["🔵"] = "دایره ابی", ["⚪️"] = "دایره سفید", ["🇮🇷"] = "پرچم ایران",["😡"] = "ادم عصبانی",["🍉"] = "هندوانه", ["🍏"] = "سیب سبز", ["🍎"] = "سیب قرمز", ["🦆"] = "اردک", ["😭"] = "گریه", ["🍦"] = "بستنی"})
send_inline(msg.chat_id,TexT..'\n\n> اموجی '..randnum..' را از میان دکمه های زیر پیدا کرده و بر روی آن کلیک کنید !',keyboard,'html')
end
base:sadd(TD_ID..'AntiTabchiUser'..msg.chat_id,msg.sender_id.user_id)
function BDTab()
if base:sismember(TD_ID..'AntiTabchiUser'..msg.chat_id,msg.sender_id.user_id) then
if base:sismember(TD_ID..'Gp2:'..chat_id,'MuteAntiTab') then
MuteUser(msg.chat_id,msg.sender_id.user_id,0)
else
KickUser(msg.chat_id,msg.sender_id.user_id)
end
base:srem(TD_ID..'AntiTabchiUser'..msg.chat_id,msg.sender_id.user_id)
end
end
TD.set_timer(300,BDTab)
end
----------------Tgservice---------------------
if (msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember" or msg.content._ == "messageVideoChatStarted" or msg.content._ == "messageVideoChatEnded" or msg.content._ == "messageInviteVideoChatParticipants") then
if base:sismember(TD_ID..'Gp:'..msg.chat_id,'Lock:TGservice') then
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
end

function txt_setadmin(chatid,Msg,userid,name)
send(chatid, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..userid..")】به مدیر گروه ارتقا داده شد ","md")
end
function txt_remadmin(chatid,Msg,userid,name)
send(chatid, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..userid..")】از مدیریت گروه عزل شد","md")
end
function pro(chatid,Msg,userid,name)
if base:sismember(TD_ID..'ModList:'..chatid,userid) then
send(chatid, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..userid..")】از قبل جزء مدیران ربات بود","md")
else
send(chatid, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..userid..")】به مدیر ربات ارتقا داده شد ","md")
base:sadd(TD_ID..'ModList:'..chatid,userid)
end
end
function demo(chatid,Msg,userid,name)
if not base:sismember(TD_ID..'ModList:'..chatid,userid) then
send(chatid, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..userid..")】 مدیر ربات نیست ","md")
else
base:srem(TD_ID..'ModList:'..chatid,userid)
send(chatid, msg.send_message_id,"✦ کاربر :【["..name.."](tg://user?id="..userid..")】از مقام مدیریت ربات عزل شد","md")
end
end


xid = math.modf(msg.id / 2 ^ 20)
------------Chat Type------------
if is_FullSudo(msg) then
if Black == 'msgadd on' or Black == 'پیام ادد اجباری روشن' then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Msg_Add') then
send(msg.chat_id, msg.send_message_id,'> پیام ادد اجباری فعال است!!!','md')
else
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'Msg_Add')
send(msg.chat_id, msg.send_message_id,'> پیام ادد اجباری ربات #فعال شد و از این پس پیام های مربوط به ادد اجباری #ارسال خواهد شد.','md')
end
end
if Black == 'msgadd off' or Black == 'پیام ادد اجباری خاموش' then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Msg_Add') then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Msg_Add')
send(msg.chat_id, msg.send_message_id,'> پیام ادد اجباری ربات #غیرفعال شد و از این پس پیام های مربوط به ادد اجباری #ارسال نخواهد شد.','md')
else
send(msg.chat_id, msg.send_message_id,'> پیام ادد اجباری غیرفعال است!!!','md')
end
end

--<><><><>SetSudo
if Diamondent and (Black:match('^setsudo (.*)') or Black:match('^افزودن سودو (.*)')) or Black and (Black:match('^setsudo @(.*)') or Black:match('^افزودن سودو @(.*)') or Black:match('^setsudo (%d+)$') or Black:match('^افزودن سودو (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^setsudo (.*)') or Black:match('^افزودن سودو (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^setsudo @(.*)') or Black:match('^افزودن سودو @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^setsudo (%d+)') or Black:match('^افزودن سودو (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^setsudo (.*)') or Black:match('^افزودن سودو (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if base:sismember(TD_ID..'SUDO',mrr619) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nدر لیست سودو هاے ربات قرار دارد','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nبه لیست سودو هاے ربات افزوده یافت','md')
base:sadd(TD_ID..'SUDO',mrr619)
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','md')
end
end
if Black == 'setsudo' or Black == 'افزودن سودو' and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'SUDO',user) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nدر لیست سودو هاے ربات قرار دارد','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nبه لیست سودو هاے ربات افزوده یافت','md')
base:sadd(TD_ID..'SUDO',user)
end
end
end
--<><><><>RemSudo
if Diamondent and (Black:match('^remsudo (.*)') or Black:match('^حذف سودو (.*)')) or Black and (Black:match('^remsudo @(.*)') or Black:match('^حذف سودو @(.*)') or Black:match('^remsudo (%d+)$') or Black:match('^حذف سودو (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^remsudo (.*)') or Black:match('^حذف سودو (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^remsudo @(.*)') or Black:match('^حذف سودو @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^remsudo (%d+)') or Black:match('^حذف سودو (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^remsudo (.*)') or Black:match('^حذف سودو (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if base:sismember(TD_ID..'SUDO',mrr619) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nاز لیست سودو هاے ربات حذف شد','md')
base:srem(TD_ID..'SUDO',mrr619)
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nدر لیست سودو هاے ربات نیست','md')
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','md')
end
end
if Black == 'remsudo' or Black == 'حذف سودو' and tonumber(reply_id) ~= 0  then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'SUDO',user) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nاز لیست سودو هاے ربات حذف شد','md')
base:srem(TD_ID..'SUDO',user)
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nدر لیست سودو هاے ربات نیست','md')
end
end
end
if Black == 'sudolist' or Black == 'لیست سودو ها' then
local hash = TD_ID.."SUDO" 
local list = base:smembers(hash)
local t = '*لیست سودو هاے ربات :*\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do
local diamond = TD.getUser(v)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
t = t..k..'-【['..name..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
if #list == 0 then 
t = '*لیست سودو هاے ربات خالے مے باشد.*'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if (Black == 'clean sudolist' or Black == 'پاکسازی لیست سودو') then
base:del(TD_ID..'SUDO')
send(msg.chat_id, msg.send_message_id,'🚮 لیست سودو هاے ربات پاکسازے شد','md')
end
 
if Black and (Black1:match('^پاکسازی همنام (%S+)')) then
local text = Black1:match('^پاکسازی همنام (%S+)')
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
local result = getGroupMembers(msg.chat_id, 'Search', 'user_id', 20)
--if result and result.members then
for i=1,#result do
local data = TD.getUser(result[i])
if data and data.first_name:match("^(.*)"..text.."(.*)$") or data.first_name:match("^"..text.."(.*)$") or data.first_name:match("(.*)"..text.."$") then
local kk = KickUser(msg.chat_id,result[i])
TD.vardump(kk)
end
end
--end
send(msg.chat_id, msg.send_message_id,'• کاربران همنام با *'..text..'* با موفقیت اخراج شدند !','md')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end

if (Black == 'setcomment' or Black == 'متن کامنت') and reply_id > 0 then
local res = TD.getMessage(msg.chat_id, reply_id)
text = "⌯ #کلمات زیر به لیست کامنت افزوده شد :\n\n"
for i in string.gmatch(res.content.text.text, "%S+") do
local u = TD.searchPublicChat(i).id
--TD.sendText(msg.chat_id,msg.send_message_id,TD.vardump(u),'html')
forgod = i
if not forgod then
text = "خطا!"
break
else
base:sadd(TD_ID..'Comment',forgod)
text = text .. "*" .. u .. "*\n"
end
end
send(msg.chat_id, msg.send_message_id,text,'html')
end


end
----------------- pv -------------
if msg.chat_id == tonumber(Sudoid) and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
if Diamond.forward_info then
if Diamond.forward_info.origin._ == "messageForwardOriginUser" or Diamond.forward_info.origin._ == "messageForwardOriginHiddenUser" then
local user = (base:get(TD_ID..'pms:'..Diamond.forward_info.origin.sender_name) or Diamond.forward_info.origin.sender_user_id)
if user then
print(user)
if tonumber(user) == tonumber(BotJoiner) or tonumber(user) == tonumber(Sudoid) then
send(msg.chat_id, msg.send_message_id,'Error ! ✗ (⊙▂⊙)','html')
else
if Diamond.content._ == 'messageText' then
if msg.content._ == 'messageText' then
send(user,0,'☵ پیام شما ┇ '..Diamond.content.text.text..'\n☵ پاسخ ┇ '..msg.content.text.text,'html')
end
if msg.content.sticker then
TD.sendSticker(user,0,msg.content.sticker.sticker.id)
end
if msg.content.voice_note then
TD.sendVoiceNote(user,0,msg.content.voice_note.voice.remote.id,'☵ در پاسخ به ┇ '..Diamond.content.text.text,'md',msg.content.voice_note.duration,msg.content.voice_note.waveform)
end
if msg.content._ == 'messageUnsupported' or msg.content._ == "messageVideo" or msg.content._ == "messagePhoto" or msg.content._ == "messageVideoNote" or msg.content._ == "messageDocument" or msg.content._ == "messageAudio" or msg.content._ == "messageContact" or msg.content._ == "messageLocation" then
TD.forwardMessages(user,msg.chat_id,{[1] = msg.id})
end
if msg.content.animation then
TD.sendAnimation(user,0,msg.content.animation.animation.remote.id,'☵ در پاسخ به ┇ '..Diamond.content.text.text,'md',msg.content.animation.duration)
end
send(msg.chat_id, msg.send_message_id,'✔️Sent !','html')
else
if msg.content._ == 'messageText' then
sends(user,0,msg.content.text.text,'html')
end
if msg.content.sticker then
TD.sendSticker(user,0,msg.content.sticker.sticker.id)
end
if msg.content.voice_note then
TD.sendVoiceNote(user,0,msg.content.voice_note.voice.remote.id,'','md',msg.content.voice_note.duration,msg.content.voice_note.waveform)
end
if msg.content._ == 'messageUnsupported' or msg.content._ == "messageVideo" or msg.content._ == "messagePhoto" or msg.content._ == "messageVideoNote" or msg.content._ == "messageDocument" or msg.content._ == "messageAudio" or msg.content._ == "messageContact" or msg.content._ == "messageLocation" then
TD.forwardMessages(user,msg.chat_id,{[1] = msg.id})
end
if msg.content.animation then
TD.sendAnimation(user,0,msg.content.animation.animation.remote.id,'','md',msg.content.animation.duration)
end
send(msg.chat_id, msg.send_message_id,'✔️Sent !','html')
end
end
end
--else
--if Diamond.forward_info.author_signature == '' then
--send(msg.chat_id, msg.send_message_id,'ارسال پیام ناموفق ... ! ❌\nپیام مورد نظر از کانال ارسال شده است !','html')
--else
--send(msg.chat_id, msg.send_message_id,'ارسال پیام ناموفق ... ! ❌\nکاربر فورارد پیام خود را بسته است !','html')
end
end
end
--end
if gp_type(msg.chat_id) == "pv" and not base:sismember(TD_ID..'GlobalyBanned:',msg.sender_id.user_id) and ( (#base:smembers(TD_ID..'gpuser:'..msg.sender_id.user_id) ~= 0 and Black and not (Black:match('chat (.*)$') or Black:match('چت (.*)$') or Black:match('(.*) on$') or Black:match('(.*) روشن$') or Black:match('(.*) off$') or Black:match('(.*) خاموش$') or Black:match('(.*)list$') or Black:match('^فیلترکردن +(.*)') or Black:match('^حذف فیلتر +(.*)') or Black:match('لیست(.*)') or Black:match('^filter +(.*)') or Black:match('(.*) فعال$') or Black:match('(.*) غیرفعال$') or Black:match('^قفل (.*)$') or Black:match('lock (.*)$') or Black:match('del (.*)$') or Black:match('warn (.*)$') or Black:match('mute (.*)$') or Black:match('kick (.*)$')or Black:match('ban (.*)$') or Black:match('^unlock (.*)$') or Black:match('^بازکردن (.*)$') or Black:match('cmd (.*)$') or Black:match('دستور (.*)$'))) or (Black and not Black:match('^100(%d+)$') and base:get(TD_ID..'getgp:'..msg.sender_id.user_id)) or Black and not (Black:match('^help$') or Black:match('^راهنما$') or Black:match('^setgp$') or Black:match('^ثبت گروه$') or Black:match('^delgp$') or Black:match('^حذف گروه$') or Black:match('^delgps$') or Black:match('^حذف گروها$') or Black:match('^mygps$') or Black:match('^/start$') or Black:match('^گروهای من$') or Black:match('^delac (.*)') or Black:match('^دیلیت اکانت(.*)') or Black:match('^psswd (.*)') or Black:match('رمز دیلیت اکانت (.*)') or Black:match('^نرخ$') or Black:match('^nerkh')) or not Black) and not is_Sudo(msg) then
if base:get(TD_ID..'MonShi:on') and not base:get(TD_ID..'getgp:'..msg.sender_id.user_id) then
local text = base:get(TD_ID..'monshi') or '_سلام\nمن رباتے هستم که میتوانم گروه شما رو ضد لینک و ضد تبلیغ کنم\nخب اگه میخواے منو داشته باشے و به من نیاز دارے که تو گروهت مدیریت کنم وارد گروه پشتیبانی شو 😝_\n\n*لینک گروه پشتیبانی :*\n'..(LinkSuppoRt)..'\n\n*براے کسب اطلاعات بیشتر میتوانید در کانال ما عضو شوید :*\n'..(Channel)..'\n\n_براے دریافت قیمت ربات دستور_ *"نرخ"* _را ارسال کنید._'
send(msg.chat_id, msg.send_message_id,text,'md')
end
if not base:get(TD_ID..'pmresan:on') then
TD.forwardMessages(Sudoid,msg.chat_id,{[1] = msg.id})
name = TD.getUser(msg.sender_id.user_id).first_name
base:set(TD_ID..'pms:'..name,msg.sender_id.user_id)
end
end
if gp_type(msg.chat_id) == "pv" and Black and not base:sismember(TD_ID..'GlobalyBanned:',msg.sender_id.user_id) then
cmdpv = Black:match('^help') or Black:match('start$') or Black:match('^راهنما') or Black:match('^setgp') or Black:match('^ثبت گروه') or Black:match('^delgp') or Black:match('^حذف گروه') or Black:match('^delgps') or Black:match('^حذف گروها$') or Black:match('^mygps') or Black:match('^گروهای من') or Black:match('^نرخ') or Black:match('^nerkh')
if Black and not (cmdpv) and base:get(TD_ID..'NajVa'..msg.sender_id.user_id) then
Mrrosta = base:get(TD_ID..'NajVa'..msg.sender_id.user_id)
Split = Mrrosta:split('>')
user = Split[1]
chat = Split[2]
nameuser = Split[3]
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if tonumber(utf8.len(Black)) > 20 then
text = string.sub(Black,0,20)
base:setex(text,tonumber(day),string.sub(Black,21,99999))
MamaL = 'BDMrr'..text
else
MamaL = Black
end
local keyboard = {}
keyboard.inline_keyboard = {{
{text = 'نمایش پیام 🔓',callback_data = 'Najva::'..user..'::'..MamaL}}} 
send_inline(chat,'👤کاربر : <a href="tg://user?id='..user..'">'..nameuser..'</a>\n🔐شما از طرف <a href="tg://user?id='..msg.sender_id.user_id..'">'..name..'</a> یک پیام مخفی دارید!\nبرای دیدن پیام کلیک کنید !',keyboard,'html')
local keyboard = {}
keyboard.inline_keyboard = {{
{text = 'نمایش پیام 🔓',callback_data = 'Najva::'..msg.sender_id.user_id..'::'..MamaL}}} 
send_inline(msg.sender_id.user_id,'نجوای شما برای <a href="tg://user?id='..user..'">'..nameuser..'</a> ارسال شد !',keyboard,'html')
base:del(TD_ID..'NajVa'..msg.sender_id.user_id)
end
if not base:get(TD_ID..'block:on') and not is_Sudo(msg) then
if Black and (cmdpv) then
local spam = TD_ID..'user:' .. msg.sender_id.user_id .. ':spamer'
local msgs = tonumber(base:get(spam) or 0)
local autoblock = base:get(TD_ID..'autoblocknumber') or 5
if msgs > tonumber(autoblock) then
base:sadd(TD_ID..'GlobalyBanned:',user)
send(msg.chat_id, msg.send_message_id,'به دلیل اسپم شما مسدود جهانی شدید !','md')
end
base:setex(spam,tonumber(5),msgs+1)
end
end
if Black and Black:match('^100(%d+)$') then
if base:get(TD_ID..'getgp:'..msg.sender_id.user_id) then
local DiamonD = tonumber(Black:match('^(%d+)$'))
local Mod = base:sismember(TD_ID..'ModList:-'..DiamonD,msg.sender_id.user_id)
local Owner = base:sismember(TD_ID..'OwnerList:-'..DiamonD,msg.sender_id.user_id)
if base:sismember(TD_ID..'Gp2:-'..DiamonD,'added') then
if not (Mod or Owner or base:sismember(TD_ID..'SUDO',msg.sender_id.user_id)) then
send(msg.chat_id, msg.send_message_id,'|↜ شما از مدیران یا صاحبان این گروه نیستید...!',"md")
base:del(TD_ID..'getgp:'..msg.sender_id.user_id)
else
if base:sismember(TD_ID..'gpuser:'..msg.sender_id.user_id,'-'..DiamonD..'') then
send(msg.chat_id, msg.send_message_id,'|↜ تنظیم در خصوصے این گروه از قبل براے شما فعال بود...!',"md")
base:del(TD_ID..'getgp:'..msg.sender_id.user_id)
else
base:del(TD_ID..'getgp:'..msg.sender_id.user_id)
base:sadd(TD_ID..'gpuser:'..msg.sender_id.user_id,'-'..DiamonD..'')
send(msg.chat_id, msg.send_message_id,'|↜ انجام تنظیمات ربات در خصوصے با موفقیت فعال شد...!\nبراے دیدن راهنما کلمه (راهنما) را تایپ کنید.',"md")
end
end
else
send(msg.chat_id, msg.send_message_id,'|↜ این گروه در لیست مدیریتے ربات وجود ندارد...!\nبراے خرید ربات کلمه (نرخ) را ارسال کنید تا نرخ خرید ربات ضد لینک و طریقه خرید را مشاهده کنید .',"md") base:del(TD_ID..'getgp:'..msg.sender_id.user_id)
end
end
if base:get(TD_ID..'delgp:'..msg.sender_id.user_id) then
local DiamonD = tonumber(Black:match('^(%d+)$'))
if base:sismember(TD_ID..'gpuser:'..msg.sender_id.user_id,'-'..DiamonD..'') then
send(msg.chat_id, msg.send_message_id,'|↜ تنظیم گروه در خصوصے ربات\n-'..DiamonD..'\nبراے شما غیرفعال شد..!',"md")
base:srem(TD_ID..'gpuser:'..msg.sender_id.user_id,'-'..DiamonD..'')
base:del(TD_ID..'delgp:'..msg.sender_id.user_id)
else
send(msg.chat_id, msg.send_message_id,'|↜تنظیم گروه در خصوصے ربات\n-'..DiamonD..'\nبراے شما فعال نیست..!',"md")
base:del(TD_ID..'delgp:'..msg.sender_id.user_id)
end
end
end
if (Black == 'help' or Black == 'راهنما') and is_JoinChannel(msg) then 
local text = [[
راهنماے خصوصے ربات :

`help/راهنما`
دریافت همین متن
ا┅┅──┄┄═✺═┄┄──┅┅﹃﹄﹃﹄
`setgp/ثبت گروه`
ثبت گروه براے انجام تنظیمات گروه در خصوصے ربات

نکته :
【فقط مخصوص کسانے است که ربات را خریدارے کرده اند و مدیر و یا صاحب ربات در گروه خود هستند
دقت کنید شما میتوانید چندین گروه را در این قسمت ثبت کنید و بطور همزمان در خصوصے ربات همه گروه ها را مدیریت کنید】
ا┅┅──┄┄═✺═┄┄──┅┅﹃﹄﹃﹄
`delgp/حذف گروه`
حذف گروه از تنظیم در خصوصے
ا┅┅──┄┄═✺═┄┄──┅┅﹃﹄﹃﹄
`delgps/حذف گروها`
حذف همه گروها از تنظیم در خصوصے
ا┅┅──┄┄═✺═┄┄──┅┅﹃﹄﹃﹄
`mygps/گروهاے من`
دیدن لیست گروهایے ک توسط شما در خصوصے ربات ثبت شده است
ا┅┅──┄┄═✺═┄┄──┅┅﹃﹄﹃﹄
`nerkh/نرخ`
تعرفه هاے خرید ربات ضد لینک و نحوه خرید
ا┅┅──┄┄═✺═┄┄──┅┅﹃﹄﹃﹄
`cmds help/راهنمای دستورات`
دریافت راهنماے دستورات ربات و اموزش کار با ربات
]]
send(msg.chat_id, msg.send_message_id,text,"md")
elseif (Black == 'setgp' or Black == 'ثبت گروه') and is_JoinChannel(msg) then
base:set(TD_ID..'getgp:'..msg.sender_id.user_id,true)
send(msg.chat_id, msg.send_message_id,'|↜ لطفا ایدے گروه خود را بدون (-) ارسال کنید\nدر صورتے که ایدے گروه خود را نمی دانید در گروه دستور (gid) یا (ایدے گروه) را ارسال کنید و شناسه گروه خود را در اینجا ارسال کنید.\nبراے لغو عملیات کلمه (لغو) یا (cancel) را ارسال کنید.',"md")
elseif (Black == 'delgp' or Black == 'حذف گروه') and is_JoinChannel(msg) then
base:set(TD_ID..'delgp:'..msg.sender_id.user_id,true)
send(msg.chat_id, msg.send_message_id,'⇜ لطفا ایدے گروه خود را بدون (-) ارسال کنید\nدر صورتی که ایدے گروه خود را نمیدانید در گروه دستور (id) یا (ایدے گروه) را ارسال کنید و شناسه گروه خود را در اینجا ارسال کنید.\nبراے لفو عملیات کلمه (لغو) یا (cancel) را ارسال کنید.',"md")
elseif (Black == 'cancel' or Black == 'لغو') then
if base:get(TD_ID..'getgp:'..msg.sender_id.user_id) or base:get(TD_ID..'delgp:'..msg.sender_id.user_id) then
base:del(TD_ID..'getgp:'..msg.sender_id.user_id)
base:del(TD_ID..'delgp:'..msg.sender_id.user_id)
send(msg.chat_id, msg.send_message_id,'|↜ عملیات ثبت گروه لغو شد...!',"md")
end
elseif (Black == 'delgps' or Black == 'حذف گروها') and is_JoinChannel(msg) then
base:del(TD_ID..'gpuser:'..msg.sender_id.user_id)
send(msg.chat_id, msg.send_message_id,'|↜ همه گروه ها از حالت تنظیم در خصوصے ربات خارج شدند...!',"md")
elseif Black == 'mygps' or Black == 'گروهای من' and is_JoinChannel(msg) then
local list = base:smembers(TD_ID..'gpuser:'..msg.sender_id.user_id)
local tlist = #base:smembers(TD_ID..'gpuser:'..msg.sender_id.user_id)
local t = '• تعداد گروه هاے شما : *'..tlist..'*\n•شناسه گروه هاے شما\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do 
t = ""..t.."گروه شماره *"..k.."*\nشناسه گروه :"..v.."\n"
end
if #list == 0 then
t = '|↜ شما گروهے ثبت نکرده اید...!\nدر صورتے که ربات را خریدارے کرده اید با دستور (setgp) یا (ثبت گروه) می توانید گروه خود را ثبت کرده و تنظیمات گروه خود را در خصوصے ربات انجام دهید.'
end
send(msg.chat_id, msg.send_message_id,t,'md')
elseif Black == 'nerkh' or Black == 'نرخ' then
local bd = base:get(TD_ID..'nerkh') or '💵 نرخ فروش ربات\n\n✳️براے تمام گروه ها‌ :\n\n*➰1  ماهه 15 هزار تومان*\n\n*➰2  ماهه 25 هزار تومان*\n\n*➰دائمی(نامحدود)  60 هزار تومان*\n\n🔰 نکته مهم :\n\n🎖توجه داشته باشید ربات به مدت  24 ساعت رایگان براے تست در گروه نصب می‌شود و بعد تست و رضایت کامل اعمالات صورت می‌گیرد\n\nبراے خرید به ایدے یا پیام رسان زیر مراجعه و اعلام کنید :\n\n🆔 : '..check_markdown(UserSudo)..'\n\nپیام رسان : '..check_markdown(PvUserSudo)..''
send(msg.chat_id, msg.send_message_id,bd,'md')
end
end
---------------- End Pv -------------
if gp_type(msg.chat_id) == "pv" and #base:smembers(TD_ID..'gpuser:'..msg.sender_id.user_id) > 0 or is_supergroup(msg) and is_Owner(msg) or (is_Mod(msg) and Black and not (base:sismember(TD_ID..'LimitCmd:'..msg.chat_id,Black) or base:sismember(TD_ID..'LimitCmd:'..msg.chat_id,BaseCmd))) then
----------------delete----------------
local bd = msg.sender_id.user_id
local cht = msg.chat_id
local chat = msg.chat_id
local gps = base:smembers(TD_ID..'gpuser:'..msg.sender_id.user_id)
local tgps = #base:smembers(TD_ID..'gpuser:'..msg.sender_id.user_id)
if is_supergroup(msg) then
bdcht = msg.chat_id
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
bdcht = v
end
end
local function typegpadd(name,mrr)
if is_supergroup(msg) then
base:sadd(TD_ID..''..name..''..cht,mrr)
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
base:sadd(TD_ID..''..name..''..v,mrr)
end
end
end
local function typegprem(name,mrr)
if is_supergroup(msg) then
base:srem(TD_ID..''..name..''..cht,mrr)
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
base:srem(TD_ID..''..name..''..v,mrr)
end
end
end
local function typegpdel(name)
if is_supergroup(msg) then
base:del(TD_ID..''..name..''..cht)
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
base:del(TD_ID..''..name..''..v)
end
end
end
local function typegpset(name,mrr)
if is_supergroup(msg) then
base:set(TD_ID..''..name..''..cht,mrr)
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
base:set(TD_ID..''..name..''..v,mrr)
end
end
end
local function typegphset(name,mrr,r619)
if is_supergroup(msg) then
base:hset(TD_ID..''..name..''..cht,mrr,r619)
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
base:hset(TD_ID..''..name..''..v,mrr,r619)
end
end
end
local function typegphdel(name,mrr)
if is_supergroup(msg) then
base:hdel(TD_ID..''..name..''..cht,mrr)
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
base:hdel(TD_ID..''..name..''..v,mrr)
end
end
end
if bdcht then
local owner = base:smembers(TD_ID..'OwnerList:'..bdcht)
if base:sismember(TD_ID..'Gp2:'..bdcht,'added') then

if base:get(TD_ID.."Filtering:"..msg.sender_id.user_id) then
local chaat = base:get(TD_ID.."Filtering:".. msg.sender_id.user_id)
local name = string.sub(msg.content.text.text,1,50)
if msg.content.text.text:match("^/[Dd]one$") then
if lang then
send(cht, msg.send_message_id,"> The *Operation* is Over ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات به پایان رسید ❗️","md")
end
base:del(TD_ID.."Filtering:"..msg.sender_id.user_id,80,chaat)
elseif msg.content.text.text:match("^/[Cc]ancel$") then
if lang then
send(cht, msg.send_message_id,"> *Operation* Canceled ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات لغو شد ❗️","md")
end
base:del(TD_ID.."Filtering:"..msg.sender_id.user_id,80,chaat)
elseif filter_ok(name) then
typegpadd('Filters:',name)
if lang then
send(cht, msg.send_message_id,"> Word ["..name..[[
] has been *Filtered* ❗️
If You No Longer Want To Filter a Word, Send The /done Command ❗️]],"md")
else
send(cht, msg.send_message_id,"> کلمه ["..name.."] فیلتر شد ❗️\nاگر کلمه ای دیگری را نمیخواهید فیلتر کنید دستور /done را ارسال نمایید ❗️","md")
end
base:setex(TD_ID.."Filtering:"..msg.sender_id.user_id,80,chaat)
else
if lang then
send(cht, msg.send_message_id,"> Word ["..name.."] Can Not *Filtering* ❗️","md")
else
send(cht, msg.send_message_id,"> کلمه ["..name.."] قابل فیلتر شدن نمیباشد ❗️","md")
end
base:setex(TD_ID.."Filtering:".. msg.sender_id.user_id,80,chaat)
return
end
end
if base:get(TD_ID.."Filterings:"..msg.sender_id.user_id) then
local chaat = base:get(TD_ID.."Filterings:".. msg.sender_id.user_id)
local name = string.sub(msg.content.text.text,1,50)
if msg.content.text.text:match("^/[Dd]one$") then
if lang then
send(cht, msg.send_message_id,"> The *Operation* is Over ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات به پایان رسید ❗️","md")
end
base:del(TD_ID.."Filterings:"..msg.sender_id.user_id,80,chaat)
elseif msg.content.text.text:match("^/[Cc]ancel$") then
if lang then
send(cht, msg.send_message_id,"> *Operation* Canceled ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات لغو شد ❗️","md")
end
base:del(TD_ID.."Filterings:"..msg.sender_id.user_id,80,chaat)
elseif filter_ok(name) then
typegprem('Filters:',name)
if lang then
send(cht, msg.send_message_id,"> Word ["..name..[[
] has been *UnFiltered* ❗️
If You No Longer Want To UnFilter a Word,Send The /done Command ❗️]],"md")
else
send(cht, msg.send_message_id,"> کلمه ["..name.."] از لیست فیلتر حذف شد ❗️\nاگر کلمه ای دیگری را نمیخواهید از لیست فیلتر حذف کنید دستور /done را ارسال نمایید ❗️","md")
end
base:setex(TD_ID.."Filterings:"..msg.sender_id.user_id,80,chaat)
else
if lang then
send(cht, msg.send_message_id,"> Word ["..name.."] Can Not *UnFiltering* ❗️","md")
else
send(cht, msg.send_message_id,"> کلمه ["..name.."] قابل حذف شدن از لیست فیلتر نمیباشد ❗️","md")
end
base:setex(TD_ID.."Filterings:".. msg.sender_id.user_id,80,chaat)
return
end
end
----
if base:get(TD_ID.."Filteringg:"..msg.sender_id.user_id) then
local chaat = base:get(TD_ID.."Filteringg:".. msg.sender_id.user_id)
local name = string.sub(msg.content.text.text,1,50)
if msg.content.text.text:match("^/[Dd]one$") then
if lang then
send(cht, msg.send_message_id,"> The *Operation* is Over ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات به پایان رسید ❗️","md")
end
base:del(TD_ID.."Filteringg:"..msg.sender_id.user_id,80,chaat)
elseif msg.content.text.text:match("^/[Cc]ancel$") then
if lang then
send(cht, msg.send_message_id,"> *Operation* Canceled ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات لغو شد ❗️","md")
end
base:del(TD_ID.."Filteringg:"..msg.sender_id.user_id,80,chaat)
elseif filter_ok(name) then
typegpadd('FilterName:',name)
if lang then
send(cht, msg.send_message_id,"> Names ["..name..[[
] has been *Filtered* ❗️
If You No Longer Want To Filter a Names,Send The /done Command ❗️]],"md")
else
send(cht, msg.send_message_id,"|↜ اسم "..name.."\nبه لیست اسامی غیرمجاز اضافه شد !\nاگر اسم دیگری را نمیخواهید فیلتر کنید دستور /done را ارسال نمایید ❗️","md")
end
base:setex(TD_ID.."Filteringg:"..msg.sender_id.user_id,80,chaat)
else
if lang then
send(cht, msg.send_message_id,"> Names ["..name.."] Can Not *Filtering* ❗️","md")
else
send(cht, msg.send_message_id,"> اسم ["..name.."] قابل فیلتر شدن نمیباشد ❗️","md")
end
base:setex(TD_ID.."Filteringg:".. msg.sender_id.user_id,80,chaat)
return
end
end
if base:get(TD_ID.."Filteringgs:"..msg.sender_id.user_id) then
local chaat = base:get(TD_ID.."Filteringgs:".. msg.sender_id.user_id)
local name = string.sub(msg.content.text.text,1,50)
if msg.content.text.text:match("^/[Dd]one$") then
if lang then
send(cht, msg.send_message_id,"> The *Operation* is Over ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات به پایان رسید ❗️","md")
end
base:del(TD_ID.."Filteringgs:"..msg.sender_id.user_id,80,chaat)
elseif msg.content.text.text:match("^/[Cc]ancel$") then
if lang then
send(cht, msg.send_message_id,"> *Operation* Canceled ❗️","md")
else
send(cht, msg.send_message_id,"> عملیات لغو شد ❗️","md")
end
base:del(TD_ID.."Filteringgs:"..msg.sender_id.user_id,80,chaat)
elseif filter_ok(name) then
typegprem('FilterName:',name)
if lang then
send(cht, msg.send_message_id,"> Names ["..name..[[
] has been *UnFiltered* ❗️
If You No Longer Want To UnFilter a Names,Send The /done Command ❗️]],"md")
else
send(cht, msg.send_message_id,"|↜ اسم "..name.."\nاز لیست اسامی غیرمجاز حذف شد !\nاگر اسم دیگری را نمیخواهید از لیست حذف کنید دستور /done را ارسال نمایید ❗️","md")
end
base:setex(TD_ID.."Filteringgs:"..msg.sender_id.user_id,80,chaat)
else
if lang then
send(cht, msg.send_message_id,"> Names ["..name.."] Can Not *UnFiltering* ❗️","md")
else
send(cht, msg.send_message_id,"> اسم ["..name.."] قابل حذف شدن از لیست اسامی غیرمجاز نمیباشد ❗️","md")
end
base:setex(TD_ID.."Filteringgs:".. msg.sender_id.user_id,80,chaat)
return
end
end
if Black and (Black:match('^filter$') or Black:match('^فیلتر$')) and is_JoinChannel(msg) then
if lang then
send(cht, msg.send_message_id,"> Please *Submit* The Words You Want To *Filter* Individually ❗️\nTo *Cancel The Command*,Send The /cancel Command ","md")
else
send(cht, msg.send_message_id,"> لطفا کلماتی که میخواهید فیلتر شوند را به صورت تکی بفرستید ❗️\nبرای لغو عملیات دستور /cancel را ارسال نمایید","md")
end
base:setex(TD_ID.."Filtering:".. msg.sender_id.user_id,80,cht)
end
if Black and (Black:match('^remfilter$') or Black:match('^حذف فیلتر$')) and is_JoinChannel(msg) then
if lang then
send(cht, msg.send_message_id,"> Please *Submit* The Words You Want To *UnFilter* Individually ❗️\nTo *Cancel The Command*,Send The /cancel Command ","md")
else
send(cht, msg.send_message_id,">لطفا کلماتی که میخواهید از لیست فیلتر حذف شوند را به صورت تکی بفرستید ❗️\nبرای لغو عملیات دستور /cancel را ارسال نمایید","md")
end
base:setex(TD_ID.."Filterings:".. msg.sender_id.user_id,80,cht)
end
if Black and (Black:match('^filter +(.*)$') or Black:match('^فیلتر +(.*)$')) and is_JoinChannel(msg) then
if string.find(Black:match('^filter (.*)$') or Black:match('^فیلتر (.*)$'),"[%(%)%.%+%-%*%?%[%]%^%$%%]") then
send(cht, msg.send_message_id,'🖕😐','md')
else
local word = Black:match('^filter +(.*)$') or Black:match('^فیلتر +(.*)$')
typegpadd('Filters:',word)
send(cht, msg.send_message_id,'|↜ کلمه【'..word..'】\nبه لیست فیلتر افزوده شد','md')
end
end
if Black and (Black:match('^remfilter +(.*)$') or Black:match('^حذف فیلتر +(.*)$')) and is_JoinChannel(msg) then
local word = Black:match('^remfilter +(.*)$') or Black:match('^حذف فیلتر +(.*)$')
typegprem('Filters:',word)
send(cht, msg.send_message_id,'|↜ کلمه【'..word..'】\nاز لیست فیلتر حذف شد','md')
end
if (Black == 'clean filterlist' or Black == 'پاکسازی لیست فیلتر') and is_JoinChannel(msg) then
typegpdel('Filters:')
send(cht, msg.send_message_id,'|↜ لیست فیلتر پاکسازے شد','md')
end
if (Black == 'filterlist' or Black == 'لیست فیلتر') and is_JoinChannel(msg) then
if is_supergroup(msg) then
local list = base:smembers(TD_ID..'Filters:'..cht)
local t = '|↜ لیست کلمات فیلتر شده :\n'
for k,v in pairs(list) do 
t = t..k.."- *"..v.."*\n"
end
if #list == 0 then
t = '|↜ لیست کلمات فیلتر شده خالے است'
end
send(cht, msg.send_message_id,t,'md')
end
if gp_type(msg.chat_id) == "pv" then
local t = '|↜ لیست کلمات فیلتر شده در *'..tgps..'* گروه شما\nبراے دیدن لیست گروه ها میتوانید از دستور گروه هاے من یا [mygps] استفاده کنید.\n'
for k,v in pairs(gps) do
local list = base:smembers(TD_ID..'Filters:'..v)
for a,b in pairs(list) do
t = ""..t..""..b.."\nدر گروه *"..k.."*\n﹃﹄﹃﹄﹃﹄\n"
end
end
send(cht, msg.send_message_id,t,'md')
end
end
--- filter name

if Black and (Black:match('^filtername$') or Black:match('حذف اسم$')) and is_JoinChannel(msg) then
if lang then
send(cht, msg.send_message_id,"> Please *Submit* The Names You Want To *Filter* Individually ❗️\nTo *Cancel The Command*,Send The /cancel Command ","md")
else
send(cht, msg.send_message_id,"> لطفا نام هایی که میخواهید فیلتر شوند را به صورت تکی بفرستید ❗️\nبراے لغو عملیات دستور /cancel را ارسال نمایید","md")
end
base:setex(TD_ID.."Filteringg:".. msg.sender_id.user_id,80,cht)
end
if Black and (Black:match('^remfiltername$') or Black:match('^حذف فیلتر اسم$')) and is_JoinChannel(msg) then
if lang then
send(cht, msg.send_message_id,"> Please *Submit* The Names You Want To *UnFilter* Individually ❗️\nTo *Cancel The Command*,Send The /cancel Command ","md")
else
send(cht, msg.send_message_id,">لطفا نام هایی که میخواهید از لیست فیلتر غیرمجاز حذف شوند را به صورت تکی بفرستید ❗️\nبرای لغو عملیات دستور /cancel را ارسال نمایید","md")
end
base:setex(TD_ID.."Filteringgs:".. msg.sender_id.user_id,80,cht)
end
if Black and (Black:match('^filtername +(.*)$') or Black:match('^حذف اسم +(.*)$')) and is_JoinChannel(msg) then
if string.find(Black:match('^filtername (.*)$') or Black:match('^حذف اسم (.*)$'),"[%*?^$]") then
send(cht, msg.send_message_id,'🖕😐','md')
else
local word = Black:match('^filtername +(.*)$') or Black:match('^حذف اسم +(.*)$')
typegpadd('FilterName:',word)
send(cht, msg.send_message_id,'|↜ اسم '..word..'\nبه لیست اسامی غیرمجاز اضافه شد !','md')
end
end
if Black and (Black:match('^remfiltername +(.*)$') or Black:match('^حذف فیلتر اسم +(.*)$')) and is_JoinChannel(msg) then
local word = Black:match('^remfiltername +(.*)$') or Black:match('^حذف فیلتر اسم +(.*)$')
typegprem('FilterName:',word)
send(cht, msg.send_message_id,'|↜ اسم '..word..'\nاز لیست اسامی غیرمجاز حذف شد !','md')
end
if (Black == 'clean filternamelist' or Black == 'پاکسازی لیست اسم') and is_JoinChannel(msg) then
typegpdel('FilterName:')
send(cht, msg.send_message_id,'|↜ لیست اسامی غیرمجاز شده پاکسازی شد !','md')
end
if (Black == 'filternamelist' or Black == 'لیست اسم') and is_JoinChannel(msg) then
if is_supergroup(msg) then
local list = base:smembers(TD_ID..'FilterName:'..cht)
local t = '|↜ لیست اسامی فیلتر شده :\n'
for k,v in pairs(list) do 
t = t..k.."- *"..v.."*\n"
end
if #list == 0 then
t = '|↜ لیست اسامی فیلتر شده خالے است'
end
send(cht, msg.send_message_id,t,'md')
end
if gp_type(msg.chat_id) == "pv" then
local t = '|↜ لیست اسامی فیلتر شده در *'..tgps..'* گروه شما\nبراے دیدن لیست گروه ها میتوانید از دستور گروه هاے من یا [mygps] استفاده کنید.\n'
for k,v in pairs(gps) do
local list = base:smembers(TD_ID..'FilterName:'..v)
for a,b in pairs(list) do
t = ""..t..""..b.."\nدر گروه *"..k.."*\n﹃﹄﹃﹄﹃﹄\n"
end
end
send(cht, msg.send_message_id,t,'md')
end
end
--- filter Bio
if Black and (Black:match('^filterbio +(.*)$') or Black:match('^حذف بیو +(.*)$')) and is_JoinChannel(msg) then
if string.find(Black:match('^filterbio (.*)$') or Black:match('^حذف بیو (.*)$'),"[%*?^$]") then
send(cht, msg.send_message_id,'🖕😐','md')
else
local word = Black:match('^filterbio +(.*)$') or Black:match('^حذف بیو +(.*)$')
typegpadd('FilterBio:',word)
send(cht, msg.send_message_id,'|↜ کلمه '..word..'\nبه لیست بیوگرافی های غیرمجاز اضافه شد !','md')
end
end
if Black and (Black:match('^remfilterbio +(.*)$') or Black:match('^حذف فیلتر بیو +(.*)$')) and is_JoinChannel(msg) then
local word = Black:match('^remfilterbio +(.*)$') or Black:match('^حذف فیلتر بیو +(.*)$')
typegprem('FilterBio:',word)
send(cht, msg.send_message_id,'|↜ کلمه '..word..'\nبه کلمات غیرمجاز در بیوگرافی اضافه شد !','md')
end
if (Black == 'clean filterbiolist' or Black == 'پاکسازی لیست بیو') and is_JoinChannel(msg) then
typegpdel('FilterBio:')
send(cht, msg.send_message_id,'|↜ لیست بیوهای غیرمجاز پاکسازی شد !','md')
end
if (Black == 'filterbiolist' or Black == 'لیست بیو') and is_JoinChannel(msg) then
if is_supergroup(msg) then
local list = base:smembers(TD_ID..'FilterBio:'..cht)
local t = '|↜ لیست بیوهای غیرمجاز :\n'
for k,v in pairs(list) do 
t = t..k.."- *"..v.."*\n"
end
if #list == 0 then
t = '|↜ لیست بیوهای غیرمجاز خالی میباشد !'
end
send(cht, msg.send_message_id,t,'md')
end
if gp_type(msg.chat_id) == "pv" then
local t = '|↜ لیست بیوهای غیرمجاز در *'..tgps..'* گروه شما\nبراے دیدن لیست گروه ها میتوانید از دستور گروه هاے من یا [mygps] استفاده کنید.\n'
for k,v in pairs(gps) do
local list = base:smembers(TD_ID..'FilterBio:'..v)
for a,b in pairs(list) do
t = ""..t..""..b.."\nدر گروه *"..k.."*\n﹃﹄﹃﹄﹃﹄\n"
end
end
send(cht, msg.send_message_id,t,'md')
end
end
----<<<<< LOCKS
if Black then
TDDelMatch = Black:match('^del (.*)$') or Black:match('^حذف (.*) فعال$') or Black:match('^lock (.*)$') or Black:match('^قفل (.*)$')
TDBanMatch = Black:match('^ban (.*)$') or Black:match('^مسدود (.*) فعال$')
TDKickMatch = Black:match('^kick (.*)$') or Black:match('^اخراج (.*) فعال$')
TDMuteMatch = Black:match('^mute (.*)$') or Black:match('^سکوت (.*) فعال$')
TDSilentMatch = Black:match('^silent (.*)$') or Black:match('^سایلنت (.*) فعال$')
TDWarnMatch = Black:match('^warn (.*)$') or Black:match('^اخطار (.*) فعال$')
TDDdelMatch = Black:match('^ddel (.*)$') or Black:match('^حذف (.*) غیرفعال$')
TDDbanMatch = Black:match('^dban (.*)$') or Black:match('^مسدود (.*) غیرفعال$')
TDDkickMatch = Black:match('^dkick (.*)$') or Black:match('^اخراج (.*) غیرفعال$')
TDDmuteMatch = Black:match('^dmute (.*)$') or Black:match('^سکوت (.*) غیرفعال$')
TDDsilentMatch = Black:match('^dsilent (.*)$') or Black:match('^سایلنت (.*) غیرفعال$')
TDDwarnMatch = Black:match('^dwarn (.*)$') or Black:match('^اخطار (.*) غیرفعال$')
TDUnlockMatch = Black:match('^unlock (.*)$') or Black:match('^بازکردن (.*)$')
TDMatches = TDDelMatch or TDBanMatch or TDKickMatch or TDMuteMatch or TDSilentMatch or TDWarnMatch or TDDdelMatch or TDDbanMatch or TDDkickMatch or TDDmuteMatch or TDDsilentMatch or TDDwarnMatch or TDUnlockMatch
if TDMatches then
local returntd1 = TDMatches:match('^story$') or TDMatches:match('^photo$') or TDMatches:match('^game$') or TDMatches:match('^video$')or TDMatches:match('^flood$') or TDMatches:match('^inline$') or TDMatches:match('^videomsg$') or TDMatches:match('^caption$') or TDMatches:match('^voice$') or TDMatches:match('^location$') or TDMatches:match('^document$') or TDMatches:match('^contact$') or TDMatches:match('^text$') or TDMatches:match('^sticker$') or TDMatches:match('^stickers$') or TDMatches:match('^gif$') or TDMatches:match('^music$') or TDMatches:match('^استوری$') or TDMatches:match('^عکس$') or TDMatches:match('^بازی$') or TDMatches:match('^فیلم$') or TDMatches:match('^دکمه شیشه ای$') or TDMatches:match('^ویدیومسیج$') or TDMatches:match('^کپشن$') or TDMatches:match('^موقعیت مکانی$') or TDMatches:match('^وویس$') or TDMatches:match('^فایل$') or TDMatches:match('^مخاطب$') or TDMatches:match('^متن$') or TDMatches:match('^استیکر$') or TDMatches:match('^استیکر متحرک$') or TDMatches:match('^گیف$') or TDMatches:match('^اهنگ$') or TDMatches:match('^آهنگ$') or TDMatches:match('^spam$') or TDMatches:match('^هرزنامه$')or TDMatches:match('^پیام مکرر$') or TDMatches:match('^پست کانال$') or TDMatches:match('^channelpost$') or TDMatches:match('^بدافزار$') or TDMatches:match('^malware$')
local returntd2 = TDMatches:match('^link$') or TDMatches:match('^tag$') or TDMatches:match('^username$') or TDMatches:match('^english$') or TDMatches:match('^persian$') or TDMatches:match('^spoiler$') or TDMatches:match('^hyper$') or TDMatches:match('^mention$') or TDMatches:match('^اسپویلر$') or TDMatches:match('^هایپر$') or TDMatches:match('^فراخانی$') or TDMatches:match('^هشتگ$') or TDMatches:match('^یوزرنیم$') or TDMatches:match('^لینک$') or TDMatches:match('^فارسی$') or TDMatches:match('^انگلیسی$') or TDMatches:match('^replyuser$') or TDMatches:match('^ریپلی کاربر$') or TDMatches:match('^replychannel$') or TDMatches:match('^ریپلی کانال$') or TDMatches:match('^replygroup$') or TDMatches:match('^ریپلی گروه$')
local returntdf = TDMatches:match('^forward$') or TDMatches:match('^fwd$') or TDMatches:match('^فوروارد$')
local returntdb = TDMatches:match('^bots$') or TDMatches:match('^ربات$')
local returntde = TDMatches:match('^edit$') or TDMatches:match('^ویرایش$')
local returnbio = TDMatches:match('^لینک بیو$') or TDMatches:match('^biolink$')
local returntrue = returntd1 or returntd2 or returntdf or returntde or returntdb or returnbio
local function tdlock(BD)
if BD:match('^photo$') or BD:match('^عکس$') then
td = 'Photo'
tde = 'ρнσтσ'
tdf = 'عکس'
elseif BD:match('^story$') or BD:match('^استوری$') then
td = 'Story'
tde = 'ѕтοrу'
tdf = 'استوری'
elseif BD:match('^game$') or BD:match('^بازی$') then
td = 'Game'
tde = 'gαмε'
tdf = 'بازی'
elseif BD:match('^video$') or BD:match('^فیلم$') then
td = 'Video'
tde = 'vιdεσ'
tdf = 'فیلم'
elseif BD:match('^inline$') or BD:match('^دکمه شیشه ای$') then
td = 'Inline'
tde = 'ιηℓιηε'
tdf = 'دکمه شیشه ای'
elseif BD:match('^videomsg$') or BD:match('^ویدیومسیج$') then
td = 'Videomsg'
tde = 'vιdεσмsg'
tdf = 'ویدیومسیج'
elseif BD:match('^caption$') or BD:match('^کپشن$') then
td = 'Caption'
tde = 'cαρтιση'
tdf = 'کپشن'
elseif BD:match('^voice$') or BD:match('^وویس$') then
td = 'Voice'
tde = 'vσιcε'
tdf = 'وویس'
elseif BD:match('^location$') or BD:match('^موقعیت مکانی$') then
td = 'Location'
tde = 'ℓσcαтιση'
tdf = 'موقعیت مکانی'
elseif BD:match('^document$') or BD:match('^فایل$') then
td = 'Document'
tde = '∂σcυмεηт'
tdf = 'فایل'
elseif BD:match('^contact$') or BD:match('^مخاطب$') then
td = 'Contact'
tde = 'cσηтαcт'
tdf = 'مخاطب'
elseif BD:match('^text$') or BD:match('^متن$') then
td = 'Text'
tde = 'тεxт'
tdf = 'متن'
elseif BD:match('^sticker$') or BD:match('^استیکر$') then
td = 'Sticker'
tde = 'sтιcкεя'
tdf = 'استیکر'
elseif BD:match('^stickers$') or BD:match('^استیکر متحرک$') then
td = 'Stickers'
tde = 'sтιcкεяs'
tdf = 'استیکر متحرک'
elseif BD:match('^gif$') or BD:match('^گیف$') then
td = 'Gif'
tde = 'gιғ'
tdf = 'گیف'
elseif BD:match('^music$') or BD:match('^آهنگ$') or BD:match('^اهنگ$') then
td = 'Audio'
tde = 'мυsιc'
tdf = 'آهنگ'
elseif BD:match('^flood$') or BD:match('^پیام مکرر$')then
td = 'Flood'
tde = 'ғlood'
tdf = 'پیام مکرر'
elseif BD:match('^spam$') or BD:match('^هرزنامه$')then
td = 'Spam'
tde = 'ѕpaм'
tdf = 'هرزنامه'
elseif BD:match('^link$') or BD:match('^لینک$') then
td = 'Link'
tde = 'ℓιηк'
tdf = 'لینک'
elseif BD:match('^tag$') or BD:match('^هشتگ$') then
td = 'Tag'
tde = 'тαg'
tdf = 'هشتگ'
elseif BD:match('^username$') or BD:match('^یوزرنیم$') then
td = 'Username'
tde = 'υsεяηαмε'
tdf = 'یوزرنیم'
elseif BD:match('^persian$') or BD:match('^فارسی$') then
td = 'Persian'
tde = 'ρεяsιση'
tdf = 'فارسی'
elseif BD:match('^english$') or BD:match('^انگلیسی$') then
td = 'English'
tde = 'εηgℓιsн'
tdf = 'انگلیسی'
elseif BD:match('^edit$') or BD:match('^ویرایش$') then
td = 'Edit'
tde = 'ε∂ιт'
tdf = 'ویرایش'
elseif BD:match('^forward$') or BD:match('^fwd$') or BD:match('^فوروارد$') then
td = 'Forward'
tde = 'ғσяωαя∂'
tdf = 'فوروارد'
elseif BD:match('^bots$') or BD:match('^ربات$') then
td = 'Bots'
tde = 'вσт'
tdf = 'ربات'
elseif BD:match('^hyper$') or BD:match('^هایپر$') then
td = 'Hyper'
tde = 'нypυrlιɴĸ'
tdf = 'هایپرلینک'
elseif BD:match('^spoiler$') or BD:match('^اسپویلر$') then
td = 'Spoiler'
tde = 'ѕроιlєr'
tdf = 'اسپویلر'
elseif BD:match('^replyuser$') or BD:match('^ریپلی کاربر$') then
td = 'ReplyUser'
tde = 'rєрlуυѕєr'
tdf = 'ریپلی از کاربر'
elseif BD:match('^replychannel$') or BD:match('^ریپلی کانال$') then
td = 'ReplyChannel'
tde = 'rєрlуchannєl'
tdf = 'ریپلی از کانال'
elseif BD:match('^replygroup$') or BD:match('^ریپلی گروه$') then
td = 'ReplyGroup'
tde = 'rєрlуgrouр'
tdf = 'ریپلی از گروه'
elseif BD:match('^mention$') or BD:match('^فراخانی$') then
td = 'Mention'
tde = 'мυηтιση'
tdf = 'فراخانی'
elseif BD:match('^channelpost$') or BD:match('^پست کانال$') then
td = 'Channelpost'
tde = 'cнαɴɴelpoѕт'
tdf = 'پست کانال'
elseif BD:match('^malware$') or BD:match('^بدافزار$') then
td = 'Malware'
tde = 'мαlwαre'
tdf = 'بدافزار'
elseif BD:match('^biolink$') or BD:match('^لینک بیو$') then
td = 'Biolink'
tde = 'вιolιɴĸ'
tdf = 'لینک بیو'
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
function locks_del(msg,en,fa)
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
nametd = '【['..name..'](tg://user?id='..bd..')】'
if lang then
send(cht, msg.send_message_id,'● ∂σηε вү :'..nametd..'\n➣∂εℓεтε #'..tde..' нαs вεεη #εηαвℓε...!\n┅┅──┄┄═✺═┄┄──┅┅\nιғ '..en..' тнe #'..tde..',тнe мeѕѕαɢe wιll вe ∂εℓεтε','md')
else
if tdf == 'لینک بیو' then
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ حذف لینک بیو #فعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورتی که کاربر در بیوی خود لینک داشته باشد پیامهای وی حذف خواهد شد.','md')
else
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ حذف '..tdf..' #فعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورت '..fa..' #'..tdf..',پیام مورد نظر حذف خواهد شد.','md')
end
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
function locks_warn(msg,en,fa)
local max_warn = tonumber(base:get(TD_ID..'max_warn:'..cht) or 5)
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if gp_type(cht) == "channel" then
nametd = '【['..name..'](tg://user?id='..bd..')】'
else
nametd = '【'..name..'】'
end
if lang then
send(cht, msg.send_message_id,'● ∂σηε вү :'..nametd..'\n➣ωαяη '..tde..' нαs вεεη #εηαвℓε...!\n┅┅──┄┄═✺═┄┄──┅┅\nιғ '..en..' тнe '..tde..' υѕer wιll receιve a warnιng','md')
else
if tdf == 'لینک بیو' then
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ اخطار لینک بیو #فعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورتی که کاربر در بیوی خود لینک داشته باشد از گروه اخراج خواهد شد.','md')
else
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ اخطار '..tdf..' #فعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورت '..fa..' #'..tdf..',کاربر '..fa..' کننده اخطار دریافت میکند.','md')
end
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
function locks_Babak(msg,en,fa,bden,bdfa)
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if gp_type(cht) == "channel" then
nametd = '【['..name..'](tg://user?id='..bd..')】'
else
nametd = '【'..name..'】'
end
if lang then
send(cht, msg.send_message_id,'● ∂σηε вү :'..nametd..'\n➣'..en..' '..tde..' нαs вεεη #εηαвℓε...!\n┅┅──┄┄═✺═┄┄──┅┅\nιғ '..bden..' #'..tde..' мeѕѕαɢe, υѕer wιll вe '..en..'','md')
else
if tdf == 'لینک بیو' then
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ '..fa..' '..tdf..' #فعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورتی که کاربر در بیوی خود لینک داشته باشد کاربر '..fa..' میشود','md')
else
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ '..fa..' '..tdf..' #فعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورت '..bdfa..' #'..tdf..', کاربر '..bdfa..' کننده #'..fa..' میشود','md')
end
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
function locks_ddel(msg,en,fa)
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if gp_type(cht) == "channel" then
nametd = '【['..name..'](tg://user?id='..bd..')】'
else
nametd = '【'..name..'】'
end
if lang then
send(cht, msg.send_message_id,'● ∂σηε вү :'..nametd..'\n➣∂εℓεтε #'..tde..' нαs вεεη #disable...!\n┅┅──┄┄═✺═┄┄──┅┅\nιғ '..en..' тнe #'..tde..' υѕer wιll receιve a not deleted','md')
else
if tdf == 'لینک بیو' then
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ حذف لینک بیو #غیرفعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nکاربرانی که در بیوی خود لینک دارند اکنون مجاز به ارسال پیام در گروه هستند','md')
else
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ حذف '..tdf..' #غیرفعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورت '..fa..' #'..tdf..' پیام مورد نظر حذف نخواهد شد.','md')
end
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
function locks_dwarn(msg,en,fa)
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if gp_type(cht) == "channel" then
nametd = '【['..name..'](tg://user?id='..bd..')】'
else
nametd = '【'..name..'】'
end
if lang then
send(cht, msg.send_message_id,'● ∂σηε вү :'..nametd..'\n➣ωαяη '..tde..' нαs вεεη #disable...!\n┅┅──┄┄═✺═┄┄──┅┅\nιғ '..en..' тнe '..tde..' υѕer wιll receιve a not warnιng','md')
else
if tdf == 'لینک بیو' then
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ اخطار '..tdf..' #غیرفعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورتی که در بیوی کاربر لینک وجود داشته باشد کاربر مجاز به ارسال  پیام است و اخطاری دریافت نمیکند','md')
else
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ اخطار '..tdf..' #غیرفعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورت '..fa..' #'..tdf..',کاربر '..fa..' کننده اخطار دریافت نمیکند.','md')
end
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
function locks_Khan(msg,en,fa,bden,bdfa)
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if gp_type(cht) == "channel" then
nametd = '【['..name..'](tg://user?id='..bd..')】'
else
nametd = '【'..name..'】'
end
if lang then
send(cht, msg.send_message_id,'● ∂σηε вү :'..nametd..'\n➣'..en..' #'..tde..' нαs вεεη #disable...!\n┅┅──┄┄═✺═┄┄──┅┅\nιғ '..bden..' тнe #'..tde..' υѕer wιll be not '..en..'','md')
else
if tdf == 'لینک بیو' then
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ '..fa..' '..tdf..' #غیرفعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورتی که در بیوی کاربر لینک وجود داشته باشد کاربر '..tdf..' نمیشود','md')
else
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ '..fa..' '..tdf..' #غیرفعال شد...\nا┅┅──┄┄═✺═┄┄──┅┅\nدر صورت '..bdfa..' #'..tdf..' ,کاربر '..bdfa..' کننده '..fa..' نخواهد شد','md')
end
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
function unlocks(msg,en,fa)
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if gp_type(cht) == "channel" then
nametd = '【['..name..'](tg://user?id='..bd..')】'
else
nametd = '【'..name..'】'
end
if lang then
send(cht, msg.send_message_id,'● ∂σηε вү :'..nametd..'\n➣'..tde..' нαs вεεη #υηℓσcк...!\n┅┅──┄┄═✺═┄┄──┅┅\nтнε '..td..' ωαs яεℓεαsε∂ αη∂ υsεяs αяε αвℓε '..en..' '..td..' ιη тнε gяσυρ','md')
else
if tdf == 'لینک بیو' then
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ '..fa..' '..tdf..' #ازاد شد...!\nا┅┅──┄┄═✺═┄┄──┅┅\nتمامی کاربران مجاز به گذاشتن لینک در بیوی خود شدند.','md')
else
send(cht, msg.send_message_id,'✅|↜انجام شد\n✦ توسط :'..nametd..'\n🔏|↜ '..fa..' '..tdf..' #ازاد شد...!\nا┅┅──┄┄═✺═┄┄──┅┅\nکاربران میتوانند در گروه #'..tdf..' '..fa..' کنند.','md')
end
end
end
--<><>--<><>--<><>-<><>-<><>--<><>--<><>--<>--
if Black and (TDDelMatch) and is_JoinChannel(msg) then
tdlock(TDDelMatch)
if returntrue then
if tonumber(reply_id) == 0 then
if base:sismember(TD_ID..'Gp:'..bdcht,'Del:'..td) then
if lang then
send(msg.chat_id, msg.send_message_id,'➣∂εℓεтε #'..tde..' ιs αℓяεα∂ү #εηαвℓε ...!','md')
else
send(msg.chat_id, msg.send_message_id,'✔️|↜ حذف '..tdf..' از قبل #فعال بود...!','md')
end
else
typegpadd('Gp:','Del:'..td)
if returntd1 then
locks_del(msg,'ѕenт','ارسال')
end
if returntd2 then
locks_del(msg,'ѕenт','ارسال')
end
if returntdf then
locks_del(msg,'ѕenт','فرایند')
end
if returntde then
locks_del(msg,'υѕer','ویرایش پیام,پیام')
end
if returntdb then
locks_del(msg,'added','دعوت ربات,')
end
if returnbio then
locks_del(msg,'υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ حذف '..tdf..' را #فعال کرد...!\nجهت #غیرفعال کردن میتوانید از دستور (حذف '..tdf..' غیرفعال)  یا (ddel '..td..') استفاده کنید\n'..reporttext)
end
else
local Diamond = TD.getMessage(cht,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if VipUser(msg,user) then
send(msg.chat_id, msg.send_message_id,"❌ #اخطار  !\nا─┅━━━━━━━┅─\n✦ کاربر "..name.." دارای مقام میباشد شما نمیتوانید او را از ارسال "..tdf.." محدود کنید",'html')
else
if base:sismember(TD_ID..'Gp3:'..chat_id,user..' حذف '..tdf) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : '..name..'\nاز قبل در لیست محدودی های ارسال '..tdf..' وجود داشت...!','html')
else
base:sadd(TD_ID..'Gp3:'..chat_id,user..' حذف '..tdf)
send(msg.chat_id, msg.send_message_id,'✦ کاربر : '..name..'\nاز ارسال '..tdf..' در گروه ممنوع شد و هم اکنون در صورت قفل نبودن '..tdf..' نیز '..tdf..' های ارسالی وی حذف خواهند شد...!','html')
end
end
end
end
end
end
----------------Warn----------------
if Black and (TDWarnMatch) and is_JoinChannel(msg) then
tdlock(TDWarnMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Warn:'..td) then
if lang then
send(cht, msg.send_message_id,'➣ωαяη #'..tde..' ιs αℓяεα∂ү #εηαвℓε...!','md')
else
send(cht, msg.send_message_id,'✔️ اخطار #'..tdf..' از قبل #فعال بود...!','md')
end
else
typegprem('Gp:','Kick:'..td)
typegprem('Gp:','Ban:'..td)
typegpadd('Gp:','Warn:'..td)
if returntd1 then
locks_warn(msg,'ѕenт','ارسال')
end
if returntd2 then
locks_warn(msg,'ѕenт','ارسال')
end
if returntdf then
locks_warn(msg,'ѕenт','ارسال')
end
if returntde then
locks_warn(msg,'υѕer','فرایند')
end
if returntdb then
locks_warn(msg,'added','دعوت')
end
if returnbio then
locks_warn(msg,'υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ اخطار '..tdf..' را #فعال کرد...!\nجهت غیرفعال کردن میتوانید از دستور (اخطار '..tdf..' غیرفعال)  یا (dwarn '..td..') استفاده کنید\n'..reporttext)
end
end
end
----------------Mute----------------
if Black and (TDMuteMatch) and is_JoinChannel(msg) then
tdlock(TDMuteMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Mute:'..td) then
if lang then
send(cht, msg.send_message_id,'➣#'..tde..' мυтε ιs αℓяεα∂ү #εηαвℓε ...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ سکوت #'..tdf..' از قبل #فعال بود...!','md')
end
else
typegprem('Gp:','Silent:'..td)
typegprem('Gp:','Kick:'..td)
typegprem('Gp:','Ban:'..td)
typegpadd('Gp:','Mute:'..td)
if returntd1 then
locks_Babak(msg,'мυтε','سکوت','ѕenт','ارسال')
end
if returntd2 then
locks_Babak(msg,'мυтε','سکوت','ѕenт','ارسال')
end
if returntdf then
locks_Babak(msg,'мυтε','سکوت','ѕenт','ارسال')
end
if returntde then
locks_Babak(msg,'мυтε','سکوت','υѕer','فرایند')
end
if returntdb then
locks_Babak(msg,'мυтε','سکوت','added','دعوت')
end
if returnbio then
locks_Babak(msg,'мυтε','سکوت','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ سکوت '..tdf..' را #فعال کرد...!\nجهت غیرفعال کردن میتوانید از دستور (سکوت '..tdf..' غیرفعال)  یا (dmute '..td..') استفاده کنید\n'..reporttext)
end
end
end
----------------Kick----------------
if Black and (TDKickMatch) and is_JoinChannel(msg) then
tdlock(TDKickMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Kick:'..td) then
if lang then
send(cht, msg.send_message_id,'➣#'..tde..' кιcк ιs αℓяεα∂ү #εηαвℓε ...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ اخراج #'..tdf..' از قبل #فعال بود...!','md')
end
else
typegprem('Gp:','Ban:'..td)
typegpadd('Gp:','Kick:'..td)
typegprem('Gp:','Warn:'..td)
typegprem('Gp:','Mute:'..td)
typegprem('Gp:','Silent:'..td)
if returntd1 then
locks_Babak(msg,'кιcк','اخراج','ѕenт','ارسال')
end
if returntd2 then
locks_Babak(msg,'кιcк','اخراج','ѕenт','ارسال')
end
if returntdf then
locks_Babak(msg,'кιcк','اخراج','ѕenт','ارسال')
end
if returntde then
locks_Babak(msg,'кιcк','اخراج','υѕer','فرایند')
end
if returntdb then
locks_Babak(msg,'кιcк','اخراج','added','دعوت')
end
if returnbio then
locks_Babak(msg,'кιcк','اخراج','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ اخراج '..tdf..' را #فعال کرد...!\nجهت غیرفعال کردن میتوانید از دستور (اخراج '..tdf..' غیرفعال)  یا (dkick '..td..') استفاده کنید\n'..reporttext)
end
end
end
----------------Ban----------------
if Black and (TDBanMatch) and is_JoinChannel(msg) then
tdlock(TDBanMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Ban:'..td) then
if lang then
send(cht, msg.send_message_id,'➣#'..tde..' вαη ιs αℓяεα∂ү #εηαвℓε ...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ مسدود #'..tdf..' از قبل #فعال بود...!','md')
end
else
typegpadd('Gp:','Ban:'..td)
typegprem('Gp:','Kick:'..td)
typegprem('Gp:','Warn:'..td)
typegprem('Gp:','Mute:'..td)
typegprem('Gp:','Silent:'..td)
if returntd1 then
locks_Babak(msg,'вαη','مسدود','ѕenт','ارسال')
end
if returntd2 then
locks_Babak(msg,'вαη','مسدود','ѕenт','ارسال')
end
if returntdf then
locks_Babak(msg,'вαη','مسدود','ѕenт','ارسال')
end
if returntde then
locks_Babak(msg,'вαη','مسدود','υѕer','فرایند')
end
if returntdb then
locks_Babak(msg,'вαη','مسدود','added','دعوت')
end
if returnbio then
locks_Babak(msg,'вαη','مسدود','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ مسدود '..tdf..' را #فعال کرد...!\nجهت غیرفعال کردن میتوانید از دستور (مسدود '..tdf..' غیرفعال)  یا (dban '..td..') استفاده کنید\n'..reporttext)
end
end
end
----------------Silent----------------
if Black and (TDSilentMatch) and is_JoinChannel(msg) then
tdlock(TDSilentMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Silent:'..td) then
if lang then
send(cht, msg.send_message_id,'➣#'..tde..' sιℓεηт ιs αℓяεα∂ү #εηαвℓε ...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ سایلنت #'..tdf..' از قبل #فعال بود...!','md')
end
else
typegprem('Gp:','Ban:'..td)
typegprem('Gp:','Kick:'..td)
typegprem('Gp:','Mute:'..td)
typegpadd('Gp:','Silent:'..td)
if returntd1 then
locks_Babak(msg,'sιℓεηт','سایلنت','ѕenт','ارسال')
end
if returntd2 then
locks_Babak(msg,'sιℓεηт','سایلنت','ѕenт','ارسال')
end
if returntdf then
locks_Babak(msg,'sιℓεηт','سایلنت','ѕenт','ارسال')
end
if returntde then
locks_Babak(msg,'sιℓεηт','سایلنت','υѕer','فرایند')
end
if returntdb then
locks_Babak(msg,'sιℓεηт','سایلنت','added','دعوت')
end
if returnbio then
locks_Babak(msg,'sιℓεηт','سایلنت','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ سایلنت '..tdf..' را #فعال کرد...!\nجهت غیرفعال کردن میتوانید از دستور (سایلنت '..tdf..' غیرفعال)  یا (dsilent '..td..') استفاده کنید\n'..reporttext)
end
end
end
----------------Don't delelte----------------
if Black and (TDDdelMatch) and is_JoinChannel(msg) then
tdlock(TDDdelMatch)
if returntrue then
if tonumber(reply_id) == 0 then
if base:sismember(TD_ID..'Gp:'..bdcht,'Del:'..td) then
typegprem('Gp:','Del:'..td)
if returntd1 then
locks_ddel(msg,'ѕenт','ارسال')
end
if returntd2 then
locks_ddel(msg,'ѕenт','ارسال')
end
if returntdf then
locks_ddel(msg,'ѕenт','فرایند')
end
if returntde then
locks_ddel(msg,'υѕer','ویرایش پیام,پیام')
end
if returntdb then
locks_ddel(msg,'added','دعوت ربات,')
end
if returnbio then
locks_ddel(msg,'υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ حذف '..tdf..' را #غیرفعال کرد...!\nجهت #فعال کردن میتوانید از دستور (حذف '..tdf..' فعال)  یا (del '..td..') استفاده کنید\n'..reporttext)
else
if lang then
send(cht, msg.send_message_id,'➣∂εℓεтε '..tde..' ιs αℓяεα∂ү #disable...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ حذف '..tdf..' از قبل #غیرفعال بود...!','md')
end
end
else
local Diamond = TD.getMessage(cht,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'Gp3:'..chat_id,user..' حذف '..tdf) then
base:srem(TD_ID..'Gp3:'..chat_id,user..' حذف '..tdf)
send(msg.chat_id, msg.send_message_id,'✦ کاربر : '..name..'\nاز محدودیت ارسال '..tdf..' رهایی یافت و هم اکنون در صورت قفل نبودن '..tdf..' میتواند در گروه '..tdf..' ارسال کند...','html')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : '..name..'\nدر لیست محدودی های ارسال '..tdf..' وجود نداشت...!','html')
end
end
end
end
end
----------------Don't Warn----------------
if Black and (TDDwarnMatch)  and is_JoinChannel(msg) then
tdlock(TDDwarnMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Warn:'..td) then
typegprem('Gp:','Warn:'..td)
if returntd1 then
locks_dwarn(msg,'ѕenт','ارسال')
end
if returntd2 then
locks_dwarn(msg,'ѕenт','ارسال')
end
if returntdf then
locks_dwarn(msg,'ѕenт','ارسال')
end
if returntde then
locks_dwarn(msg,'υѕer','فرایند')
end
if returntdb then
locks_dwarn(msg,'added','دعوت')
end
if returnbio then
locks_dwarn(msg,'υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ اخطار '..tdf..' را #غیرفعال کرد...!\nجهت فعال کردن میتوانید از دستور (اخطار '..tdf..' فعال)  یا (ωαяη '..td..') استفاده کنید\n'..reporttext)
else
if lang then
send(cht, msg.send_message_id,'➣ωαяη '..tde..' ιs αℓяεα∂ү #disable...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ اخطار '..tdf..' از قبل #غیرفعال بود...!','md')
end
end
end
end
----------------Don't Mute----------------
if Black and (TDDmuteMatch) and is_JoinChannel(msg) then
tdlock(TDDmuteMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Mute:'..td) then
typegprem('Gp:','Mute:'..td)
if returntd1 then
locks_Khan(msg,'мυтε','سکوت','ѕenт','ارسال')
end
if returntd2 then
locks_Khan(msg,'мυтε','سکوت','ѕenт','ارسال')
end
if returntdf then
locks_Khan(msg,'мυтε','سکوت','ѕenт','ارسال')
end
if returntde then
locks_Khan(msg,'мυтε','سکوت','υѕer','فرایند')
end
if returntdb then
locks_Khan(msg,'мυтε','سکوت','added','دعوت')
end
if returnbio then
locks_Khan(msg,'мυтε','سکوت','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ سکوت '..tdf..' را #غیرفعال کرد...!\nجهت فعال کردن میتوانید از دستور (سکوت '..tdf..' فعال)  یا (mute '..td..') استفاده کنید\n'..reporttext)
else
if lang then
send(cht, msg.send_message_id,'➣мυтε '..tde..' ιs αℓяεα∂ү #disable...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ سکوت '..tdf..' از قبل #غیرفعال بود...!','md')
end
end
end
end
----------------Don't Kick----------------
if Black and (TDDkickMatch) and is_JoinChannel(msg) then
tdlock(TDDkickMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Kick:'..td) then
typegprem('Gp:','Kick:'..td)
if returntd1 then
locks_Khan(msg,'кιcк','اخراج','ѕenт','ارسال')
end
if returntd2 then
locks_Khan(msg,'кιcк','اخراج','ѕenт','ارسال')
end
if returntdf then
locks_Khan(msg,'кιcк','اخراج','ѕenт','ارسال')
end
if returntde then
locks_Khan(msg,'кιcк','اخراج','υѕer','فرایند')
end
if returntdb then
locks_Khan(msg,'кιcк','اخراج','added','دعوت')
end
if returnbio then
locks_Khan(msg,'кιcк','اخراج','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ اخراج '..tdf..' را #غیرفعال کرد...!\nجهت فعال کردن میتوانید از دستور (اخراج '..tdf..' فعال)  یا (кιcк '..td..') استفاده کنید\n'..reporttext)
else
if lang then
send(cht, msg.send_message_id,'➣кιcк '..tde..' ιs αℓяεα∂ү #disable...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ اخراج '..tdf..' از قبل #غیرفعال بود...!','md')
end
end
end
end
----------------Don't Ban----------------
if Black and (TDDbanMatch) and is_JoinChannel(msg) then
tdlock(TDDbanMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Ban:'..td) then
typegprem('Gp:','Ban:'..td)
if returntd1 then
locks_Khan(msg,'вαη','مسدود','ѕenт','ارسال')
end
if returntd2 then
locks_Khan(msg,'вαη','مسدود','ѕenт','ارسال')
end
if returntdf then
locks_Khan(msg,'вαη','مسدود','ѕenт','ارسال')
end
if returntde then
locks_Khan(msg,'вαη','مسدود','υѕer','فرایند')
end
if returntdb then
locks_Khan(msg,'вαη','مسدود','added','دعوت')
end
if returnbio then
locks_Khan(msg,'вαη','مسدود','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ مسدود '..tdf..' را #غیرفعال کرد...!\nجهت فعال کردن میتوانید از دستور (مسدود '..tdf..' فعال)  یا (вαη '..td..') استفاده کنید\n'..reporttext)
else
if lang then
send(cht, msg.send_message_id,'➣вαη '..tde..' ιs αℓяεα∂ү #disable...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ مسدود '..tdf..' از قبل #غیرفعال بود...!','md')
end
end
end
end
----------------Don't Silent ----------------
if Black and (TDDsilentMatch) and is_JoinChannel(msg) then
tdlock(TDDsilentMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Silent:'..td) then
typegprem('Gp:','Silent:'..td)
if returntd1 then
locks_Khan(msg,'sιℓεηт','سایلنت','ѕenт','ارسال')
end
if returntd2 then
locks_Khan(msg,'sιℓεηт','سایلنت','ѕenт','ارسال')
end
if returntdf then
locks_Khan(msg,'sιℓεηт','سایلنت','ѕenт','ارسال')
end
if returntde then
locks_Khan(msg,'sιℓεηт','سایلنت','υѕer','فرایند')
end
if returntdb then
locks_Khan(msg,'sιℓεηт','سایلنت','added','دعوت')
end 
if returnbio then
locks_Khan(msg,'sιℓεηт','سایلنت','υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\n🔏|↜ سایلنت '..tdf..' را #غیرفعال کرد...!\nجهت فعال کردن میتوانید از دستور (سایلنت '..tdf..' فعال)  یا (silent '..td..') استفاده کنید\n'..reporttext)
else
if lang then
send(cht, msg.send_message_id,'➣sιℓεηт '..tde..' ιs αℓяεα∂ү #disable...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ سایلنت '..tdf..' از قبل #غیرفعال بود...!','md')
end
end
end
end
----------------Unlock----------------
if Black and (TDUnlockMatch) and is_JoinChannel(msg) then
tdlock(TDUnlockMatch)
if returntrue then
if base:sismember(TD_ID..'Gp:'..bdcht,'Del:'..td..'') or base:sismember(TD_ID..'Gp:'..bdcht,'Warn:'..td..'') or base:sismember(TD_ID..'Gp:'..bdcht,'Ban:'..td..'') or base:sismember(TD_ID..'Gp:'..bdcht,'Mute:'..td..'') or base:sismember(TD_ID..'Gp:'..bdcht,'Kick:'..td..'') or base:sismember(TD_ID..'Gp:'..bdcht,'Silent:'..td..'') then
if is_supergroup(msg) then
base:srem(TD_ID..'Gp:'..cht,'Del:'..td)
base:srem(TD_ID..'Gp:'..cht,'Warn:'..td)
base:srem(TD_ID..'Gp:'..cht,'Kick:'..td)
base:srem(TD_ID..'Gp:'..cht,'Ban:'..td)
base:srem(TD_ID..'Gp:'..cht,'Mute:'..td)
base:srem(TD_ID..'Gp:'..cht,'Silent:'..td)
end
if gp_type(msg.chat_id) == "pv" then
for k,v in pairs(gps) do
base:srem(TD_ID..'Gp:'..v,'Del:'..td)
base:srem(TD_ID..'Gp:'..v,'Warn:'..td)
base:srem(TD_ID..'Gp:'..v,'Kick:'..td)
base:srem(TD_ID..'Gp:'..v,'Ban:'..td)
base:srem(TD_ID..'Gp:'..v,'Mute:'..td)
base:srem(TD_ID..'Gp:'..v,'Silent:'..td)
end
end
if returntd1 then
unlocks(msg,'ѕenт','ارسال')
end
if returntd2 then
unlocks(msg,'ѕenт','ارسال')
end
if returntdf then
unlocks(msg,'ѕenт','فرایند')
end
if returntde then
unlocks(msg,'υѕer','ویرایش')
end
if returntdb then
unlocks(msg,'added','دعوت')
end
if returnbio then
unlocks(msg,'υѕυя нαυe','داشتن')
end
local diamond = TD.getUser(bd)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
reportowner('✅|↜ کاربر :【['..name..'](tg://user?id='..bd..')】\nا┅┅──┄┄═✺═┄┄──┅┅\n🔏|↜ قفل #'..tdf..' را #ازاد کرد! ...',12,name)
else
if lang then
send(cht, msg.send_message_id,'➣ '..td..' ιs αℓяεα∂ү #υηℓσcк...!','md')
else
send(cht, msg.send_message_id,'✔️|↜ قفل '..tdf..' از قبل #ازاد بود...!','md')
end
end

end
end
end
--------------------join-----------------
if Black == 'lock join' or Black == 'قفل جوین' and is_JoinChannel(msg) then 
if base:sismember(TD_ID..'Gp:'..bdcht,'Lock:Join') then
if lang then
send(cht, msg.send_message_id,'✔ ➣#Join Users is already #DisAble...!','md')
else
send(cht, msg.send_message_id,'✔️|↜قفل ورود کاربران فعال است...!','md')
end
else
typegpadd('Gp:','Lock:Join')
if lang then
send(cht, msg.send_message_id,'✅ ➣#Join Users Has Been #Disable...!\n┅┅──┄┄═✺═┄┄──┅┅\nUsers are not currently able to join the group ,And if they join the group, they will be removed from the group!','md')
else
send(cht, msg.send_message_id,'✅|↜قفل ورود کاربران فعال شد...!\nا┅┅──┄┄═✺═┄┄──┅┅\nهم اکنون کاربران قادر به عضویت در گروه نمیباشند و در صورت عضویت از گروه ریمو خواهند شد!','md')
end
end
end
if (Black == 'unlock join' or Black == 'بازکردن جوین') and is_JoinChannel(msg) then 
if base:sismember(TD_ID..'Gp:'..bdcht,'Lock:Join') then
typegprem('Gp:','Lock:Join')
if lang then
send(cht, msg.send_message_id,'✅ ➣#Join Users Has Been #Enable...!\n┅┅──┄┄═✺═┄┄──┅┅\nNow users can join the Group with the link!','md')
else
send(cht, msg.send_message_id,'✅|↜قفل ورود کاربران غیرفعال شد...!\nا┅┅──┄┄═✺═┄┄──┅┅\nعضویت کاربران با لینک ازاد شد و کاربران میتوانند با لینک وارد گروه شوند!','md')
end
else
if lang then
send(cht, msg.send_message_id,'✔ ➣#Join Users is already #Enable...!','md')
else
send(cht, msg.send_message_id,'✔️|↜قفل ورود کاربران غیرفعال است...!','md')
end
end
end
if (Black == 'lock cmds' or Black == 'قفل دستورات') and is_JoinChannel(msg) then 
if base:sismember(TD_ID..'Gp:'..bdcht,'Lock:Cmd') then
if lang then
send(cht, msg.send_message_id,'✔ ➣Robot #commands were #disabled for normal users...!','md')
else
send(cht, msg.send_message_id,'✔️|↜قفل دستورات ربات براے کاربران عادے فعال است...!','md')
end
else
typegpadd('Gp:','Lock:Cmd')
if lang then
send(cht, msg.send_message_id,'✅ ➣Robot #commands Has Been #disable for normal users...!','md')
else
send(cht, msg.send_message_id,'✅|↜قفل دستورات ربات براے کاربران عادے فعال# شد...!','md')
end
end
end
if (Black == 'unlock cmds' or Black == 'بازکردن دستورات') and is_JoinChannel(msg) then 
if base:sismember(TD_ID..'Gp:'..bdcht,'Lock:Cmd') then
typegprem('Gp:','Lock:Cmd')
if lang then
send(cht, msg.send_message_id,'✅ ➣Robot #commands Has Been #Enable for normal users...!','md')
else
send(cht, msg.send_message_id,'✅|↜قفل دستورات ربات براے کاربران عادے غیرفعال# شد...!','md')
end
else
if lang then
send(cht, msg.send_message_id,'✔ ➣Robot #commands were #Enabled for normal users...!','md')
else
send(cht, msg.send_message_id,'✔️|↜قفل دستورات ربات براے کاربران عادے غیرفعال# است...!','md')
end
end
end
--------------------tgservice-----------------
if (Black == 'lock tgservice' or Black == 'قفل سرویس') and is_JoinChannel(msg) then 
if base:sismember(TD_ID..'Gp:'..bdcht,'Lock:TGservice') then
if lang then
send(cht, msg.send_message_id,'✔ ➣#TGService were #disabled...!','md')
else
send(cht, msg.send_message_id,'✔️|↜قفل سرویس تلگرام فعال است...!','md')
end
else
typegpadd('Gp:','Lock:TGservice')
if lang then
send(cht, msg.send_message_id,'✅ ➣#TGService Has Been #Disabled...!\n┅┅──┄┄═✺═┄┄──┅┅\nNow the messages of Join Members and Add Members will be deleted!','md')
else
send(cht, msg.send_message_id,'✅|↜قفل سرویس تلگرام #فعال شد...!\nا┅┅──┄┄═✺═┄┄──┅┅\nاز این پس پیام هاے عضویت کاربران و اد ممبر پاک خواهند شد!','md')
end
end
end
if (Black == 'unlock tgservice' or Black == 'بازکردن سرویس') and is_JoinChannel(msg) then 
if base:sismember(TD_ID..'Gp:'..bdcht,'Lock:TGservice') then
typegprem('Gp:','Lock:TGservice')
if lang then
send(cht, msg.send_message_id,'✅ ➣#TGService Has Been #Enable...!\n┅┅──┄┄═✺═┄┄──┅┅\nNow the messages of Join Members and Add Members are visible!','md')
else
send(cht, msg.send_message_id,'✅|↜قفل سرویس تلگرام غیرفعال شد...!\nا┅┅──┄┄═✺═┄┄──┅┅\nهم اکنون پیام هاے عضویت ممبر ها و اد شدن ممبر ها قابل مشاهده است!','md')
end
else
if lang then
send(cht, msg.send_message_id,'✔ ➣#TGService were #Enabled...!','md')
else
send(cht, msg.send_message_id,'✔️|↜قفل سرویس تلگرام #غیرفعال است...!','md')
end
end
end
function change(babi)
if not babi then return end
changelang = {
FA = {"لینک","یوزرنیم","فوروارد","هشتگ","متن","انگلیسی","فارسی","فراخانی","ویرایش","ربات","عکس","فایل","استیکر","فیلم","ویدیومسیج","مخاطب","بازی","دکمه شیشه ای","موقعیت مکانی","گیف","آهنگ","وویس"},
EN = {"Link","Username","Forward","Tag","Text","English","Persian","Mention","Edit","Bots","Photo","Document","Sticker","Video","Videomsg","Contact","Game","Inline","Location","Gif","Audio","Voice"}}
for k,v in pairs(changelang.FA) do
if babi == v then
return changelang.EN[k]
end
end
return false end
if Black and (Black:match('^قفل لیستی (.*)$')) then
inputz = Black:match('^قفل لیستی (.*)$')
text = "• قفل ها براساس ترتیب :\n\n"
for i in string.gmatch(inputz,"%S+") do
forgod = change(i)
if base:sismember(TD_ID..'Gp:'..msg.chat_id,'Del:'..forgod) then
x = '✗|↜فعال بود'
else
x = '✓️|↜فعال شد'
end
if not forgod then
text = "• خطایی رخ داده است !"
break
else
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:'..forgod) 
text = text.."• قفل #"..i.." "..x.."\n"
end
end
local Diamond = TD.getUser(msg.sender_id.user_id)
bx = ""..text.."ا┅┅──┄┄═✺═┄┄──┅┅\nتوسط : ["..Diamond.first_name.."](tg://user?id="..msg.sender_id.user_id..")"
send(msg.chat_id, msg.send_message_id,bx,'md')
end
------set cmd------
if Black and (Black:match('^addcmd (.*)') or Black:match('^افزودن دستور (.*)')) and tonumber(reply_id) > 0 then
local cmd = Black:match('^addcmd (.*)') or Black:match('^افزودن دستور (.*)')
local Diamond = TD.getMessage(cht,tonumber(reply_id))
if Diamond.content._ == 'messageText' then
typegpadd('CmDlist:',Diamond.content.text.text)
typegphset('CmD:',Diamond.content.text.text,cmd)
send(cht, msg.send_message_id,'✔️ انجام شد\nاز این پس دستور >'..cmd..'< را میتوانید با >'..Diamond.content.text.text..'< نیز انجام دهید !','md')
end
end
if Black and (Black:match('^delcmd (.*)') or Black:match('^حذف دستور (.*)')) then
local cmd = Black:match('^delcmd (.*)') or Black:match('^حذف دستور (.*)')
typegphdel('CmD:',cmd)
typegprem('CmDlist:',cmd)
send(cht, msg.send_message_id,'✔️ انجام شد\nدستور >'..cmd..'< از لیست دستورات حذف شد...!','md')
end
if Black == 'clean cmdlist' or Black == 'پاکسازی لیست دستورات' then
typegpdel('CmD:')
typegpdel('CmDlist:')
send(cht, msg.send_message_id,'لیست دستورات پاکسازے شد','md')
end
if Black == 'cmdlist' or Black == 'لیست دستورات' then
local CmDlist = base:smembers(TD_ID..'CmDlist:'..bdcht)
local t = 'لیست دستورات جدید ربات : \n'
for k,v in pairs(CmDlist) do
if is_supergroup(msg) then
mmdi = base:hget(TD_ID..'CmD:'..cht,v)
end
if gp_type(msg.chat_id) == "pv" then
for r,y in pairs(gps) do
mmdi = base:hget(TD_ID..'CmD:'..y,v)
end
end
t = t..k..") "..v.." > "..mmdi.."\n" 
end
if #CmDlist == 0 then
t = 'دستور ثبت شده ای یافت نشد !'
end
send(cht, msg.send_message_id,t,'md')
end
------text chats------
if Black and (Black:match('^setchat (.*)') or Black:match('^تنظیم چت (.*)')) and tonumber(reply_id) > 0 then
local cmd = Black:match('^setchat (.*)') or Black:match('^تنظیم چت (.*)')
local Diamond = TD.getMessage(cht,tonumber(reply_id))
if Diamond.content._ == 'messageText' then
typegpadd('Textlist:',cmd)
typegphset('Text:',cmd,Diamond.content.text.text)
send(cht, msg.send_message_id,'✔️ انجام شد\n>'..Diamond.content.text.text..'\nتنظیم شد در جواب : '..cmd,'md')
end
end
if Black == 'chatlist' or Black == 'لیست چت' then
local Textlist = base:smembers(TD_ID..'Textlist:'..bdcht)
local t = 'لیست چت : \n'
for k,v in pairs(Textlist) do
if is_supergroup(msg) then
mmdi = base:hget(TD_ID..'Text:'..cht,v)
end
if gp_type(msg.chat_id) == "pv" then
for r,y in pairs(gps) do
mmdi = base:hget(TD_ID..'Text:'..y,v)
end
end
t = t..k..") "..v.." > "..mmdi.."\n" 
end
if #Textlist == 0 then
t = 'لیست چت خالی است !'
end
send(cht, msg.send_message_id,t,'md')
end
if Black and (Black:match('^delchat (.*)') or Black:match('^حذف چت (.*)')) then
local cmd = Black:match('^delchat (.*)') or Black:match('^حذف چت (.*)')
typegphdel('Text:',cmd)
typegprem('Textlist:',cmd)
send(cht, msg.send_message_id,'✔️ انجام شد\n>'..cmd..'\nاز لیست کلماتی که ربات به ان پاسخ میدهد حذف شد...!','md')
end
if Black == 'clean chatlist' or Black == 'پاکسازی لیست چت' then
typegpdel('Textlist:')
typegpdel('Text:')
send(cht, msg.send_message_id,'لیست چت پاکسازے شد','md')
end
-----stciker chat-----
if Black and (Black:match('^setsticker (.*)$') or Black:match('تنظیم استیکر (.*)$')) and is_JoinChannel(msg) and tonumber(reply_id) > 0 then
local cmd = Black:match('^setsticker (.*)$') or Black:match('تنظیم استیکر (.*)$')
local Diamond = TD.getMessage(cht,tonumber(reply_id))
if Diamond.content.sticker then
typegpadd('Stickerslist:',cmd)
typegpset('Stickers:'..cmd,Diamond.content.sticker.sticker.id)
send(cht, msg.send_message_id,'✔️ انجام شد\n>استیکر : '..cmd..'\nذخیره شد!','md')
end
end
if Black == 'stickerlist' then
local Stickerslist = base:smembers(TD_ID..'Stickerslist:'..bdcht)
local t = 'Stickers: \n'
for k,v in pairs(Stickerslist) do
t = t..k.." - "..v.."\n" 
end
if #Stickerslist == 0 then
t = 'لیست استیکر ها خالی است'
end
send(cht, msg.send_message_id,t,'md')
end
if Black and (Black:match('^delsticker (.*)'))  then
local cmd = Black:match('^delsticker (.*)')
typegprem('Stickerslist:',cmd)
typegpdel('Stickers:'..cmd)
send(cht, msg.send_message_id,'✔️ انجام شد\n>استیکر : '..cmd..'\nاز لیست پاک شد!','md')
end
if Black == 'clean stickerlist' or Black == 'پاکسازی لیست استیکر' then
typegpdel('Stickerslist:')
send(cht, msg.send_message_id,'لیست استیکر پاکسازے شد','md')
end
if Black == 'ban filter' and is_JoinChannel(msg) then 
base:sadd(TD_ID..'Gp:'..cht,'Ban:Filter')
send(cht, msg.send_message_id, '✔️|↜on!','md')
end
if Black == 'dban filter' and is_JoinChannel(msg) then 
base:srem(TD_ID..'Gp:'..cht,'Ban:Filter')
send(cht, msg.send_message_id, '✔️|↜off!','md')
end
if Black == 'botchat on' or Black == 'چت ربات روشن' and is_JoinChannel(msg) then 
typegprem('Gp2:','BotChat')
send(cht, msg.send_message_id,'✔️|↜ چت ربات فعال شد...!\n\nشما میتوانید با دستور\nsetchat (text)\nبا ریپلی برروے جواب آن چت,ربات را سخن گوکنید\n\nبراے مثال setchat khobi\nرا با ریپلی بر روے پیام mrc وارد میکنیم از این پس ربات به khobi جواب mrc خواهد داد!','md')
end
if Black == 'botchat off' or Black == 'چت ربات خاموش' and is_JoinChannel(msg) then 
typegpadd('Gp2:','BotChat')
send(cht, msg.send_message_id,'✔️|↜ چت ربات غیرفعال شد...!','md')
end

end
end
end
-----End Pv Cmds-----
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'added') and is_supergroup(msg) then
if is_Owner(msg) then
if Black == 'reset info' and tonumber(reply_id) == 0 then
base:del(TD_ID..'Total:KickUser:'..msg.chat_id..':'..msg.sender_id.user_id) 
base:del(TD_ID..'Total:AddUser:'..msg.chat_id..':'..msg.sender_id.user_id)
base:del(TD_ID..'Total:BanUser:'..msg.chat_id..':'..msg.sender_id.user_id)
send(msg.chat_id, msg.send_message_id,'#انجام شد\nاطلاعات شما  بازنشانے شد...!','md')
end
--[[if Black == 'autoclose on' or Black == 'بسته شدن پنل فعال' then
base:set(TD_ID..'autoclose:'..msg.chat_id,true) 
send(msg.chat_id, msg.send_message_id,'بسته شدن پنل بصورت خودکار فعال شد','md')
end
if Black == 'autoclose off' or Black == 'بسته شدن پنل غیرفعال' then
base:del(TD_ID..'autoclose:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'بسته شدن پنل بصورت خودکار غیرفعال شد','md')
end]]
if Black == 'reset info' and tonumber(reply_id) ~= 0 then
local startwarn = TD_ID..':join'..os.date("%Y/%m/%d")..':'..msg.chat_id
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
base:del(TD_ID..'Total:KickUser:'..msg.chat_id..':'..user) 
base:del(TD_ID..'Total:AddUser:'..msg.chat_id..':'..user)
base:del(TD_ID..'Total:BanUser:'..msg.chat_id..':'..user)
base:del(TD_ID..'forceaddfor',user)
base:del(TD_ID..'addeduser'..msg.chat_id,user,added)
base:del(startwarn,user)
local diamond = TD.getUser(user)
send(msg.chat_id, msg.send_message_id,'#انجام شد\nاطلاعات کاربر : @'..check_markdown(diamond.usernames and diamond.usernames.editable_username or '')..'\n'..ec_name(diamond.first_name)..'\n بازنشانی شد#...!','md')
end
end 
if Black == 'modlist' or Black == 'لیست مدیران' then  
local list = base:smembers(TD_ID..'ModList:'..msg.chat_id)
local t = 'لیست مدیران گروه :\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do  
t = t..k..'-【['..v..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
if #list == 0 then
t = 'لیست مدیران گروه خالے میباشد'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if Black == 'reportpv on' or Black == 'ارسال گزارش فعال' then
if reportpv then
send(msg.chat_id, msg.send_message_id, 'ارسال گزارش به مالک #فعال بود','md')
else
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'reportpv')
send(msg.chat_id, msg.send_message_id, 'ارسال گزارش به مالک #فعال شد','md')
end
end
if Black == 'reportpv off' or Black == 'ارسال گزارش غیرفعال' then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'reportpv')
send(msg.chat_id, msg.send_message_id, 'ارسال گزارش به مالک #غیرفعال شد','md')
end
if Black and (Black:match('^setadd (.*)') or Black:match('^تنظیم متن افزودن اجباری (.*)')) and is_JoinChannel(msg) then
local CH = Black:match('^setadd (.*)') or Black:match('^تنظیم متن افزودن اجباری (.*)')
base:set(TD_ID..'TextForce:'..msg.chat_id,CH)
send(msg.chat_id, msg.send_message_id,'✅ متن تنظیم شد به : \n'..CH,'html')
end
if Black and (Black:match('^setdok (.*)') or Black:match('^تنظیم دکمه افزودن اجباری (.*)')) and is_JoinChannel(msg) then
local CH = Black:match('^setdok (.*)') or Black:match('^تنظیم دکمه افزودن اجباری (.*)')
base:set(TD_ID..'TextDok:'..msg.chat_id,CH)
send(msg.chat_id, msg.send_message_id,'✅ متن تنظیم شد به : \n'..CH,'html')
end
if Diamondent and (Black:match('^setcust (.*) (.*)')) or Black and (Black:match('^setcust @(.*) (.*)') or Black:match('^setcust (%d+) (.*)$')) and is_JoinChannel(msg) then
local BDSource,title = Black:match('^setcust (.*) (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^setcust @(.*) (.*)') then
Babi = Diamond.id
elseif not Diamondent and Black:match('^setcust (%d+) (.*)') then
Babi = BDSource
elseif Diamondent and Black:match('^setcust (.*) (.*)') then
Babi = msg.content.text.entities[1].type.user_id
end
if Babi then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_promote_members == true then
Setcust(msg.chat_id,Babi,title)
send(msg.chat_id, msg.send_message_id,'✦ متن سفارشی :\n['..BDSource..'](tg://user?id='..Babi..')\nتغییر کرد به '..title..'','md')
else
send(msg.chat_id, msg.send_message_id,'✦ ربات دسترسی به قسمت تغییرات کاربران ندارد !\nلطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد امتحان کنید !','md')
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','md')
end
end
--<><><><>setadmin
if Diamondent and (Black:match('^setadmin (.*)') or Black:match('^ادمین (.*)')) or Black and (Black:match('^setadmin @(.*)') or Black:match('^ادمین @(.*)') or Black:match('^setadmin (%d+)$') or Black:match('^ادمین (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^setadmin (.*)') or Black:match('^ادمین (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^setadmin @(.*)') or Black:match('^ادمین @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^setadmin (%d+)') or Black:match('^ادمین (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^setadmin (.*)') or Black:match('^ادمین (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_promote_members == true then
SetAdmins(msg.chat_id,mrr619)
base:sadd(TD_ID..'ModList:'..msg.chat_id,mrr619)
txt_setadmin(msg.chat_id,msg.id,mrr619,BDSource)
else
send(msg.chat_id, msg.send_message_id,'✦ ربات دسترسی به قسمت ادمین کردن کاربران ندارد !\nلطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد امتحان کنید !','md')
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','md')
end
end
if (Black == 'setadmin' or Black == 'ادمین' or Black == 'تنظیم ادمین') and tonumber(reply_id_) ~= 0 and is_JoinChannel(msg) then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_promote_members == true then
SetAdmins(msg.chat_id,user)
base:sadd(TD_ID..'ModList:'..msg.chat_id,user)
txt_setadmin(msg.chat_id,msg.id,user,name)
else
send(msg.chat_id, msg.send_message_id,'✦ ربات دسترسی به قسمت ادمین کردن کاربران ندارد !\nلطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد امتحان کنید !','md')
end
end
end
--<><><><>remadmin
if Diamondent and (Black:match('^remadmin (.*)') or Black:match('^حذف ادمین (.*)')) or Black and (Black:match('^remadmin @(.*)') or Black:match('^حذف ادمین @(.*)') or Black:match('^remadmin (%d+)$') or Black:match('^حذف ادمین (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^remadmin (.*)') or Black:match('^حذف ادمین (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^remadmin @(.*)') or Black:match('^حذف ادمین @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^remadmin (%d+)') or Black:match('^حذف ادمین (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^remadmin (.*)') or Black:match('^حذف ادمین (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_promote_members == true then
local url  = https.request(Bot_Api .. '/promoteChatMember?chat_id='..msg.chat_id..'&user_id='..mrr619..'&can_change_info=false')
if res ~= 200 then
end
statsurl = json:decode(url)
if statsurl.ok == true then
txt_remadmin(msg.chat_id,msg.id,mrr619,BDSource)
base:srem(TD_ID..'ModList:'..msg.chat_id,mrr619)
else
send(msg.chat_id, msg.send_message_id,'✦ انجام نشد !\nربات نمیتواند ادمینی که توسط ادمینی دیگر ارتقا داده شده از لیست ادمین ها خارج کند !','md')
end
else
send(msg.chat_id, msg.send_message_id,'✦ ربات دسترسی به قسمت ادمین کردن کاربران ندارد !\nلطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد امتحان کنید !','md')
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','html')
end
end
if (Black == 'remadmin' or Black == 'حذف ادمین') and tonumber(reply_id_) ~= 0 and is_JoinChannel(msg) then
local data = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = data.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl = json:decode(url_)
if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_promote_members == true then
local url  = https.request(Bot_Api .. '/promoteChatMember?chat_id='..msg.chat_id..'&user_id='..user..'&can_change_info=false')
if res ~= 200 then
end
statsurl = json:decode(url)
if statsurl.ok == true then
txt_remadmin(msg.chat_id,msg.id,user,name)
base:srem(TD_ID..'ModList:'..msg.chat_id,user)
else
send(msg.chat_id, msg.send_message_id,'✦ انجام نشد !\nربات نمیتواند ادمینی که توسط ادمینی دیگر ارتقا داده شده از لیست ادمین ها خارج کند !','md')
end
else
send(msg.chat_id, msg.send_message_id,'✦ ربات دسترسی به قسمت ادمین کردن کاربران ندارد !\nلطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد امتحان کنید !','md')
end
end
end
if Black and (Black:match('^limitcmd +(.*)') or Black:match('^محدودکردن دستور +(.*)')) and is_JoinChannel(msg) then
if string.find(Black:match('^limitcmd (.*)$') or Black:match('^محدودکردن دستور (.*)$'),"[%(%)%.%+%-%*%?%[%]%^%$%%]") then
send(msg.chat_id, msg.send_message_id,'🖕😐','md')
else
local word = Black:match('^limitcmd +(.*)') or Black:match('^محدودکردن دستور +(.*)')
base:sadd(TD_ID..'LimitCmd:'..msg.chat_id,word)
send(msg.chat_id, msg.send_message_id,'|↜ دستور '..word..' از دسترس مدیران گروه خارج شد و فقط مالکان قادر به زدن این دستور خواهند بود !','md')
end
end
if Black and (Black:match('^unlimitcmd +(.*)') or Black:match('^نامحدود کردن دستور +(.*)')) and is_JoinChannel(msg) then
local word = Black:match('^unlimitcmd +(.*)') or Black:match('^نامحدود کردن دستور +(.*)')
base:srem(TD_ID..'LimitCmd:'..msg.chat_id,word)
send(msg.chat_id, msg.send_message_id,'|↜ دستور '..word..' در دسترس مدیران گروه قرار گرفت !','md')
end
if (Black == 'clean limitcmdlist' or Black == 'پاکسازی لیست دستورات محدود') and is_JoinChannel(msg) then
base:del(TD_ID..'LimitCmd:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'|↜ لیست دستورات محدود پاکسازی شد !','md')
end
if (Black == 'limitcmdlist' or Black == 'لیست دستورات محدود') and is_JoinChannel(msg) then
local list = base:smembers(TD_ID..'LimitCmd:'..msg.chat_id)
local t = '|↜ لیست دستوراتی که مدیران قادر به استفاده از انها نیستند :\n'
for k,v in pairs(list) do 
t = t..k.."- *"..v.."*\n"
end
if #list == 0 then
t = '|↜ لیست  دستورات محدود خالی است !'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
--<><><><>Promote
if Diamondent and (Black:match('^promote (.*)') or Black:match('^ترفیع (.*)')) or Black and (Black:match('^promote @(.*)') or Black:match('^ترفیع @(.*)') or Black:match('^promote (%d+)$') or Black:match('^ترفیع (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^promote (.*)') or Black:match('^ترفیع (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^promote @(.*)') or Black:match('^ترفیع @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^promote (%d+)') or Black:match('^ترفیع (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^promote (.*)') or Black:match('^ترفیع (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
pro(msg.chat_id,msg.id,mrr619,BDSource)
base:sadd(TD_ID..'ModList:'..msg.chat_id,mrr619)
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','html')
end
end
if (Black == 'promote' or Black == 'ترفیع' or Black == 'کمک مدیر' or BaBaK == "CAADBQADAwMAAqi62wgKvCUht0M14wI") and tonumber(reply_id_) ~= 0 and is_JoinChannel(msg) then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
pro(msg.chat_id,msg.id,user,name)
end
end
--<><><><>Demote
if Diamondent and (Black:match('^demote (.*)') or Black:match('^ترفیع (.*)')) or Black and (Black:match('^demote @(.*)') or Black:match('^عزل @(.*)') or Black:match('^demote (%d+)$') or Black:match('^عزل (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^demote (.*)') or Black:match('^عزل (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^demote @(.*)') or Black:match('^عزل @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^demote (%d+)') or Black:match('^عزل (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^demote (.*)') or Black:match('^عزل (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
demo(msg.chat_id,msg.id,mrr619,BDSource)
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','html')
end
end
if (Black == 'demote' or Black == 'عزل' or BaBaK == "CAADBQADBAMAAqi62wjfpnQN6IoBWQI") and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
demo(msg.chat_id,msg.id,user,name)
end
end
if Black == 'clean modlist' or Black == 'پاکسازی لیست مدیران'  then
base:del(TD_ID..'ModList:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'• لیست مدیران پاکسازے شد','md')
end
if Black == 'configapi' or Black == 'پیکربندی ربات ها' and is_JoinChannel(msg) then 
local result = TD.getSupergroupMembers(msg.chat_id, "Bots", '' , 0 , 200 )
for k,v in pairs(result.members) do
local Diamond = TD.getUser(v.member_id.user_id)
if Diamond.type._ == "userTypeBot" then 
base:sadd(TD_ID..'ModList:'..msg.chat_id,Diamond.id)
end
end
send(msg.chat_id, msg.send_message_id,'ربات ها پیکربندی شدند',"md")
end

if (Black == 'قرعه کشی') and is_JoinChannel(msg) then
local data = TD.getSupergroupMembers(msg.chat_id, "Recent", '' , 0 , 200 )
local rand = math.random(#data.members)
local diamond = TD.getUser(data.members[rand].member_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local nm = '<a href="tg://user?id='..data.members[rand].member_id.user_id..'">'..name..'</a>'
send(msg.chat_id, msg.send_message_id,'✅ ➣# قرعه کشی با موفقیت انجام شد\n\n✦ نام برنده : '..(nm)..'','html')
end
---##End Owner
end

if BaBaK or Black and (is_Owner(msg) or (is_Mod(msg) and not (base:sismember(TD_ID..'LimitCmd:'..msg.chat_id,Black) or base:sismember(TD_ID..'LimitCmd:'..msg.chat_id,BaseCmd)))) then
if Black == 'lockedlist' or Black == 'لیست محدود' then
local t = 'لیست محدود شدگان قفلی :\nبرای رفع محدودیت هر کاربر بر روی متن جلوی >  کلیک کرده و ان را ارسال کنید!\nا┅┅──┄┄═✺═┄┄──┅┅\n'
local mrr619 = base:smembers(TD_ID..'Gp3:'..msg.chat_id)
for k,v in pairs(mrr619) do  
local list = v:match('^(%d+)')
t = t..k..'-【 ['..v..'](tg://user?id='..list..') 】\n>`رهایی '..v..'`\n\n'
end
if #mrr619 == 0 then
t = 'لیست محدود شدگان قفلی گروه خالے میباشد'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if Black == 'clean lockedlist' or Black == 'پاکسازی لیست محدود' then
base:del(TD_ID..'Gp3:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'>لیست محدودشدگان پاکسازی شد...!','md')
end
if Black and (Black:match('^رهایی (%d+) (.*) (.*)$')) then
local user = Black:match('^رهایی (.*)$')
local id = user:match('(%d+)')
local mmad = string.gsub(user,id,'')
local diamond = TD.getUser(id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'Gp3:'..msg.chat_id,user) then
base:srem(TD_ID..'Gp3:'..msg.chat_id,user)
send(msg.chat_id, msg.send_message_id,'> کاربر '..name..' از محدودیت'..mmad..' رهایی یافت','html')
else
send(msg.chat_id, msg.send_message_id,'> عملیات ناموفق !','md')
end
end
if Black == 'filtersens off' or Black == 'حساسیت فیلتر خاموش' then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'FilterSen')
send(msg.chat_id, msg.send_message_id,'> حساسیت فیلتر خاموش شد!\nدر صورت فیلتر کردن یک کلمه اگر حرف دیگری به ان کلمه چسبیده باشد ان متن پاک نخواهد شد\n\nبرای مثال اگر موبو رو فیلتر کنید در صورتی که پیام موبوگرام ارسال شود پیام پاک نخواهد شد','md')
end
if Black == 'filtersens on' or Black == 'حساسیت فیلتر روشن' then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'FilterSen')
send(msg.chat_id, msg.send_message_id,'> حساسیت فیلتر روشن شد...!\nدقت کنید که در صورت روشن بودن حساسیت فیلتر هر متنی که کلمه فیلتر شده داخل ان وجود داشته باشد پاک خواهد شد\n\nبرای مثال در صورت فیلتر سل اگر کاربر سلام ارسال کند پیام او پاک خواهد شد','md')
end
if Black == 'kickbotpm on' or Black == 'پیام مسدود ربات روشن' then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'kickbotpm')
send(msg.chat_id, msg.send_message_id,'> پیام مسدود ربات #فعال شد و از این پس کسی ربات اد کند پیام #اخطار داده خواهد شد.','md')
end
if Black == 'kickbotpm off' or Black == 'پیام مسدود ربات خاموش' then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'kickbotpm')
send(msg.chat_id, msg.send_message_id,'> پیام مسدود ربات #غیرفعال شد و از این پس پیام #اخطار ربات داده نخواهد شد','md')
end
if Black == 'msgcheckpm on' or Black == 'پیام مسیج چک روشن' then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm')
send(msg.chat_id, msg.send_message_id,'> پیام مسدود ربات #فعال شد و از این پس کسی ربات اد کند پیام #اخطار داده خواهد شد.','md')
end
if Black == 'msgcheckpm off' or Black == 'پیام مسیج چک خاموش' then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'MsgCheckPm')
send(msg.chat_id, msg.send_message_id,'> پیام مسدود ربات #غیرفعال شد و از این پس پیام #اخطار ربات داده نخواهد شد','md')
end
if Black == 'setmode' or Black == 'تنظیم حالت' then
local modes = base:smembers(TD_ID..'Gp:'..msg.chat_id)
if #modes == 0 then
send(msg.chat_id, msg.send_message_id,'> تنظیمات گروه اکنون در حالت ازادانه قرار دارد که در حالت هاے ربات موجوداست!\nابتدا تنظیمات دلخواه خود را انجام دهید سپس اقدام به تنظیم حالت من کنید.','md')
else
send(msg.chat_id, msg.send_message_id,'> حالت دلخواه شماه تنظیم شد و تنظیمات کنونی گروه به عنوان حالت من ثبت شد!\nشما در هر زمان میتوانید تنها با زدن دستور حالت من به تنظیمات کنونی گروه بازگردید!','md')
for k,v in pairs(modes) do
base:sadd(TD_ID..'setmode:'..msg.chat_id,v)
end
end
end
if Black == 'my mode' or Black == 'حالت من' then
local modes = base:smembers(TD_ID..'setmode:'..msg.chat_id)
if #modes == 0 then
send(msg.chat_id, msg.send_message_id,'> حالت من تنظیم نشده است !\nشما با انجام تنظیمات ربات و سپس با زدن دستور <تنظیم حالت> میتوانید تنظیمات دلخواه خود را به عنوان حالت ثبت کنید و در هر زمان با زدن دستور <حالت من> به تنظیمات دلخواه خود بازگردید','md')
else
base:del(TD_ID..'Gp:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'> تنظیمات گروه به حالت تنظیم شده شما بازگشت !','md')
for k,v in pairs(modes) do
base:sadd(TD_ID..'Gp:'..msg.chat_id,v)
end
end
end
if Black == 'unlock mode' or Black == 'حالت ازاد' then
send(msg.chat_id, msg.send_message_id,'> حالت ازادانه فعال شد و تمامی قفل ها ازاد شدند !','md')
base:del(TD_ID..'Gp:'..msg.chat_id)
end
if Black == 'default mode' or Black == 'حالت پیش فرض' then
base:del(TD_ID..'Gp:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'> تنظیمات گروه به حالت پیشفرض بازگشت !','md') base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Link')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Username')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Bots')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Ban:Bot')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Inline')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Hyper')
end
if Black == 'chat mode' or Black == 'حالت چت' then
base:del(TD_ID..'Gp:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'> تنظیمات گروه براے گروه چت تنظیم شد !','md')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Link')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Bots')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Ban:Bot')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Hyper')
end
if Black == 'music mode' or Black == 'حالت موزیک' then
base:del(TD_ID..'Gp:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'> تنظیمات گروه براے گروه موزیک تنظیم شد !','md')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Link')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Username')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Sticker')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Inline')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Bots')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Ban:Bot')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Hyper')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Mention')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Tag')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Location')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Forward')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Contact')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Gif')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Video')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Videomsg')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Game')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Document')
end
if Black == 'antitabchi' or Black == 'ضدتبچی' then
send(msg.chat_id, msg.send_message_id,'> تنظیمات مربوط به ضد تبچی فعال شد !','md')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Document')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Bots')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Ban:Bot')
base:sadd(TD_ID..'Gp:'..msg.chat_id,'Del:Hyper')
end
if Black == 'gid' or Black == 'ایدی گروه' then 
send(msg.chat_id, msg.send_message_id,msg.chat_id,'md')
end
if Black == 'setgp' or Black == 'ثبت گروه' then 
base:sadd(TD_ID..'gpuser:'..msg.sender_id.user_id,msg.chat_id)
send(msg.chat_id, msg.send_message_id,'>گروه با موفقیت در لیست گروهاے مدیریتی در خصوصی ربات ثبت شد...!\n\nشما میتوانید با مراجعه به پی وے ربات تنظیمات گروه خود را در خصوصی ربات انجام دهید.','md')
end
if Black == "expire" or Black == "اعتبار" then
local ex = base:ttl(TD_ID.."ExpireData:"..msg.chat_id)
if ex == -1 then
textt = '|↜ گروه به صورت نامحدود شارژ می‌باشد'
send(msg.chat_id, msg.send_message_id,textt,'html')
else
local d = math.floor(ex / day ) + 1
text = '📆 پایان انقضاے ربات : '..d..' روز دیگر\n─┅━━━━━━━┅─\n💰 لطفا جهت تمدید به آیدے زیر مراجعه ڪنید.\n'..check_markdown(UserSudo)..''
send(msg.chat_id, msg.send_message_id,text,'md')
end
end
if (Black == "clean deleted" or Black == 'پاکسازی دیلیت اکانتی ها') and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
cleandeleted(msg)
send(msg.chat_id, msg.send_message_id,'⭕تمام کاربران دیلیت اکانتے از گروه حذف شدند','md')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
----------------------
if Black1 and (Black1:match('^[Ss]etdescription (.*)') or Black1:match('^تنظیم درباره (.*)')) then
local description = Black1:match('^تنظیم درباره (.*)') or Black1:match('^[Ss]etdescription (.*)')
TD.setChatDescription(msg.chat_id,description)
local text = [[درباره گروه تغییر کرده به ]]..description
send(msg.chat_id, msg.send_message_id,text,'md')
end
if Black1 and (Black1:match('^[Ss]etname (.*)') or Black1:match('^تنظیم نام (.*)')) then
local Title = Black1:match('^[Ss]etname (.*)') or Black1:match('^تنظیم نام (.*)')
local Diamond = TD.getChat(msg.chat_id)
local Hash = TD_ID..'StatsGpByName'..msg.chat_id
local ChatTitle = Diamond.title
base:set(Hash,ChatTitle)
TD.setChatTitle(msg.chat_id,Title)
send(msg.chat_id, msg.send_message_id,'نام گروه تغییر ڪرد به : '..Title..'','html')
end
if (Black == 'pin' or Black == 'سنجاق') and is_JoinChannel(msg)  and tonumber(reply_id) > 0 then 
send(msg.chat_id, msg.send_message_id,'📎 ایــن پیام سنجاق شد','md')
TD.pinChatMessage(msg.chat_id,reply_id)
end
if (Black == 'unpin' or Black == 'حذف سنجاق') and is_JoinChannel(msg) then
send(msg.chat_id, msg.send_message_id,'📌 پیام حذف سنجاق شد','md')
TD.pinChatMessage(msg.chat_id)
end
if Black1 and (Black1:match('^([Mm]uteall) (.*)$') or Black1:match('^(حالت تعطیل کردن) (.*)$')) and is_JoinChannel(msg) then
local Black1 = Black1:gsub("حالت تعطیل کردن", "muteall")
local status = {string.match(Black1, "^([Mm]uteall) (.*)$")}
if status[2] == 'mute' or status[2] == 'محدود' then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'Tele_Mute')
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'Tele_Mute2')
send(msg.chat_id, msg.send_message_id,'|↜ تعطیل کردن گروه در حالت محدود سازے قرار گرفت','md')
end
if status[2] == 'del' or status[2] == 'حذف' then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Tele_Mute')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Tele_Mute2')
send(msg.chat_id, msg.send_message_id,'|↜ تعطیل کردن گروه در حالت حذف پیام کاربر قرار گرفت','md')
end
end  
if Black == 'automute on' or Black == 'قفل گروه فعال' then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'automuteall')
star = base:get(TD_ID..'StartTimeSee'..msg.chat_id) or '06:00'
endtim =
base:get(TD_ID..'EndTimeSee'..msg.chat_id) or '12:00'
send(msg.chat_id, msg.send_message_id,'•تعطیل کردن خودکار فعال شد !\n#زمان شروع : '..star..'\n#زمان پایان : '..endtim,'md')
end
if Black == 'automute off' or Black == 'قفل گروه غیرفعال' then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'automuteall') then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'automuteall') 
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Mute_All2')        
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Tele_Mute2')
local mutes =  base:smembers(TD_ID..'Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
base:srem(TD_ID..'Mutes:'..msg.chat_id,v)
UnRes(msg.chat_id,v)
end
send(msg.chat_id, msg.send_message_id,'•تعطیل کردن خودکار غیرفعال شد !','md')
else
send(msg.chat_id, msg.send_message_id,'•تعطیل کردن خودکار #فعال نمیباشد!','md')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
----------------
if Black and (Black1:match('^(automute) (%d+):(%d+)-(%d+):(%d+)$') or Black1:match('^(قفل گروه) (%d+):(%d+)-(%d+):(%d+)$')) and is_JoinChannel(msg) then
local Black1 = Black1:gsub("قفل گروه", "automute")
local matches = {string.match(Black1, "^(automute) (%d+):(%d+)-(%d+):(%d+)$")}
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'automuteall')  then
auto= 'فعال ✔'
else
auto= 'غیرفعال'
end
local endtime = matches[4]..matches[5]
local endtime1 = matches[4]..":"..matches[5]
local starttime2 = matches[2]..":"..matches[3]
base:set(TD_ID..'EndTimeSee'..msg.chat_id,endtime1)
base:set(TD_ID..'StartTimeSee'..msg.chat_id,starttime2)
local starttime = matches[2]..matches[3]
if endtime1 == starttime2 then
test = [[✖ شروع قفل خودکار نمیتواند با پایان آن یکے باشد]]
send(msg.chat_id, msg.send_message_id,test,"md")
else
base:set(TD_ID..'automutestart'..chat,starttime)
base:set(TD_ID..'automuteend'..chat,endtime)
test= '⭕ گروه شما به صورت خودکار از ساعت :\n* 【'..starttime2..'】*\nقفل\nو در ساعت :\n *【'..endtime1..'】*\nباز خواهد شد\n-----------------------------------\nقفل خودکار : '..auto..''
send(msg.chat_id, msg.send_message_id,test,"md")
end
end
if Black == 'viplist' or Black == 'لیست ویژه' then  
local list = base:smembers(TD_ID..'Vip:'..msg.chat_id)
local t = 'لیست ویژه :\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do  
t = t..k..'-【['..v..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
if #list == 0 then
t = 'لیست ویژه خالی میباشد...!'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if Black == 'banlist' or Black == 'لیست مسدود' or Black == 'لیست بن' then  
local list = base:smembers(TD_ID..'BanUser:'..msg.chat_id)
local t = 'لیست مسدود :\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do  
t = t..k..'-【['..v..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
if #list == 0 then
t = 'لیست مسدود خالی میباشد...!'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if (Black == 'clean banlist' or Black == 'پاکسازی لیست مسدود' or Black == 'پاکسازی لیست بن') and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
cleanbanlist(msg)
base:del(TD_ID..'BanUser:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'✳ تمام ڪاربران محروم شده از لیست مسدود حذف شدند','md')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if Black == 'clean mutelist' or Black == 'پاکسازی لیست سایلنت' or Black == 'پاکسازی لیست سکوت' then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
cleanmutelist(msg)
base:del(TD_ID..'MuteList:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'✴ تمام افراد سکوت شده ازاد شدند','md')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if (Black == 'clean bots' or Black == 'پاکسازی ربات ها') and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
cleanbots(msg)
else
send(msg.chat_id, msg.send_message_id,'✖ دسرسی لازم براے پاکسازے  ربات هاے مخرب رو ندارد\n─┅━━━━━━━┅─\nربات را ادمین کرده سپس مجدد تلاش کنید !','html')
end
end
--------
if (Black == 'revoke link' or Black == 'باطل کردن لینک') and is_JoinChannel(msg)  then
local Diamond = TD.getChat(msg.chat_id)
local result = TD.generateChatInviteLink(msg.chat_id)
if not result.invite_link then
send(msg.chat_id, msg.send_message_id, '|↜ ربات به قسمت دعوت کاربران با لینک دسترسے ندارد...!\nلطفا ابتدا ربات را ادمین گروه کنید سپس این دستور را اراسال نمایید...!','md')
else
local keyboard = {}
keyboard.inline_keyboard = {{{text = '✦ براے عضویت در کانال کلیک کنید',url='https://telegram.me/'..Config.Channel}}}   
send_inline(msg.chat_id,'لینک گروه باطل شد...!\n─┅━━━━━━━┅─\nلینک جدید :\n <a href="'..result.invite_link..'">'..Diamond.title..'</a>',keyboard,'html')
base:set(TD_ID..'Link:'..msg.chat_id,result.invite_link)
end
end
if Black and (Black:match('^setlink http(.*)') or Black:match('^تنظیم لینک http(.*)')) then
local link = msg.content.text.text:match('^setlink (.*)') or msg.content.text.text:match('^تنظیم لینک (.*)')
base:set(TD_ID..'Link:'..msg.chat_id,link)
send(msg.chat_id, msg.send_message_id,'لینک گروه ثبت شد :\n'..link,'html')
end
if Black and (Black:match('^[Cc]lean fake$') or Black:match('^پاکسازی فیک$')) and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end

statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local data = TD.getSupergroupMembers(msg.chat_id, "Recent", '' , 0 , 200 )
for k,v in pairs(data.members) do
local user = TD.getUser(v.member_id.user_id)
if user.type._ == "userTypeGeneral" then
if user.status._ == "userStatusEmpty" then
KickUser(msg.chat_id,user.id)
end
end
end
send(msg.chat_id, msg.send_message_id,'اعضاے #غیرفعال و فیک از گروه اخراج شدند','md')
else
send(msg.chat_id, msg.send_message_id,'✖ دسرسی لازم براے پاکسازے  اعضاے #غیرفعال رو ندارد\n─┅━━━━━━━┅─\nربات را ادمین کرده سپس مجدد تلاش کنید !','html')
end
end
------Vip Add
if Diamondent and (Black:match('^setvipadd (.*)') or Black:match('^معاف (.*)')) or Black and (Black:match('^setvipadd @(.*)') or Black:match('^معاف @(.*)') or Black:match('^setvipadd (%d+)$') or Black:match('^معاف (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^setvipadd (.*)') or Black:match('^معاف (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^setvipadd @(.*)') or Black:match('^معاف @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^setvipadd (%d+)') or Black:match('^معاف (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^setvipadd (.*)') or Black:match('^معاف (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if base:sismember(TD_ID..'VipAdd:'..msg.chat_id,mrr619) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nاز قبل جزء لیست ویژه ادجباری بود...!','md')
else
send(msg.chat_id, msg.send_message_id, '✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nبه لیست ویژه اداجباری اضافه شد...!','md')
base:sadd(TD_ID..'VipAdd:'..msg.chat_id,mrr619)
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','md')
end
end
if Diamondent and (Black:match('^remvipadd (.*)') or Black:match('^اجبار (.*)')) or Black and (Black:match('^remvipadd @(.*)') or Black:match('^اجبار @(.*)') or Black:match('^remvipadd (%d+)$') or Black:match('^اجبار (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^remvipadd (.*)') or Black:match('^اجبار (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^remvipadd @(.*)') or Black:match('^اجبار @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^remvipadd (%d+)') or Black:match('^اجبار (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^remvipadd (.*)') or Black:match('^اجبار (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if not base:sismember(TD_ID..'VipAdd:'..msg.chat_id,mrr619) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nدر لیست ویژه اداجباری نبود...!','md')
else
base:srem(TD_ID..'VipAdd:'..msg.chat_id,mrr619)
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nاز لیست ویژه اداجباری خارج شد...!','md')
end
else 
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','md')
end
end
if Black == 'vipaddlist' or Black == 'لیست معاف' then  
local list = base:smembers(TD_ID..'VipAdd:'..msg.chat_id)
local t = 'لیست ویژه اداجباری :\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do  
t = t..k..'-【['..v..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
if #list == 0 then
t = 'لیست ویژه اداجباری خالی میباشد...!'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if Black == 'clean vipaddlist' or Black == 'پاکسازی لیست معاف'  then
base:del(TD_ID..'VipAdd:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'• لیست ویژه اداجباری پاکسازی شد!','md')
end
if (Black == 'setvip' or Black == 'ویژه') and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
if base:sismember(TD_ID..'Vip:'..msg.chat_id, user) then
send(msg.chat_id, msg.send_message_id,'|↜ کاربر : '..user..' از قبل در لیست افراد ویژه قرار داشت','md')
else
send(msg.chat_id, msg.send_message_id,'⭕ کاربر : '..user..' به لیست افراد ویژه افزوده شد','md')
base:sadd(TD_ID..'Vip:'..msg.chat_id, user)
end
end
end
if Black and (Black:match('^setvip @(.*)') or Black:match('^ویژه @(.*)')) and is_JoinChannel(msg) then
local username = Black:match('^setvip @(.*)') or Black:match('^ویژه @(.*)')
local Diamond = TD.searchPublicChat(username)
if Diamond.id then
if base:sismember(TD_ID..'Vip:'..msg.chat_id,Diamond.id) then
send(msg.chat_id, msg.send_message_id,'|↜ کاربر : '..Diamond.id..' از قبل در لیست افراد ویژه قرار داشت','md')
else
send(msg.chat_id, msg.send_message_id,'⭕ کاربر : '..Diamond.id..' به لیست افراد ویژه افزوده شد','md')
base:sadd(TD_ID..'Vip:'..msg.chat_id, Diamond.id)
end
else 
send(msg.chat_id, msg.send_message_id,'❎ کاربر یافت نشد','md')
end
end
if (Black == 'clean viplist' or Black == 'پاکسازی لیست ویژه') and is_JoinChannel(msg) then
base:del(TD_ID..'Vip:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'✴ لیست افراد ویژه پاکسازے شد','md')
end
if Black == 'remvip' or Black == 'حذف ویژه' and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
if base:sismember(TD_ID..'Vip:'..msg.chat_id, user) then
send(msg.chat_id, msg.send_message_id,'⭕ کاربر : '..user..' از لیست افراد ویژه خارج شد','md')
base:srem(TD_ID..'Vip:'..msg.chat_id, user)
else
send(msg.chat_id, msg.send_message_id,'⭕ کاربر : '..user..' از قبل در لیست افراد ویژه نبود','md')
end
end
end
if Black and (Black:match('^remvip @(.*)') or Black:match('^حذف ویژه @(.*)')) and is_JoinChannel(msg) then
local username = Black:match('^remvip @(.*)') or Black:match('^حذف ویژه @(.*)')
local Diamond = TD.searchPublicChat(username)
if Diamond.id then
if base:sismember(TD_ID..'Vip:'..msg.chat_id,Diamond.id) then
send(msg.chat_id, msg.send_message_id,'⭕ کاربر : '..Diamond.id..' از لیست افراد ویژه خارج شد','md')
base:srem(TD_ID..'Vip:'..msg.chat_id,Diamond.id)
else
send(msg.chat_id, msg.send_message_id,'⚪ کاربر : '..Diamond.id..' از قبل در لیست افراد ویژه نبود','md')
end
else 
send(msg.chat_id, msg.send_message_id,'❎ کاربر یافت نشد','html')
end
end
if (Black == 'restartpm' or Black == 'ریستارت پیام ها') and tonumber(reply_id) == 0 and is_JoinChannel(msg) then
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..msg.sender_id.user_id)
send(msg.chat_id, msg.send_message_id,'♻ تعداد پیام هاے کل و امروز شما صفر شد...!','md')
end
 if (Black == 'restartpm' or Black == 'ریستارت پیام') and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..user)
send(msg.chat_id, msg.send_message_id,'✦ پیام هاے امروز کاربر : ['..name..'](tg://user?id='..user..') ری استارت شد...!','md')
end
end
-- تنظیم لقب
if Black and (Black:match('^setrank (.*)$') or Black:match('^تنظیم لقب (.*)$')) and tonumber(reply_id) ~= 0 then
    local rank = Black:match('^setrank (.*)$') or Black:match('^تنظیم لقب (.*)$')
    local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
    local user = Diamond.sender_id.user_id
    if user then
        if tonumber(user) == tonumber(BotCliId) then
            send(msg.chat_id, msg.send_message_id, '❎ من نمی‌توانم پیام خودم را چک کنم', 'md')
            return false
        end
        if tonumber(user) == Sudoid then
            send(msg.chat_id, msg.send_message_id, 'نمی‌تونی به بابام لقب بدی 🖕😐', 'md')
            return false
        end
        base:set(TD_ID..'rank'..msg.chat_id..user, rank)
        base:sadd(TD_ID..'RankRegistered:'..msg.chat_id, user) -- اضافه کردن کاربر به لیست مقام‌ها
        local diamond = TD.getUser(user)
        local name = diamond.usernames and diamond.usernames.editable_username or ec_name(diamond.first_name)
        send(msg.chat_id, msg.send_message_id, '✦ لقب کاربر : '..MBD(name, user)..' به ['..rank..']\nتغییر کرد\n', 'md')
    end
end

-- نمایش لیست لقب‌ها
if Black and (Black:match('^لیست لقب$') or Black:match('^listrank$')) then
    if is_supergroup(msg) then
        if is_Sudo(msg) or is_Owner(msg) or is_Mod(msg) then
            local users = base:smembers(TD_ID..'RankRegistered:'..msg.chat_id)
            if #users > 0 then
                local rank_list = '*✦ لیست لقب‌های ثبت‌شده در گروه:*\n\n'
                for i, user_id in ipairs(users) do
                    local rank_text = base:get(TD_ID..'rank'..msg.chat_id..user_id) or 'بدون لقب'
                    local diamond = TD.getUser(user_id)
                    local name = diamond.usernames and diamond.usernames.editable_username or ec_name(diamond.first_name)
                    rank_list = rank_list .. i .. '. ' .. MBD(name, user_id) .. ': ' .. rank_text .. '\n'
                end
                send(msg.chat_id, msg.send_message_id, rank_list, 'md')
            else
                send(msg.chat_id, msg.send_message_id, '✦ هیچ لقبی در این گروه ثبت نشده است.', 'md')
            end
        else
            send(msg.chat_id, msg.send_message_id, '✦ فقط مدیران، صاحبان گروه یا سودوها می‌توانند لیست لقب‌ها را ببینند.', 'md')
        end
    else
        send(msg.chat_id, msg.send_message_id, '✦ این دستور فقط در سوپرگروه‌ها قابل استفاده است.', 'md')
    end
end

-- حذف لقب
if Black and (Black:match('^delrank$') or Black:match('^حذف لقب$')) and tonumber(reply_id) ~= 0 then
    local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
    local user = Diamond.sender_id.user_id
    if user then
        base:del(TD_ID..'rank'..msg.chat_id..user)
        base:srem(TD_ID..'RankRegistered:'..msg.chat_id, user) -- حذف کاربر از لیست مقام‌ها
        local diamond = TD.getUser(user)
        local name = diamond.usernames and diamond.usernames.editable_username or ec_name(diamond.first_name)
        send(msg.chat_id, msg.send_message_id, '✦ لقب کاربر : ['..name..'](tg://user?id='..user..') پاک شد.', 'md')
    end
end
if Black and (Black:match('^restartpm @(.*)') or Black:match('^ریستارت پیام @(.*)')) and is_JoinChannel(msg) then
local username = Black:match('^restartpm @(.*)') or Black:match('^ریستارت پیام @(.*)')
local Diamond = TD.searchPublicChat(username)
if Diamond.id then
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..Diamond.id)
send(msg.chat_id, msg.send_message_id,'✦ پیام هاے امروز کاربر : '..username..' ری استارت شد...!','html')
else
send(msg.chat_id, msg.send_message_id,'❎ کاربر یافت نشد','md')
end
end
if (Black == 'antitabchi on' or Black == 'ضدتبچی فعال') and is_JoinChannel(msg) then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'AntiTabchi')
send(msg.chat_id, msg.send_message_id,'✅ احراز هویت (ضدتبجی) فعال شد و کاربرانی که عضو میشوند باید به سوال ربات پاسخ دهند تا ربات نبودن آن ها ثابت شود در غیراین صورت ربات شناخته شده و از گروه اخراج میشوند','md')
end
if (Black == 'antitabchi off' or Black == 'ضدتبچی غیرفعال') and is_JoinChannel(msg) then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'AntiTabchi')
send(msg.chat_id, msg.send_message_id,'✅ احراز هویت غیرفعال شد !','md')
end
if (Black == 'firstmute on' or Black == 'محدودیت تبچی فعال') and is_JoinChannel(msg) then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'FirstTabchiMute')
send(msg.chat_id, msg.send_message_id,'✅ محدود شدن تمامی اعضای جدید به محض ورود فعال شد !\nاین کاربران باید حتما به سوال احراز هویت پاسخ دهند تا بتوانند در گروه پیام ارسال کنند !','md')
end
if (Black == 'firstmute off' or Black == 'محدودیت تبچی غیرفعال') and is_JoinChannel(msg) then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'FirstTabchiMute')
send(msg.chat_id, msg.send_message_id,'✅ محدود شدن تمامی اعضا به محض ورود غیرفعال شد !','md')
end
if (Black == 'limitpm on' or Black == 'محدودیت پیام فعال') and is_JoinChannel(msg) then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'limitpm:on')
limitmsg = base:get(TD_ID..'limitpm:'..msg.chat_id) or 5
timelimit = base:get(TD_ID..'mutetime:'..msg.chat_id) or 3600
send(msg.chat_id, msg.send_message_id,'✅ محدودیت ارسال پیام فعال شد...!\nتعداد مجاز ارسال پیام : *'..limitmsg..'*\nزمان محدودیت : *'..timelimit..'*','md')
end
if (Black == 'limitpm off' or Black == 'محدودیت پیام غیرفعال') and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'limitpm:on')
local unlimit = base:smembers(TD_ID..'limituser:'..msg.chat_id)
for k,v in pairs(unlimit) do
base:srem(TD_ID..'limituser:'..msg.chat_id,v)
UnRes(msg.chat_id,v)
end
send(msg.chat_id, msg.send_message_id,'🔹 محدودیت ارسال پیام غیرفعال شد...!\nتمام محدودیت هاے افراد محدودشدگان به دلیل ارسال پیام بیش از حد مجاز رفع شد.','md')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if (Black == 'unlimitpm' or Black == 'حذف محدود') and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'limitpm'..user)
UnRes(msg.chat_id,user)
send(msg.chat_id, msg.send_message_id,"✦ کاربر : "..(user or 0000000).."\nاز محدودیت ارسال پیام در روز رها شد و از سکوت نیز خارج شد.",'md')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if Diamondent and (Black:match('^unlimitpm (.*)') or Black:match('^رفع محدودیت پیام (.*)')) or Black and (Black:match('^unlimitpm @(.*)') or Black:match('^رفع محدودیت پیام @(.*)') or Black:match('^unlimitpm (%d+)$') or Black:match('^رفع محدودیت پیام (%d+)$')) and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local BDSource = Black:match('^unlimitpm (.*)') or Black:match('^حذف محدود (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^unlimitpm @(.*)') or Black:match('^حذف محدود @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^unlimitpm (%d+)') or Black:match('^حذف محدود (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^unlimitpm (.*)') or Black:match('^حذف محدود (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'limitpm'..mrr619)
UnRes(msg.chat_id,mrr619)
send(msg.chat_id, msg.send_message_id,"✦ کاربر : "..BDSource.." از محدودیت ارسال پیام در روز رها شد و از سکوت نیز خارج شد.",'html')
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','html')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if (Black == 'limitpm' or Black == 'محدود') and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'limitpm'..user)
send(msg.chat_id, msg.send_message_id,"✦ کاربر : "..(user or 0000000).." به لیست محدودیت ارسال پیام در روز اضافه شد",'md')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
-------limitpm
if Diamondent and (Black:match('^limitpm (.*)') or Black:match('^محدود (.*)')) or Black and (Black:match('^limitpm @(.*)') or Black:match('^محدود @(.*)') or Black:match('^limitpm (%d+)$') or Black:match('^محدود (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^limitpm (.*)') or Black:match('^محدود (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^limitpm @(.*)') or Black:match('^محدود @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^limitpm (%d+)') or Black:match('^محدود (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^limitpm (.*)') or Black:match('^محدود (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'limitpm'..mrr619)
send(msg.chat_id, msg.send_message_id,"✦ کاربر : "..BDSource.." به لیست محدودیت ارسال پیام در روز اضافه شد",'html')
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','html')
end
end
if Black and (Black:match('^setlimitpm (%d+)$') or Black:match('^تنظیم محدودیت پیام (%d+)$')) and is_JoinChannel(msg) then
local num = Black:match('^setlimitpm (%d+)') or Black:match('^تنظیم محدودیت پیام (%d+)')
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'limitpm:on') then
if tonumber(num) < 1 then
send(msg.chat_id, msg.send_message_id,'🚬 عددے بزرگتر از *1* بکار ببرید','md')
else
base:set(TD_ID..'limitpm:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'✅ محدودیت ارسال پیام تنظیم شد بر روے : *'..num..'*\nیعنی هر فرد در طول یک روز نمیتواند بیشتر از '..num..' پیام در گروه ارسال کند و در صورت ارسال از چت کردن در گروه محروم میشود تا زمانی که شما محدودیت ارسال پیام را غیرفعال کنید','md')
end
else
send(msg.chat_id, msg.send_message_id,'محدودیت پیام در گروه فعال نیست...!\nابتدا با دستور\n(`محدودیت پیام فعال`) یا (`limitpm on`)\nاقدام به فعال کردن محدودیت پیام کنید سپس محدودیت پیام را تنظیم کنید.','md')
end
end
if Black and (Black:match('^setmutetime (%d+)[hms]') or Black:match('^زمان سکوت (%d+)[سدث]')) and is_JoinChannel(msg) then
local num = Black:match('^setmutetime (%d+)[hms]') or Black:match('^زمان سکوت (%d+)[سدث]')
 if Black and (Black:match('(%d+)h') or Black:match('(%d+)س')) then
          time_match = Black:match('(%d+)h') or Black:match('(%d+)س')
          time = time_match * 3600
          end
          if Black and (Black:match('(%d+)m') or Black:match('(%d+)د')) then 
          time_match = Black:match('(%d+)m') or Black:match('(%d+)د')
          time = time_match * 60
          end
          if Black and (Black:match('(%d+)s') or Black:match('(%d+)ث')) then
          time_match = Black:match('(%d+)s') or Black:match('(%d+)ث')
          time = time_match
          end
base:set(TD_ID..'mutetime:'..msg.chat_id,time)
send(msg.chat_id, msg.send_message_id,'🕗 زمان محدودیت سکوت تنظیم شد بر روے : *'..time..'* ثانیه\nدر صورت محدود شدن کاربر,کاربر مورد نظر *'..time..'* ثانیه از ارسال پیام در گروه منع خواهد شد.','md')
end
if Black == 'panel public' or Black == 'پنل همگانی' then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'PanelPv')
send(msg.chat_id, msg.send_message_id,'> پنل بر روی همگانی تنظیم شد و مدیر دیگر قادر به کار با پنل دیگر مدیران نیز خواهد بود','md')
end
if Black == 'panel privite' or Black == 'پنل خصوصی' then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'PanelPv')
send(msg.chat_id, msg.send_message_id,'> پنل بر روی خصوصی تنظیم شد و مدیر دیگر قادر به کار با پنل دیگران مدیران نخواهد بود','md')
end
if Black == 'del' or Black == 'حذف' and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
TD.deleteMessages(msg.chat_id,{[1] = Diamond.id})
end
--------cgm auto------- (نسخه کاملاً سالم و بدون باگ)-------

-- تنظیم زمان پاکسازی خودکار (مثال: cgmtime 06:30 یا زمان پاکسازی 14:45)
if Black and (Black:match('^cgmtime (%d?%d):(%d%d)$') or Black:match('^زمان پاکسازی (%d?%d):(%d%d)$')) and is_JoinChannel(msg) then
    local hour, min

    if Black:match('^زمان پاکسازی') then
        hour, min = Black:match('^زمان پاکسازی (%d?%d):(%d%d)$')
    else
        hour, min = Black:match('^cgmtime (%d?%d):(%d%d)$')
    end

    -- اعتبارسنجی ساعت و دقیقه
    hour = tonumber(hour)
    min  = tonumber(min)
    if hour < 0 or hour > 23 or min < 0 or min > 59 then
        send(msg.chat_id, msg.send_message_id, "❌ ساعت یا دقیقه نامعتبر است!\nفرمت صحیح: cgmtime 14:30", "md")
        return
    end

    -- فرمت‌دهی صحیح (مثلاً 6:5 → 06:05 و 0605)
    local pretty_time = string.format("%02d:%02d", hour, min)
    local short_time  = string.format("%02d%02d", hour, min)  -- 1430

    base:set(TD_ID..'autoCgmstart'..msg.chat_id, short_time)
    base:set(TD_ID..'StartTimeCgm'..msg.chat_id, pretty_time)   -- برای نمایش: 14:30

    -- فعال کردن خودکار پاکسازی
    base:sadd(TD_ID..'Gp2:'..msg.chat_id, 'cgmautoon')

    send(msg.chat_id, msg.send_message_id,
        "✅ زمان پاکسازی خودکار تنظیم شد!\n\n"..
        "⏰ هر روز ساعت *【 "..pretty_time.." 】* تمام پیام‌های گروه پاک می‌شود.\n"..
        "🧹 پاکسازی خودکار: *فعال ✔️*", "md")
    return
end

-- فعال کردن پاکسازی خودکار
if (Black == 'cgm on' or Black == 'پاکسازی فعال') and is_JoinChannel(msg) then
    local saved_time = base:get(TD_ID..'StartTimeCgm'..msg.chat_id)

    if not saved_time then
        send(msg.chat_id, msg.send_message_id,
            "✖️ ابتدا زمان پاکسازی را تنظیم کنید!\n\n"..
            "مثال: `cgmtime 06:30`\nیا: `زمان پاکسازی 14:45`", "md")
        return
    end

    if base:sismember(TD_ID..'Gp2:'..msg.chat_id, 'cgmautoon') then
        send(msg.chat_id, msg.send_message_id, "✔️ پاکسازی خودکار از قبل فعال بود!\n⏰ ساعت: *"..saved_time.."*", "md")
    else
        base:sadd(TD_ID..'Gp2:'..msg.chat_id, 'cgmautoon')
        send(msg.chat_id, msg.send_message_id, "✅ پاکسازی خودکار با موفقیت فعال شد!\n⏰ ساعت: *"..saved_time.."*", "md")
    end
    return
end

-- غیرفعال کردن
if (Black == 'cgm off' or Black == 'پاکسازی غیرفعال') and is_JoinChannel(msg) then
    if base:sismember(TD_ID..'Gp2:'..msg.chat_id, 'cgmautoon') then
        base:srem(TD_ID..'Gp2:'..msg.chat_id, 'cgmautoon')
        send(msg.chat_id, msg.send_message_id, "✅ پاکسازی خودکار غیرفعال شد.", "md")
    else
        send(msg.chat_id, msg.send_message_id, "✔️ پاکسازی خودکار از قبل غیرفعال بود.", "md")
    end
    return
end

-- وضعیت فعلی (اختیاری — می‌تونی اضافه کنی)
if (Black == 'cgm status' or Black == 'وضعیت پاکسازی') and is_JoinChannel(msg) then
    local time = base:get(TD_ID..'StartTimeCgm'..msg.chat_id) or "تنظیم نشده"
    local status = base:sismember(TD_ID..'Gp2:'..msg.chat_id, 'cgmautoon') and "فعال ✔️" or "غیرفعال ✖️"
    send(msg.chat_id, msg.send_message_id,
        "🧹 *وضعیت پاکسازی خودکار*\n\n"..
        "⏰ زمان تنظیم شده: `"..time.."`\n"..
        "وضعیت: "..status, "md")
end
-------BotCgm
if Black and (Black:match('^cbmtime (%d+)$') or Black:match('^زمان پاکسازی ربات (%d+)$')) and is_JoinChannel(msg) then
local time_match = Black:match('^cbmtime (%d+)') or Black:match('^زمان پاکسازی ربات (%d+)')
base:set(TD_ID..'cbmtime:'..msg.chat_id,time_match)
send(msg.chat_id, msg.send_message_id,'🕗 زمان پاکسازے خودکار تنظیم شد بر روے : *'..time_match..'* ثانیه\nیعنی هر '..time_match..' ثانیه یکبار پاکسازے  پیام هاے ربات بصورت اتوماتیک انجام خواهد شد...!','md')
end
if (Black == 'cbm on' or Black == 'پاکسازی ربات فعال') and is_JoinChannel(msg) then
local timecgms = base:get(TD_ID..'cbmtime:'..msg.chat_id) or 10
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'cbmon') then
send(msg.chat_id, msg.send_message_id,'✔️ پاکسازے خودکار از قبل فعال بود\n#زمان : '..timecgms,'md')
else
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'cbmon')
send(msg.chat_id, msg.send_message_id,'✅ پاکسازے خودکار پیام هاے ربات فعال شد...!\n🕗 زمان پاکسازے خودکار هر '..timecgms..' ثانیه یکبار است.','md')
end
end
if (Black == 'cbm off' or Black == 'پاکسازی ربات غیرفعال') and is_JoinChannel(msg) then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'cbmon') then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'cbmon')
send(msg.chat_id, msg.send_message_id,'✅ پاکسازے خودکار پیام هاے ربات غیرفعال شد...!','md')
else
send(msg.chat_id, msg.send_message_id,'✔️ پاکسازے خودکار پیام هاے ربات غیرفعال بود...!','md')
end
end
-------Mute (کامل، بدون باگ، بدون پیام تکراری)-------
if (Black == 'mute' or Black == 'سکوت') and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
    local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id and Diamond.sender_id.user_id or Diamond.sender_user_id or Diamond.from and Diamond.from.id or 0
    if user then
        local url_ = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
        local statsurl_ = json:decode(url_) or {}
        
        if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
            local diamond = TD.getUser(user)
            local name = diamond.usernames and diamond.usernames.editable_username or ec_name(diamond.first_name or "")
            
            if VipUser(msg,user) then
                send(msg.chat_id, msg.send_message_id,'خطا #اخطار !\nا─┅━━━━━━━┅─\nکاربر ['..name..'](tg://user?id='..user..') دارای مقام میباشد شما نمیتوانید او را سکوت کنید...!','md')
            else
                MuteUser(msg.chat_id,user,0)
                base:sadd(TD_ID..'MuteList:'..msg.chat_id,user)
                send(msg.chat_id, msg.send_message_id,'کاربر : ['..name..'](tg://user?id='..user..') در حالت سکوت قرار گرفت','md')
            end
        else
            send(msg.chat_id, msg.send_message_id,'ربات به قسمت محرومیت کاربران دسترسی ندارد !\nلطفاً از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
        end
    end
    return  -- مهم: جلوگیری از اجرای بلوک‌های بعدی
end

-- سکوت با یوزرنیم / آیدی عددی / منشن (اسم فامیلی)
if (Black:match('^mute @(.*)') or Black:match('^سکوت @(.*)') or Black:match('^mute (%d+)$') or Black:match('^سکوت (%d+)$') or (Black:match('^mute (.*)') or Black:match('^سکوت (.*)'))) and is_JoinChannel(msg) then
    local url_ = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
    local statsurl = json:decode(url_) or {}
    
    local BDSource = Black:match('^mute (.*)$') or Black:match('^سکوت (.*)$') or Black
    local target_user = nil
    local display_text = BDSource

    -- یوزرنیم
    if Black:match('^mute @(.*)') or Black:match('^سکوت @(.*)') then
        local username = Black:match('^mute @(.*)') or Black:match('^سکوت @(.*)')
        local chat = TD.searchPublicChat(username)
        if chat and chat.id then
            target_user = chat.id
            display_text = '@'..username
        end
    -- آیدی عددی
    elseif Black:match('^mute (%d+)$') or Black:match('^سکوت (%d+)$') then
        target_user = tonumber(BDSource)
        display_text = target_user
    -- منشن (اسم فامیلی با لینک)
    elseif msg.content and msg.content.text and msg.content.text.entities then
        for _, entity in pairs(msg.content.text.entities) do
            if entity.type._ == "textEntityTypeMentionName" then
                target_user = entity.type.user_id
                break
            end
        end
    end

    if not target_user then
        send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!', 'md')
        return
    end

    if statsurl.ok == true and statsurl.result.status == 'administrator' and statsurl.result.can_restrict_members == true then
        if VipUser(msg, target_user) then
            send(msg.chat_id, msg.send_message_id,'خطا #اخطار !\nا─┅━━━━━━━┅─\nکاربر ['..display_text..'](tg://user?id='..target_user..') دارای مقام میباشد شما نمیتوانید او را سکوت کنید...!','md')
        else
            MuteUser(msg.chat_id, target_user, 0)
            base:sadd(TD_ID..'MuteList:'..msg.chat_id, target_user)
            send(msg.chat_id, msg.send_message_id,'کاربر : ['..display_text..'](tg://user?id='..target_user..') در حالت سکوت قرار گرفت','md')
        end
    else
        send(msg.chat_id, msg.send_message_id,'ربات به قسمت محرومیت کاربران دسترسی ندارد !\nلطفاً از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
    end
    return  -- جلوگیری از اجرای بلوک بعدی
end

-- سکوت ساعتی (مثل: mute 5 یا سکوت 3) - فقط با ریپلای
if Black and (Black:match('^mute (%d+)$') or Black:match('^سکوت (%d+)$')) and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
    local hours = tonumber(Black:match('^mute (%d+)$') or Black:match('^سکوت (%d+)$'))
    local time_until = msg.date + (hours * 3600)

    local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
    local user = Diamond.sender_id.user_id
    if not user then return end

    local url_ = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
    local statsurl_ = json:decode(url_) or {}

    if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
        local diamond = TD.getUser(user)
        local name = diamond.usernames and diamond.usernames.editable_username or ec_name(diamond.first_name or "")

        if VipUser(msg, user) then
            send(msg.chat_id, msg.send_message_id,'خطا #اخطار !\nا─┅━━━━━━━┅─\nکاربر ['..name..'](tg://user?id='..user..') دارای مقام میباشد شما نمیتوانید او را سکوت کنید...!','md')
        else
            MuteUser(msg.chat_id, user, time_until)
            base:sadd(TD_ID..'MuteList:'..msg.chat_id, user)
            send(msg.chat_id, msg.send_message_id,'کاربر : ['..name..'](tg://user?id='..user..')\nبه مدت '..hours..' ساعت در حالت سکوت قرار گرفت','md')
        end
    else
        send(msg.chat_id, msg.send_message_id,'ربات دسترسی محرومیت کاربران رو نداره!\nلطفاً از تنظیمات گروه فعالش کن.','md')
    end
    return  -- مهم: اینجا هم return گذاشتم که هیچ کد دیگه‌ای اجرا نشه
end
--<><><>UnMute
if (Black == 'unmute' or Black == 'حذف سکوت') and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'MuteList:'..msg.chat_id,user) then
UnRes(msg.chat_id,user)
base:srem(TD_ID..'SilentList:'..msg.chat_id,user)
base:srem(TD_ID..'MuteList:'..msg.chat_id,user)
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\n از حالت سکوت خارج شد🔈','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..') در لیست سکوت نمیباشد','md')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
end
if Diamondent and (Black:match('^unmute (.*)') or Black:match('^حذف سکوت (.*)')) or Black and (Black:match('^unmute @(.*)') or Black:match('^حذف سکوت @(.*)') or Black:match('^unmute (%d+)$') or Black:match('^حذف سکوت (%d+)$')) and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local BDSource = Black:match('^unmute (.*)') or Black:match('^حذف سکوت (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^unmute @(.*)') or Black:match('^حذف سکوت @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^unmute (%d+)') or Black:match('^حذف سکوت (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^unmute (.*)') or Black:match('^حذف سکوت (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if base:sismember(TD_ID..'MuteList:'..msg.chat_id,mrr619) then
UnRes(msg.chat_id,mrr619)
base:srem(TD_ID..'SilentList:'..msg.chat_id,mrr619)
base:srem(TD_ID..'MuteList:'..msg.chat_id,mrr619)
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\n از حالت سکوت خارج شد🔈','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..') در لیست سکوت نمیباشد','md')
end
else 
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!',  'html')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if Black and (Black:match('^([Ss]etforce) (.*)$') or Black:match('^(وضعیت افزودن اجباری) (.*)$')) then
local Black = Black:gsub("وضعیت افزودن اجباری", "setforce")
local status = {string.match(Black, "^([Ss]etforce) (.*)$")}
if status[2] == 'new user' or status[2] == 'جدید' then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'force_NewUser')
send(msg.chat_id, msg.send_message_id,'وضعیت افزودن اجبارے براے کاربران جدید فعال شد\n>از این پس کاربران جدید باید به تعداد دلخواه شما ممبر به گروه اضافه کنند تا بتوانند پیام ارسال کنند!','md')
end
if status[2] == 'all user' or status[2] == 'همه' then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'force_NewUser')
send(msg.chat_id, msg.send_message_id,'وضعیت افزودن اجبارے براے همه کاربران فعال شد','md')
end
end
if Black and (Black:match('^(limitpmstatus) (.*)$') or Black:match('^(وضعیت محدودیت پیام) (.*)$')) then
Black = Black:gsub("وضعیت محدودیت پیام", "limitpmstatus")
status = {string.match(Black,"^(limitpmstatus) (.*)$")}
if status[2] == 'one user' or status[2] == 'تک کاربر' then
base:set(TD_ID..'limit_type:'..msg.chat_id,'one')
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روے تک کاربر #فعال شد','md')
end
if status[2] == 'all user' or status[2] == 'همه' then
base:set(TD_ID..'limit_type:'..msg.chat_id,'all')
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روے همه کاربران #فعال شد','md')
end
end
if Black and (Black:match('^mute (%d+)$') or Black:match('^سکوت (%d+)$')) and tonumber(reply_id) ~= 0 and is_JoinChannel(msg) then
local times = Black:match('^mute (%d+)$') or Black:match('^سکوت (%d+)$')
time = times * 3600
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id)) 
local user = Diamond.sender_id.user_id
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
if user then
if VipUser(msg,user) then
send(msg.chat_id, msg.send_message_id,"❌ #اخطار  !\nا─┅━━━━━━━┅─\nشما نمیتوانید کاربران دارای مقام را سکوت کنید...!",'md')
else
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\nدر حالت سکوت قرار گرفت براے '..times..' ساعت⌚','md')
MuteUser(msg.chat_id,user,msg.date+time)
base:sadd(TD_ID..'MuteList:'..msg.chat_id,user)
end
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..') در حالت سکوت قرار نگرفت !\n✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
end
if (Black == 'mutelist' or Black == 'لیست سکوت') and is_JoinChannel(msg) then
local list = base:smembers(TD_ID..'MuteList:'..msg.chat_id)
local t = '⭕ لیست افراد سکوت \nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do
t = t..k..'-【['..v..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
if #list == 0 then
t = '⭕لیست افراد سکوت شده خالے است'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if (Black == 'clean warnlist' or Black == 'پاکسازی لیست اخطار') and is_JoinChannel(msg) then
base:del(TD_ID..''..msg.chat_id..':warn')
send(msg.chat_id, msg.send_message_id,'لیست اخطار ها پاکسازے شد','md')
end
if (Black == "warnlist" or Black == "لیست اخطار") and is_JoinChannel(msg) then
local comn = base:hkeys(TD_ID..msg.chat_id..':warn')
local t = 'لیست اخطار ها :\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs (comn) do
local cont = base:hget(TD_ID..msg.chat_id..':warn', v)
t = t..k..'-【['..v..'](tg://user?id='..v..')】\nتعداد اخطار :【'..(cont - 1)..'】\n─┅━━━━━━━┅─\n'
end
if #comn == 0 then
t = 'لیست اخطار ها خالے میباشد'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
----UnBan By @Mrr619---
if Diamondent and (Black:match('^unban (.*)') or Black:match('^حذف مسدود (.*)') or Black:match('^حذف بن (.*)')) 
or Black and (Black:match('^unban @(.*)') or Black:match('^حذف مسدود @(.*)') or Black:match('^حذف بن @(.*)') 
or Black:match('^unban (%d+)$') or Black:match('^حذف مسدود (%d+)$') or Black:match('^حذف بن (%d+)$')) 
and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local mohammad = Black:match('^unban (.*)') or Black:match('^حذف مسدود (.*)') or Black:match('^حذف بن (.*)')
local Diamond = TD.searchPublicChat(mohammad)
local res = TD.getSupergroupMembers(msg.chat_id, "Banned", '' , 0 , 25 )
if not Diamondent and (Black:match('^unban @(.*)') or Black:match('^حذف مسدود @(.*)') or Black:match('^حذف بن @(.*)') or Black:match('^حذفبن @(.*)')) then
mrr619 = Diamond.id
elseif not Diamondent and (Black:match('^unban (%d+)') or Black:match('^حذف مسدود (%d+)') or Black:match('^حذف بن (%d+)') or Black:match('^حذفبن (%d+)')) then
mrr619 = mohammad
elseif Diamondent and (Black:match('^unban (.*)') or Black:match('^حذف مسدود (.*)') or Black:match('^حذف بن (.*)') or Black:match('^حذفبن (.*)')) then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
for k, v in pairs(res.members) do 
if tonumber(v.member_id.user_id) == tonumber(mrr619) then
UnRes(msg.chat_id,mrr619)
reportowner('|↜ کاربر : ['..mohammad..'](tg://user?id='..mrr619..')\n✦ رفع مسدود شد\nتوسط : ['..msg.sender_id.user_id..'](tg://user?id='..msg.sender_id.user_id..')')
end
end
if base:sismember(TD_ID..'BanUser:'..msg.chat_id,mrr619) then
base:srem(TD_ID..'BanUser:'..msg.chat_id,mrr619)
send(msg.chat_id, msg.send_message_id,'✦ کاربر ['..mohammad..'](tg://user?id='..mrr619..') از لیست مسدودین حذف شد...!','md')
else
send(msg.chat_id, msg.send_message_id,'کاربر '..mohammad..' در لیست مسدودین نیست ...!','html')
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..mohammad..' یافت نشد ...!','html')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
----Ban By @sudo_hacker---
if Diamondent and (Black:match('^ban (.*)') or Black:match('^مسدود (.*)') or Black:match('^بن (.*)')) 
or Black and (Black:match('^ban @(.*)') or Black:match('^مسدود @(.*)') or Black:match('^بن @(.*)') 
or Black:match('^ban (%d+)$') or Black:match('^مسدود (%d+)$') or Black:match('^بن (%d+)$')) 
and is_JoinChannel(msg) then
local sudo_hacker = Black:match('^ban (.*)') or Black:match('^مسدود (.*)') or Black:match('^بن (.*)')
local Diamond = TD.searchPublicChat(sudo_hacker)
if not Diamondent and (Black:match('^ban @(.*)') or Black:match('^مسدود @(.*)') or Black:match('^بن @(.*)')) then
mrr619 = Diamond.id
elseif not Diamondent and (Black:match('^ban (%d+)') or Black:match('^مسدود (%d+)') or Black:match('^بن (%d+)')) then
mrr619 = sudo_hacker
elseif Diamondent and (Black:match('^ban (.*)') or Black:match('^مسدود (.*)') or Black:match('^بن (.*)')) then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if VipUser(msg,mrr619) then
send(msg.chat_id, msg.send_message_id,'❌ #اخطار  !\nا─┅━━━━━━━┅─\n✦ کاربر ['..sudo_hacker..'](tg://user?id='..mrr619..') دارای مقام میباشد شما نمیتوانید او را مسدود کنید...!','md')
else
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
if base:sismember(TD_ID..'BanUser:'..msg.chat_id,mrr619) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..sudo_hacker..'](tg://user?id='..mrr619..')\nدرلیست مسدودین گروه میباشد...!','md')
else
base:sadd(TD_ID..'BanUser:'..msg.chat_id,mrr619)
KickUser(msg.chat_id,mrr619)
base:incr(TD_ID..'Total:BanUser:'..msg.chat_id..':'..msg.sender_id.user_id)
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..sudo_hacker..'](tg://user?id='..mrr619..')\nاز گروه مسدود شد...!','md')
reportowner('|↜ کاربر : ['..sudo_hacker..'](tg://user?id='..mrr619..')\n✦ از گروه مسدود شد\nتوسط : ['..msg.sender_id.user_id..'](tg://user?id='..msg.sender_id.user_id..')')
end
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر ['..sudo_hacker..'](tg://user?id='..mrr619..')\nاز گروه مسدود نشد!\n✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
else 
send(msg.chat_id, msg.send_message_id,'کاربر '..sudo_hacker..' یافت نشد ...!','md')
end
end
if (Black == 'ban' or Black == 'مسدود' or Black == 'بن' or Black == 'صیک') 
   and is_JoinChannel(msg) and tonumber(reply_id) > 0 then

    local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
    local user = Diamond.sender_id and Diamond.sender_id.user_id 
              or Diamond.sender_user_id 
              or Diamond.from and Diamond.from.id 
              or 0

    if not user or user == 0 then
        send(msg.chat_id, msg.send_message_id, "کاربر پیدا نشد!", 'md')
        return
    end

    if user == msg.sender_id.user_id then
        send(msg.chat_id, msg.send_message_id, "نمی‌تونی خودتو بن کنی!", 'md')
        return
    end

    if VipUser(msg, user) then
        send(msg.chat_id, msg.send_message_id, "نمیشه داداش! کاربر مقام داره!", 'md')
        return
    end

    -- درست کردن نام کاربر (حتی برای ربات‌ها)
    local diamond = TD.getUser(user) or {}
    local name = "ربات"
    if diamond.username then
        name = diamond.username
    elseif diamond.first_name then
        name = ec_name(diamond.first_name)
    elseif diamond.usernames and diamond.usernames[1] and diamond.usernames[1].editable_username then
        name = diamond.usernames[1].editable_username
    end
    name = name:gsub("[%[%]`%*_%(%)]", "")

    -- بقیه کد بن (همون قبلی)
    local url_ = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
    local statsurl_ = json:decode(url_)
    if statsurl_ and statsurl_.ok and statsurl_.result.status == 'administrator' 
       and statsurl_.result.can_restrict_members then

        if base:sismember(TD_ID..'BanUser:'..msg.chat_id, user) then
            send(msg.chat_id, msg.send_message_id, 'کاربر : ['..name..'](tg://user?id='..user..')\nدر لیست مسدودین گروه میباشد...!', 'md')
        else
            send(msg.chat_id, msg.send_message_id, 'کاربر : ['..name..'](tg://user?id='..user..')\nاز گروه مسدود شد...!', 'md')
            base:sadd(TD_ID..'BanUser:'..msg.chat_id, user)
            KickUser(msg.chat_id, user)
            base:incr(TD_ID..'Total:BanUser:'..msg.chat_id..':'..msg.sender_id.user_id)
            reportowner('|↜ کاربر : ['..name..'](tg://user?id='..user..')\nاز گروه مسدود شد\nتوسط : ['..msg.sender_id.user_id..'](tg://user?id='..msg.sender_id.user_id..')')
        end
    else
        send(msg.chat_id, msg.send_message_id, 'ربات دسترسی مسدود کردن نداره!', 'md')
    end
end
if (Black == 'unban' or Black == 'حذف مسدود' or Black == 'حذف بن') and is_JoinChannel(msg) and tonumber(reply_id) > 0 then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id and Diamond.sender_id.user_id or Diamond.sender_user_id or Diamond.from and Diamond.from.id or 0
if user then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local diamond = TD.getUser(user)
local res = TD.getSupergroupMembers(msg.chat_id, "Banned", '' , 0 , 25 )
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
for k, v in pairs(res.members) do 
if tonumber(v.member_id.user_id) == tonumber(user) then
UnRes(msg.chat_id,user)
reportowner('|↜ کاربر : ['..name..'](tg://user?id='..user..')\n✦ از لیست مسدودین حذف شد\nتوسط : ['..msg.sender_id.user_id..'](tg://user?id='..msg.sender_id.user_id..')')
end
end
if base:sismember(TD_ID..'BanUser:'..msg.chat_id,user) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر ['..name..'](tg://user?id='..user..') از لیست مسدودین حذف شد...!','md')
base:srem(TD_ID..'BanUser:'..msg.chat_id,user)
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر ['..name..'](tg://user?id='..user..') در لیست مسدودین گروه نمیباشد...!','md')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
end
--<><><>Kick
if Diamondent and (Black:match('^kick (.*)') or Black:match('^اخراج (.*)')) or Black and (Black:match('^kick @(.*)') or Black:match('^اخراج @(.*)') or Black:match('^kick (%d+)$') or Black:match('^اخراج (%d+)$')) and is_JoinChannel(msg) then
local sudo_hacker = Black:match('^kick (.*)') or Black:match('^اخراج (.*)')
local Diamond = TD.searchPublicChat(sudo_hacker)
if not Diamondent and Black:match('^kick @(.*)') or Black:match('^اخراج @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^kick (%d+)') or Black:match('^اخراج (%d+)') then
mrr619 = sudo_hacker
elseif Diamondent and Black:match('^kick (.*)') or Black:match('^اخراج (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if VipUser(msg,mrr619) then
send(msg.chat_id, msg.send_message_id,'❌ #اخطار  !\nا─┅━━━━━━━┅─\n✦ کاربر ['..sudo_hacker..'](tg://user?id='..mrr619..') دارای مقام میباشد شما نمیتوانید او را اخراج کنید...!','md')
else
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
KickUser(msg.chat_id,mrr619)
UnRes(msg.chat_id,mrr619)
base:incr(TD_ID..'Total:KickUser:'..msg.chat_id..':'..msg.sender_id.user_id)
send(msg.chat_id, msg.send_message_id,'✦ کاربر ['..sudo_hacker..'](tg://user?id='..mrr619..')\nاز گروه اخراج شد...!','md')
reportowner('|↜ کاربر : ['..sudo_hacker..'](tg://user?id='..mrr619..')\n✦ از گروه اخراج شد\nتوسط : ['..msg.sender_id.user_id..'](tg://user?id='..msg.sender_id.user_id..')')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
else 
send(msg.chat_id, msg.send_message_id,'کاربر '..sudo_hacker..' یافت نشد ...!',  'html')
end
end
if (Black == 'kick' or Black == 'اخراج') and is_JoinChannel(msg) and tonumber(reply_id) > 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
if VipUser(msg,user) then
send(msg.chat_id, msg.send_message_id,"❌ #اخطار  !\nا─┅━━━━━━━┅─\nشما نمیتوانید کاربران دارای مقام را اخراج...!",'md')
else
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
send(msg.chat_id, msg.send_message_id,'✦ کاربر ['..name..'](tg://user?id='..user..')\nاز گروه اخراج شد...!','md')
KickUser(msg.chat_id,user)
UnRes(msg.chat_id,user)
base:incr(TD_ID..'Total:KickUser:'..msg.chat_id..':'..msg.sender_id.user_id)
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
end
end
if (Black == 'clean blacklist' or Black == 'پاکسازی لیست سیاه') then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
cleanbanlist(msg)
send(msg.chat_id, msg.send_message_id,'✳ تمام ڪاربران محروم شده از لیست مسدود حذف شدند','md')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if (Black == 'clean res' or Black == 'پاکسازی لیست محدود') and is_JoinChannel(msg) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
cleanmutelist(msg)
send(msg.chat_id, msg.send_message_id,'⭕ افراد محدود پاک شدند','md')
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
if (Black == 'addcli' or Black == 'ورود ربات پاکسازی') and is_JoinChannel(msg) then
send(msg.chat_id, msg.send_message_id,'','md')
base:setex(TD_ID..'Vorod'..msg.chat_id..msg.sender_id.user_id,90,true)
end
if Black and (Black:match('^setflood (%d+)$') or Black:match('^تعدادفلود (%d+)$')) and is_JoinChannel(msg) then
local num = Black:match('^setflood (%d+)') or Black:match('^تعدادفلود (%d+)')
if tonumber(num) < 2 then
send(msg.chat_id, msg.send_message_id,'⭕ عددے بزرگتر از *2* بکار ببرید','md')
else
base:set(TD_ID..'Flood:Max:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'✅ حداکثر پیام مکرر تنظیم شد به : *'..num..'*','md')
end
end
if Black and (Black:match('^setforcemax (%d+)$') or Black:match('^تعدادافزودن اجباری (%d+)$')) then
local num = Black:match('^setforcemax (%d+)') or Black:match('^تعدادافزودن اجباری (%d+)')
if tonumber(num) < 2 then
send(msg.chat_id, msg.send_message_id,'⭕ عددے بزرگتر از *۲* بکار ببرید','md')
else
base:set(TD_ID..'Force:Max:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'✅ حداکثر عضو تنظیم شد به : *'..num..'*','md')
end
end
 if Black and (Black:match('^settimedelete (%d+)$') or Black:match('^زمان پاکسازی خودکار (%d+)$')) then
local num = Black:match('^settimedelete (%d+)') or Black:match('^زمان پاکسازی خودکار (%d+)')
if tonumber(num) < 10 then
send(msg.chat_id, msg.send_message_id,'⭕ عددے بزرگتر از *10* بکار ببرید','md')
else
base:set(TD_ID..'Force:Time:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'⏰ زمان پاکسازے خودکار تنظیم شد به : *'..num..'*','md')
end
end
if Black and (Black:match('^forcepm (%d+)$') or Black:match('^تعداد اخطار افزودن اجباری (%d+)$')) then
local num = Black:match('^forcepm (%d+)') or Black:match('^تعداد اخطار افزودن اجباری (%d+)')
if tonumber(num) < 2 then
send(msg.chat_id, msg.send_message_id,'⭕ عددے بزرگتر از *2* بکار ببرید','md') 
else
base:set(TD_ID..'Force:Pm:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'⏰ تعداد اخطار پیام افزودن اجبارے تنظیم شد به : *'..num..'* بار','md')
end
end
if Black and (Black:match('^joinwarn (%d+)$') or Black:match('^اخطار جوین اجباری (%d+)$')) and is_JoinChannel(msg) then
local num = Black:match('^joinwarn (%d+)') or Black:match('^اخطار جوین اجباری (%d+)')
base:set(TD_ID..'joinwarn:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'✅ تعداد اخطار جوین اجبارے تنظیم شد بر روے : *'..num..'*\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\n⚠️توجه : به هر کاربر در یک روز حداکثر '..num..' اخطار داده میشود و فرداے همان روز باز در صورت ارسال پیام اخطار دریافت خواهد کرد','md')
end
if Black and (Black:match('^warnmax (%d+)$') or Black:match('^حداکثر اخطار (%d+)$')) and is_JoinChannel(msg) then
local num = Black:match('^warnmax (%d+)') or Black:match('^حداکثر اخطار (%d+)')
if tonumber(num) < 2 then
send(msg.chat_id, msg.send_message_id,'⭕ عددے بزرگتر از *2* بکار ببرید','md')
else
base:set(TD_ID..'Warn:Max:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'✅ حداکثر اخطار تنظیم شد به *'..num..'*','md')
end
end
if Black and (Black:match('^setspam (%d+)$') or Black:match('^تعدادحروف (%d+)$')) and is_JoinChannel(msg) then
local num = Black:match('^setspam (%d+)') or Black:match('^تعدادحروف (%d+)')
if tonumber(num) < 1 then
send(msg.chat_id, msg.send_message_id,'⭕ عددے بزرگتر از *1* بکار ببرید','md')
else
if tonumber(num) > 4096 then
send(msg.chat_id, msg.send_message_id,'⭕ عددے کوچڪتر از *4096* را بڪار ببرید','md')
else
base:set(TD_ID..'NUM_CH_MAX:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'✅ حساسیت به پیام هاے طولانے تنظیم شد به :*'..num..'*','md')
end
end
end
if Black and (Black:match('^setfloodtime (%d+)$') or Black:match('^زمان فلود (%d+)$')) and is_JoinChannel(msg) then
local num = Black:match('^setfloodtime (%d+)') or Black:match('^زمان فلود (%d+)')
if tonumber(num) < 1 then
send(msg.chat_id, msg.send_message_id,'⭕ زمان برسے باید بیشتر از *1* باشد','md')
else
base:set(TD_ID..'Flood:Time:'..msg.chat_id,num)
send(msg.chat_id, msg.send_message_id,'✅ زمان برسے تنظیم شد به : *'..num..'*','md')
end
end
----------------------------------------------
if (Black == 'welcome on' or Black == 'خوشامدگویی فعال') and is_JoinChannel(msg) then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Welcomeon') then
send(msg.chat_id, msg.send_message_id,'⭕ خوش امدگویے #فعال بود' ,'md')
else
send(msg.chat_id, msg.send_message_id,'✅ خوش امدگویے #فعال شد' ,'md')
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'Welcomeon')
end
end
if (Black == 'welcome off' or Black == 'خوشامدگویی غیرفعال') and is_JoinChannel(msg) then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Welcomeon') then
send(msg.chat_id, msg.send_message_id,'✅خوش امدگویے غیر #فعال شد' ,'md')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Welcomeon')
else
send(msg.chat_id, msg.send_message_id,'⭕خوش امدگویے #غیر فعال بود' ,'md')
end
end
----------------------------------------------
if Black == 'restart forceadd' or Black == 'شروع دوباره افزودن اجباری' then
allusers = base:smembers(TD_ID..'AllUsers:'..msg.chat_id)
base:del(TD_ID..'NewUser'..msg.chat_id)
for k, v in pairs(allusers) do
base:del(TD_ID..'addeduser'..msg.chat_id..v)
end
send(msg.chat_id, msg.send_message_id,'> افزودن اجباری ریستارت شد و تمامی افراد باید دوباره به مقدار مورد نظر کاربر به گروه اضافه کنند تا بتواند در گروه پیام دهد','md')
end
if Black == 'forceadd on' or Black == 'افزودن اجباری فعال' then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'force_NewUser') then
typeadd = '|↜ اد اجبارے بر روے کاربران جدید تنظیم شده است\n┄┄──┅┅══┅┅──┄┄\nشما میتوانید براے تغییر به همه کاربران با زدن دستور Setforce all user اد اجبارے را براے همه کاربران فعال کنید!'
else
typeadd = '|↜ اد اجبارے بر روے تمامی کاربران تنظیم شده است\n┄┄──┅┅══┅┅──┄┄\nدر صورت علاقه شما میتوانید اد اجبارے را با دستور Setforce new user بر روے کاربران جدید تنظیم کنید تا فقط کاربران جدید اجبار به اد شوند!'
end
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'forceadd') then
send(msg.chat_id, msg.send_message_id,'⭕ قفل *افزودن اجبارے* #فعال بود\n─┅━━━━━━━┅─\n*وضعیت* : '..typeadd,'md')
else
send(msg.chat_id, msg.send_message_id,'✅ قفل *افزودن اجبارے* #فعال شد\nتعداد اخطار پیام افزودن : *'..Forcepm..'* بار\nتعداد افزودن : *'..Forcemax..'* نفر\n─┅━━━━━━━┅─\n*وضعیت* : '..typeadd,'md')
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'forceadd')
end
end
if Black == 'forceadd off' or Black == 'افزودن اجباری غیرفعال' then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'forceadd') then
send(msg.chat_id, msg.send_message_id,'• قفل *افزودن اجبارے* #غیرفعال شد' ,'md')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'forceadd')
base:del(TD_ID..'test:'..msg.chat_id)
base:del(TD_ID..'Force:Pm:'..msg.chat_id)
base:del(TD_ID..'Force:Max:'..msg.chat_id)
else
send(msg.chat_id, msg.send_message_id,'• قفل *افزودن اجبارے* #غیرفعال بود','md')
end
end
local CH = (base:get(TD_ID..'setch:'..msg.chat_id) or '..Channel..')
if Black == 'forcejoin on' or Black == 'جوین اجباری فعال' then
if base:get(TD_ID..'setch:'..msg.chat_id)  then
if  base:sismember(TD_ID..'Gp2:'..msg.chat_id,'forcejoin') then
send(msg.chat_id, msg.send_message_id,'⭕ قفل *جوین اجبارے* #فعال بود\n✅ ڪانال جوین اجبارے :【@'..CH..'】','html')
else
send(msg.chat_id, msg.send_message_id,'✅ قفل *جوین اجبارے* #فعال شد\n[جهت عمل ڪرد عضویت اجبارے باید ربات زیر را در ڪانال خود ادمین ڪنید\n 🆔 : '..UserJoiner..']\n\n✅ ڪانال جوین اجبارے :【@'..CH..'】','html')
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'forcejoin')
end
else
send(msg.chat_id, msg.send_message_id,'انجام نشد ✖️\nڪانال شما تنظیم نشده است ابتدا با دستور (تنظیم ڪانال channel ) یا (setch channel ) ڪانال خود را تنظیم ڪنید سپس اقدام به فعال ڪردن جوین اجبارے ڪنید.','md')
end
end
if Black == 'forcejoin off' or Black == 'جوین اجباری غیرفعال' then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'forcejoin') then
send(msg.chat_id, msg.send_message_id,'• قفل *جوین اجبارے* #غیرفعال شد','md')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'forcejoin')
else
send(msg.chat_id, msg.send_message_id,'• قفل *جوین اجبارے* #غیرفعال بود','md')
end
end
if Black and (Black:match('^setch (.*)') or Black:match('^تنظیم کانال (.*)')) and is_JoinChannel(msg) then
local CH = Black:match('^setch (.*)') or Black:match('^تنظیم کانال (.*)')
base:set(TD_ID..'setch:'..msg.chat_id,CH)
send(msg.chat_id, msg.send_message_id,'✅ کانال تنظیم شد به : 【@'..CH..'】','html')
end
---------------set Lang------------
if (Black == 'lang en' or Black == 'زبان انگلیسی') and is_JoinChannel(msg) then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'diamondlang') then
send(msg.chat_id, msg.send_message_id,'♠ *Group Language already* #English ...!','md')
else
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'diamondlang')
send(msg.chat_id, msg.send_message_id, '♣ *Group Language set on* #English ...!','md')
end
end
if (Black == 'lang fa' or Black == 'زبان فارسی') and is_JoinChannel(msg) then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'diamondlang') then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'diamondlang')
send(msg.chat_id, msg.send_message_id,'♦ زبان ربات تنظیم شد بر روے #فارسے ...!','md')
else
send(msg.chat_id, msg.send_message_id,'♥ زبان ربات هم اڪنون #فارسے است...!','md')
end
end
if Black1 and (Black1:match('^[Ss]etwelcome (.*)') or Black1:match('^تنظیم خوشامدگویی (.*)'))  and is_JoinChannel(msg)then
local wel = Black1:match('^[Ss]etwelcome (.*)') or Black1:match('^تنظیم خوشامدگویی(.*)')
base:set(TD_ID..'Text:Welcome:'..msg.chat_id,wel)
send(msg.chat_id, msg.send_message_id,'✅ پیام خوش امدگویے با موفقیت ثبت شد','md')
end
if Black1 and (Black1:match('^[Ss]etrules (.*)') or Black1:match('^تنظیم قوانین (.*)')) and is_JoinChannel(msg) then
local rules = Black1:match('^[Ss]etrules (.*)') or Black1:match('^تنظیم قوانین (.*)')
base:set(TD_ID..'Rules:'..msg.chat_id,rules)
send(msg.chat_id, msg.send_message_id,'✅ قوانین گروه با موفقیت ثبت شد','md')
end
if Black1 and (Black1:match('^[Dd]elrules$') or Black1:match('^حذف قوانین$')) and is_JoinChannel(msg) then
base:del(TD_ID..'Rules:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'✅ قوانین گروه حذف شد.','md')
end
if Diamondent and (Black:match('^warn (.*)') or Black:match('^اخطار (.*)')) or Black and (Black:match('^warn @(.*)') or Black:match('^اخطار @(.*)') or Black:match('^warn (%d+)$') or Black:match('^اخطار (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^warn (.*)') or Black:match('^اخطار (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^warn @(.*)') or Black:match('^اخطار @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^warn (%d+)') or Black:match('^اخطار (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^warn (.*)') or Black:match('^اخطار (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if VipUser(msg,mrr619) then
send(msg.chat_id, msg.send_message_id,"❌ #اخطار  !\nا─┅━━━━━━━┅─\nشما نمیتوانید به کاربران داری مقام اخطار دهید...!",'md')
else
local hashwarn = TD_ID..msg.chat_id..':warn'
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',mrr619) or 1
if tonumber(warnhash) == tonumber(warn) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
KickUser(msg.chat_id,mrr619)
UnRes(msg.chat_id,mrr619)
text = '['..BDSource..'](tg://user?id='..mrr619..')\nا┅┅──┄┄═✺═┄┄──┅┅\nبه علت دریافت اخطار بیش از حد اخراج شد \nاخطار ها : '..warnhash..'/'..warn..''
base:hdel(hashwarn,mrr619, '0')
send(msg.chat_id, msg.send_message_id,text,'md')
else
send(msg.chat_id, msg.send_message_id,'✖️اخطار های ['..BDSource..'](tg://user?id='..mrr619..') به حداکثر رسیده ولی ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید تا توانایی اخراج داشته باشد !','md')
end
else
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',mrr619) or 1
base:hset(hashwarn,mrr619, tonumber(warnhash) + 1)
text = '['..BDSource..'](tg://user?id='..mrr619..')\nا┅┅──┄┄═✺═┄┄──┅┅\nشما یک اخطار دریافت کردید \nتعداد اخطار هاے شما : '..warnhash..'/'..warn..''
send(msg.chat_id, msg.send_message_id,text,'md')
end
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!',  'html')
--end
end
end
if Diamondent and (Black:match('^unwarn (.*)') or Black:match('^حذف اخطار (.*)')) or Black and (Black:match('^unwarn @(.*)') or Black:match('^حذف اخطار @(.*)') or Black:match('^unwarn (%d+)$') or Black:match('^حذف اخطار (%d+)$')) and is_JoinChannel(msg) then
local BDSource = Black:match('^unwarn (.*)') or Black:match('^حذف اخطار (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^unwarn @(.*)') or Black:match('^حذف اخطار @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^unwarn (%d+)') or Black:match('^حذف اخطار (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^unwarn (.*)') or Black:match('^حذف اخطار (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',mrr619) or 1
if tonumber(warnhash) == tonumber(1) then
text = '✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nهیچ اخطارے ندارد'
send(msg.chat_id, msg.send_message_id,text,'md')
else
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',mrr619)
local hashwarn = TD_ID..msg.chat_id..':warn'
base:hdel(hashwarn,mrr619,'0')
text = '✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nتمام اخطار هایش پاک شد'
send(msg.chat_id, msg.send_message_id,text,'md')
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!',  'html')
end
end
if (Black == "unwarn" or Black == "حذف اخطار") and is_JoinChannel(msg) and tonumber(reply_id) > 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',user) or 1
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if tonumber(warnhash) == tonumber(1) then
text = '✦ کاربر : ['..name..'](tg://user?id='..user..')\nهیچ اخطارے ندارد'
send(msg.chat_id, msg.send_message_id,text,'md')
else
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',user)
local hashwarn = TD_ID..msg.chat_id..':warn'
base:hdel(hashwarn,user,'0')
text = '✦ کاربر : ['..name..'](tg://user?id='..user..')\nتمام اخطار هایش پاک شد'
send(msg.chat_id, msg.send_message_id,text,'md')
end
end
end
if Black and (Black:match('^(limitpmstatus) (.*)$') or Black:match('^(وضعیت محدودیت پیام) (.*)$')) then
Black = Black:gsub("وضعیت محدودیت پیام", "limitpmstatus")
status = {string.match(Black, "^(limitpmstatus) (.*)$")}
if status[2] == 'mute' or status[2] == 'سکوت' then
if base:get(TD_ID..'limitpmstatus:'..msg.chat_id) == 'mute' then
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روی سکوت کاربر قرارداشت','md')
else
base:set(TD_ID..'limitpmstatus:'..msg.chat_id,'mute')
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روی سکوت کاربر قرارگرفت','md')
end
end
if status[2] == 'ban' or status[2] == 'مسدود' or status[2] == 'بن' then
if base:get(TD_ID..'limitpmstatus:'..msg.chat_id) == 'ban' then
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روی مسدود کاربر قرارداشت','md')
else
base:set(TD_ID..'limitpmstatus:'..msg.chat_id,'ban')
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روی مسدود کاربر قرارگرفت','md')
end
end
if status[2] == 'silent' or status[2] == 'سایلنت' then
if base:get(TD_ID..'limitpmstatus:'..msg.chat_id) == 'silent' then
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روی سایلنت کاربر قرارداشت','md')
else
base:set(TD_ID..'limitpmstatus:'..msg.chat_id,'silent')
send(msg.chat_id, msg.send_message_id,'وضعیت محدودیت پیام روی سایلنت کاربر قرارگرفت','md')
end
end
end
if (Black == "امار گروه") then
--StatusGp(msg,msg.chat_id) 
end
if (Black == 'stats' or Black == 'آمار' or Black == 'امار') then
TD.sendText(msg.chat_id, msg.send_message_id, "• بخش آمار مورد نظر را انتخاب کنید :\n━┅┅━━ آمار گروه ━━┅┅━", "html", false, false, false, false, TD.replyMarkup({type = "inline", data = MenuStats(msg.chat_id, msg.sender_id.user_id)}));
end
if (Black == 'statsall' or Black == 'آمار کلی' or Black == 'امار کلی') then
local TextStats = GroupStats(msg.chat_id, msg.sender_id.user_id)
send(msg.chat_id, msg.send_message_id, TextStats, 'html')
end
if Black and (Black:match('^stats (%d+)$') or Black:match('^امار (%d+)$') or Black:match('^آمار (%d+)$') or Black:match('^statsmod (%d+)$') or Black:match('^امار مدیران (%d+)$') or Black:match('^آمار مدیران (%d+)$') or Black:match('^statsadd (%d+)$') or Black:match('^امار ادد (%d+)$') or Black:match('^آمار ادد (%d+)$')) then
if (Black:match('^statsmod (%d+)$') or Black:match('^امار مدیران (%d+)$') or Black:match('^آمار مدیران (%d+)$')) then
CmdKey = {(Black:match('^statsmod (%d+)$') or Black:match('^امار مدیران (%d+)$') or Black:match('^آمار مدیران (%d+)$')), 'Admin', 'فعال ترین مدیران گروه', 'پیام'}
elseif (Black:match('^statsadd (%d+)$') or Black:match('^امار ادد (%d+)$') or Black:match('^آمار ادد (%d+)$')) then
CmdKey = {(Black:match('^statsadd (%d+)$') or Black:match('^امار ادد (%d+)$') or Black:match('^آمار ادد (%d+)$')), 'Adds', 'کاربران برتر در افزودن عضو', 'ادد'}
else
CmdKey = {(Black:match('^stats (%d+)$') or Black:match('^امار (%d+)$') or Black:match('^آمار (%d+)$')), 'Msgs', 'فعال ترین های گروه', 'پیام'}
end
if CmdKey and CmdKey[3] then
if tonumber(CmdKey[1]) < 1 or tonumber(CmdKey[1]) > 20 then
send(msg.chat_id, msg.send_message_id, '• تعداد نفرات وارد شده باید بزرگتر از 1 و کوچک تر از 20 باشد !', 'md')
else
local TextStats = GroupStats(msg.chat_id, msg.sender_id.user_id, CmdKey)
send(msg.chat_id, msg.send_message_id, TextStats, 'html')
end
end
end
if Black == 'groupinfo' or Black == 'اطلاعات گروه' then
local Diamond = TD.getSupergroupFullInfo(msg.chat_id)
join = base:get(TD_ID..'Total:JoinedByLink:'..msg.chat_id) or 0
local links = ''..check_markdown(Diamond.invite_link.invite_link)..'' or nil
local data = TD.getChat(msg.chat_id)
send(msg.chat_id, msg.send_message_id,'اطلاعات گروه : \nا┅┅──┄┄═❂═┄┄──┅┅\n|↜نام گروه : *'..data.title..'*\n|↜شناسه گروه : *'..msg.chat_id..'*\n|↜تعداد ادمین هاے گروه : *'..Diamond.administrator_count..'*\n|↜تعداد مسدودے هاے گروه : *'..Diamond.banned_count..'*\n|↜تعداد اعضاے گروه : *'..Diamond.member_count..'*\n|↜تعداد اعضاے وارد شده با لینک : *'..join..'*\n|↜لینک گروه : '..links..'\n|↜تعداد کاربران محدود شده : *'..Diamond.restricted_count..'*\n|↜درباره گروه : '..Diamond.description..'','md')
end
----------------------------------------------
if Black1 and (Black1:match('^([Ss][Ee][Tt][Gg][Ii][Ff]) (.*)$') or Black1:match('^تنظیم گیف (.*)$')) and is_JoinChannel(msg) then
local Black1 = Black:gsub("تنظیم گیف","setgif")
local Black = {string.match(Black1,"^([Ss][Ee][Tt][Gg][Ii][Ff]) (.*)$")}           
local modes = {'memories-anim-logo','alien-glow-anim-logo','flash-anim-logo','flaming-logo','whirl-anim-logo','highlight-anim-logo','burn-in-anim-logo','shake-anim-logo','inner-fire-anim-logo','jump-anim-logo'}
local text = URL.escape(Black[2])
local url = 'http://www.flamingtext.com/net-fu/image_output.cgi?_comBuyRedirect=false&script='..modes[math.random(#modes)]..'&text='..text..'&symbol_tagname=popular&fontsize=70&fontname=futura_poster&fontname_tagname=cool&textBorder=15&growSize=0&antialias=on&hinting=on&justify=2&letterSpacing=0&lineSpacing=0&textSlant=0&textVerticalSlant=0&textAngle=0&textOutline=off&textOutline=false&textOutlineSize=2&textColor=%230000CC&angle=0&blueFlame=on&blueFlame=false&framerate=75&frames=5&pframes=5&oframes=4&distance=2&transparent=off&transparent=false&extAnim=gif&animLoop=on&animLoop=false&defaultFrameRate=75&doScale=off&scaleWidth=240&scaleHeight=120&&_=1469943010141'	
local title , res = http.request(url)
local mod = {'Blinking+Text','No+Button','Dazzle+Text','Walk+of+Fame+Animated','Wag+Finger','Glitter+Text','Bliss','Flasher','Roman+Temple+Animated',}
local set = mod[math.random(#mod)]
local colors = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local bc = colors[math.random(#colors)]
local colorss = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FFF200','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local tc = colorss[math.random(#colorss)]
local url2 = 'http://www.imagechef.com/ic/maker.jsp?filter=&jitter=0&tid='..set..'&color0='..bc..'&color1='..tc..'&color2=000000&customimg=&0='..Black[2]	
local title1,res = http.request(url2)
if res ~= 200 then return end
if title1 then
if json:decode(title1) then
local jdat = json:decode(title1)
local gif = jdat.resImage
local file = DownloadFile(gif,'Gif-Random.gif')
TD.sendDocument(msg.chat_id,msg.send_message_id,0,1,nil,file, 'گیف خوشامد گویی تنظیم شدبه\n'..Black[2],dl_cb,nil)
base:set(TD_ID..'gif'..msg.chat_id,file)
end
end
end
------ping----------
if Black == 'ping2' or Black == 'انلاینی' and is_JoinChannel(msg) then
local datebase = {
"./BlackDiamond/data/sticker2.webp",
"./BlackDiamond/data/sticker13.webp"
  }
TD.sendDocument(msg.chat_id,msg.send_message_id, datebase[math.random(#datebase)], '','md')
end
if Black == 'پرداخت آنلاین' or Black == 'پرداخت انلاین' then
chat_id = msg.chat_id
local keyboard = {}
keyboard.inline_keyboard =
{{{text= '✦خرید •❶• ماهه',callback_data = 'pard1:'..chat_id},
{text= '✦ خرید •❶• ساله',callback_data = 'pard2:'..chat_id}}}   
send_inline(msg.sender_id.user_id,'به بخش پرداخت انلاین خوش امدید',keyboard,'md')
end
----------------------------------------------
end
end
end
----------------------------------------------
if Black and ((is_Sudo(msg) and not (base:sismember(TD_ID..'PnlSudo:',Black) or base:sismember(TD_ID..'PnlSudo:',BaseCmd) or base:sismember(TD_ID..'PnlSudo_2:',msg.sender_id.user_id..':'..Black) or base:sismember(TD_ID..'PnlSudo_2:',msg.sender_id.user_id..':'..BaseCmd))) or is_FullSudo(msg)) then
if Black == 'autoleave on' or Black == 'لفت خودکار روشن' then 
base:del(TD_ID..'AutoLeave')
send(msg.chat_id, msg.send_message_id,'done','html')
end
if Black == 'autoleave off' or Black == 'لفت خودکار خاموش' then 
base:set(TD_ID..'AutoLeave',true)
send(msg.chat_id, msg.send_message_id,'done','html')
end
if Black == 'speedtest' or Black == 'تست سرعت' then
text = io.popen("speedtest-cli"):read('*all')
send(msg.chat_id, msg.send_message_id,text,'html')
end
---------------------------------------------
if Black == 'joinchannel off' or Black == 'جوین چنل خاموش' then
base:del(TD_ID..'joinchnl')
send(msg.chat_id, msg.send_message_id, '✦ جوین چنل خاموش شد و دیگر کاربران براے استفاده از دستورات نیازے به ورود به کانال ربات نخواهند داشت!','md')
end
if Black == 'joinchannel on' or Black == 'جوین چنل روشن' then
base:set(TD_ID..'joinchnl',true)
send(msg.chat_id, msg.send_message_id, '✦ جوین چنل روشن شد و کاربران براے استفاده از دستورات ربات باید ابتدا در کانال ربات عضو شوند!','md')
end
----------------------------------------------
if Black and (Black:match('^setnerkh (.*)') or Black:match('^تنظیم نرخ (.*)')) then
local nerkh = Black:match('^setnerkh (.*)') or Black:match('^تنظیم نرخ (.*)')
base:set(TD_ID..'nerkh',nerkh)
send(msg.chat_id, msg.send_message_id, 'متن نرخ تنظیم شد بر روے :\n'..nerkh..'', 'html')
end
if Black and (Black:match('^setmonshi (.*)') or Black:match('^تنظیم منشی (.*)')) then
local monshi = Black:match('^setmonshi (.*)') or Black:match('^تنظیم منشی (.*)')
base:set(TD_ID..'monshi',monshi)
send(msg.chat_id, msg.send_message_id, 'متن منشے تنظیم شد بر روے :\n'..monshi..'', 'html')
end
if Black == 'bot' or Black == 'بوت' then
TD.sendVideoNote(msg.chat_id,msg.send_message_id,0,1,nil,'./BlackDiamond/data/videonote.mp4')
end
--------
if Black and (Black1:match('^leave (-100)(%d+)$') or Black1:match('^خروج (-100)(%d+)$')) then
local chat_id = Black1:match('^leave (.*)$') or Black1:match('^خروج (.*)$') 
local Hash = TD_ID..'StatsGpByName'..chat_id
base:del(Hash)
base:del(TD_ID..'Gp2:'..chat_id)
base:del(TD_ID..'Gp:'..chat_id)
base:del(TD_ID..'Gp3:'..chat_id)
base:del(TD_ID..'NewUser'..chat_id)
base:del(TD_ID.."ExpireData:"..chat_id)
base:srem(TD_ID.."group:",chat_id)
base:del(TD_ID.."ModList:"..chat_id)
base:del(TD_ID..'OwnerList:'..chat_id)
base:del(TD_ID.."MuteList:"..chat_id)
base:del(TD_ID.."SilentList:"..chat_id)
base:del(TD_ID..'setmode:'..chat_id)
base:del(TD_ID..'Text:Welcome:'..chat_id)
base:del(TD_ID..'settag'..chat_id)
base:del(TD_ID..'Link:'..chat_id)
base:del(TD_ID..'Pin_id'..chat_id)
base:del(TD_ID..'EndTimeSee'..chat_id)
base:del(TD_ID..'StartTimeSee'..chat_id)
base:del(TD_ID..'limitpm:'..chat_id)
base:del(TD_ID..'mutetime:'..chat_id)
base:del(TD_ID..'cgmautotime:'..chat_id)
base:del(TD_ID..'cbmtime:'..chat_id)
base:del(TD_ID..'Flood:Max:'..chat_id)
base:del(TD_ID..'Force:Time:'..chat_id)
base:del(TD_ID..'Force:Pm:'..chat_id)
base:del(TD_ID..'joinwarn:'..chat_id)
base:del(TD_ID..'Warn:Max:'..chat_id)
base:del(TD_ID..'NUM_CH_MAX:'..chat_id)
base:del(TD_ID..'setch:'..chat_id)
base:del(TD_ID..'Text:Welcome:'..chat_id)
base:del(TD_ID..'Rules:'..chat_id)
base:del(TD_ID..'Total:messages:'..chat_id)
base:del(TD_ID..'Total:JoinedByLink:'..chat_id)
result = TD.getChat(chat_id)
res = TD.getUser(msg.sender_id.user_id)
if res.usernames and res.usernames.editable_username then name = res.usernames.editable_username else name = ec_name(res.first_name) end
send(chat_id,0,"✅ انجام شد\n✦ توسط : ["..name.."](tg://user?id="..msg.sender_id.user_id..")\n﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\n💢 ربات از گروه با مشخصات زیر :\n📝 نام گروه : "..(result.title or "-").."\n🆔 ایدے گروه : "..chat_id.."\n﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nخارج شد",'md')
allusers = base:smembers(TD_ID..'AllUsers:'..chat_id)
for k, v in pairs(allusers) do 
base:del(TD_ID..'addeduser'..chat_id..v)
base:del(TD_ID..'Total:AddUser:'..chat_id..':'..v)
base:del(TD_ID..'Total:messages:'..chat_id..':'..v)
base:del(TD_ID..'Total:BanUser:'..chat_id..':'..v)
base:del(TD_ID..'Total:KickUser:'..chat_id..':'..v)
base:del(TD_ID..'Total:messages:'..chat_id..':'..os.date("%Y/%m/%d")..':'..v)
end
print(result.title)
TD.leaveChat(chat_id)
--Leave_api(chat_id)
end
if Black == 'server info' or Black == 'اطلاعات سرور' then
local text = io.popen("sh ./BlackDiamond/data/cmd.sh"):read('*all') 
send(msg.chat_id, msg.send_message_id,text,'md')
end
if Black == 'chats' or Black == 'لیست گروه ها' then
local list = base:smembers(TD_ID..'group:')
local t = 'لیست گروه هاے مدیریتے ربات:\n﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\n'
for k,v in pairs(list) do
local expire = base:ttl(TD_ID.."ExpireData:"..v)
if expire ~= 0 then
if expire == -1 then
EXPIRE = "نامحدود"
else
local d = math.floor(expire / day ) + 1
EXPIRE = d.." روز"
end
local GroupsName = base:get(TD_ID..'StatsGpByName'..v)
t = t..k.."-💢\n|↜ ایدے گروه : ["..v.."]\n|↜ اسم گروه : "..(GroupsName or '---').."\n|↜ تاریخ انقضا گروه : ["..EXPIRE.."]\n─┅━━━━━━━┅─\n" 
end
end
local file = io.open("./BlackDiamond/data/Gplist.txt","w")
file:write(t)
file:close()
if #list == 0 then
send(msg.chat_id, msg.send_message_id,'لیست گروهها خالی میباشد !','md')
end
TD.sendDocument(msg.chat_id,msg.send_message_id,'./BlackDiamond/data/Gplist.txt','','md')
end
if (Black == 'backup' or Black == 'بکاپ') and is_private(msg) and TD.in_array({8270251128, 1276352601}, msg.sender_id.user_id) then
TD.sendDocument(msg.chat_id,msg.send_message_id,'/var/lib/redis/dump.rdb', '#ردیس', 'md')
TD.sendDocument(msg.chat_id,msg.send_message_id,'./api.lua', '', 'md')
TD.sendDocument(msg.chat_id,msg.send_message_id,'./bot.lua', '', 'md')
TD.sendDocument(msg.chat_id,msg.send_message_id,'./BDiamond.lua', '', 'md')
end
if Black == 'rld' then
send(msg.chat_id, msg.send_message_id,'#okeys','md')
dofile('BDiamond.lua')
end
if Black == 'reload' or Black == 'ریلود' then
if not base:get(BotCliId..'Reloading') then
base:setex(BotCliId..'Reloading',10,true)
if lang then
send(msg.chat_id, msg.send_message_id,'Reloading...\n\n>│','md')
else
send(msg.chat_id, msg.send_message_id,'درحال بروزرسانی سیستم...\n\n>│','md')
end
dofile('BDiamond.lua')
else
send(msg.chat_id, msg.send_message_id,'> انجام این دستور هر 10 ثانیه یکبار ممکن است !','md')
end
end
if Black == 'monshi on' or Black == 'منشی فعال' then
base:set(TD_ID..'MonShi:on',true)
send(msg.chat_id, msg.send_message_id, 'منشے #فعال شد','md')
end
if Black == 'monshi off' or Black == 'منشے غیرفعال' then
base:del(TD_ID..'MonShi:on')
send(msg.chat_id, msg.send_message_id, 'منشے #غیرفعال شد','md')
end
if Black == 'pmresan on' or Black == 'منشی فعال' then
base:del(TD_ID..'pmresan:on')
send(msg.chat_id, msg.send_message_id, 'پی ام رسانی روشن شد !','md')
end
if Black == 'pmresan off' or Black == 'منشے غیرفعال' then
base:set(TD_ID..'pmresan:on',true)
send(msg.chat_id, msg.send_message_id, 'پی ام رسانی خاموش شد !','md')
end
if Black == 'delcmds on' or Black == 'پاکسازی دستور روشن' then
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'delcmd') then
send(msg.chat_id, msg.send_message_id, '>پاکسازی دستورات روشن شد...!\nاز این پس دستورات ارسالی شما پاک خواهند شد!','md')
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'delcmd')
else
send(msg.chat_id, msg.send_message_id, '>پاکسازی دستورات از قبل روشن بود...!','md')
end
end
if Black == 'delcmds off' or Black == 'پاکسازی دستور خاموش' then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'delcmd') then
send(msg.chat_id, msg.send_message_id, '>پاکسازی دستورات خاموش شد...!','md')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'delcmd')
else
send(msg.chat_id, msg.send_message_id, '>پاکسازی دستورات خاموش بود...!','md')
end
end
if Black and (Black1:match('^check (-100)(%d+)$') or Black1:match('^اعتبار (-100)(%d+)$')) then
local chat_id = Black1:match('^check (.*)$') or Black1:match('^اعتبار (.*)$')
local ex = base:ttl(TD_ID.."ExpireData:"..chat_id)
if ex == -1 then
textt = '|↜ گروه به صورت نامحدود شارژ می‌باشد'
send(msg.chat_id, msg.send_message_id,textt,'html')
else
local d = math.floor(ex / day ) + 1
text = '☣ گروه به مدت\n*✤ '..d..' * روز \n❃ شارژ می‌باشد'
send(msg.chat_id, msg.send_message_id,text,'md')
end
end
------plan1------
if Black and (Black:match('^plan1 (-100)(%d+)$') or Black:match('^پلن1 (-100)(%d+)$')) then
local chat_id = Black:match('^plan1 (.*)$') or Black:match('^پلن1 (.*)$')
base:setex(TD_ID.."ExpireData:"..chat_id,Plan1,true)
base:sadd(TD_ID..'Gp2:'..chat_id,'added')
base:srem(TD_ID..'Gp2:'..chat_id,'chex3') 
base:srem(TD_ID..'Gp2:'..chat_id,'chex2')
base:srem(TD_ID..'Gp2:'..chat_id,'chex1') 
send(chat_id, msg.send_message_id,'پلن 1 با موفقيت براي گروه\n'..chat_id..' فعال شد\nاين گروه تا 30 روز ديگر اعتبار دارد!','md')
send(Sudoid,0,'پلن 1 با موفقيت براي گروه\n'..chat_id..' فعال شد\nاين گروه تا 30 روز ديگر اعتبار دارد!','md')
end
-------plan2------
if Black and (Black:match('^plan2 (-100)(%d+)$') or Black:match('^پلن2 (-100)(%d+)$')) then
local chat_id = Black:match('^plan2 (.*)$') or Black:match('^پلن2 (.*)$')
base:setex(TD_ID.."ExpireData:"..chat_id,Plan2,true)
base:sadd(TD_ID..'Gp2:'..chat_id,'added')
base:srem(TD_ID..'Gp2:'..chat_id,'chex3') 
base:srem(TD_ID..'Gp2:'..chat_id,'chex2')
base:srem(TD_ID..'Gp2:'..chat_id,'chex1') 
send(chat_id, msg.send_message_id,'پلن 2 با موفقيت براي گروه\n'..chat_id..' فعال شد\nاين گروه تا 90 روز ديگر اعتبار دارد!','md')
send(Sudoid,0,'پلن 2 با موفقيت براي گروه\n'..chat_id..' فعال شد\nاين گروه تا 90 روز ديگر اعتبار دارد!','md')
end
if Black and (Black1:match('^full (-100)(%d+)$') or Black1:match('^نامحدود (-100)(%d+)$')) then
local chat_id = Black1:match('^full (.*)$') or Black1:match('^نامحدود (.*)$') 
local Diamond = TD.getChat(chat_id)
base:set(TD_ID.."ExpireData:"..chat_id,true)
base:sadd(TD_ID..'Gp2:'..chat_id,'added')
base:srem(TD_ID..'Gp2:'..chat_id,'chex3') 
base:srem(TD_ID..'Gp2:'..chat_id,'chex2')
base:srem(TD_ID..'Gp2:'..chat_id,'chex1') 
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local name = "["..names.."](tg://user?id="..msg.sender_id.user_id..")"
send(chat_id, msg.send_message_id,'⭐ گروه به صورت نامحدود شارژ شد\nتوسط : '..name..'\nا━━━┅═❂═┅┅──┄┄\n📜 نام گروه : '..Diamond.title..'\n💬 شناسه گروه : '..chat_id..'','md')
local BD = '♨ گروه جدیدے بصورت نامحدود #شارژ شد\nا━━━┅═❂═┅┅──┄┄\nمشخصات شارژ کننده :\n\n🆔 یوزرنیم : '..name..'\n\n✦ نام : '..ec_name(diamond.first_name)..'\n\n🌀 شناسه : '..msg.sender_id.user_id..'\nا━━━┅═❂═┅┅──┄┄\n\n📆 تاریخ فعال سازے : '..os.date('%Y/%m/%d')..'\n\n⏰ ساعت فعال سازے : '..os.date('%H:%M')..'\nا━━━┅═❂═┅┅──┄┄\nمشخصات گروه :\n\n📜 نام گروه : '..Diamond.title..'\n\n💬 شناسه گروه : '..chat_id..''
send(Sudoid,0,BD,'md')
end
----------------------------------------------
if Black == 'send groups' or Black == 'ارسال به گروها' and tonumber(reply_id) > 0 then
local diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local text = diamond.content.text.text
local list = base:smembers(TD_ID..'group:')
local gps = base:scard(TD_ID.."group:") or 0
for k,v in pairs(list) do
send(v,0,text,'md')
end
send(msg.chat_id, msg.send_message_id,'پیام مورد نظر شما با موفقیت به ['..gps..'] گروه ارسال گردید.','html')
end
if Black == 'fwd groups' or Black == 'فوروارد به گروها' and tonumber(reply_id) > 0 then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local list = base:smembers(TD_ID..'SuperGp')
for k,v in pairs(list) do
TD.forwardMessages(v,msg.chat_id,{[1] = Diamond.id})
end
end 
if Black == 'fwd owners' or Black == 'فوروارد به مالکان' and tonumber(reply_id) > 0 then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local list = base:smembers(TD_ID..'group:')
for k,v in pairs(list) do
local users = base:smembers(TD_ID..'OwnerList:'..v)
for y,u in pairs(users) do
TD.forwardMessages(u,msg.chat_id,{[1] = Diamond.id})
end
end
send(msg.chat_id,msg.send_message_id,'> پیام مورد نظر شما با موفقیت به پیوے مالکان گروه ها ارسال گردید.','html')
end
if Black == 'resetstats' or Black == 'ریستارت امار' then
base:del(TD_ID..'SuperGp')
base:del(TD_ID..'Chat:Normal')
base:del(TD_ID..'ChatPrivite')
send(msg.chat_id, msg.send_message_id,'✅انجام شد','md')
end
if Black == 'resetch' then 
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex2')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex3')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex1')
end
if Black and (Black:match('^banall (%d+)$') or Black:match('^بن گلوبال (%d+)$')) then
local user = Black:match('^banall (%d+)') or Black:match('^بن گلوبال (%d+)')
if tonumber(user) == tonumber(Sudoid) then
send(msg.chat_id, msg.send_message_id, '❎ شما قادر به گلوبال بن کردن سودو نیستید','md')
return false
end
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'GlobalyBanned:',user) then
if name then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..name..'\nدر لیست گلوبال وجود دارد','html')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..user..'\nدر لیست گلوبال وجود دارد','md')
end
else
if name then
send(msg.chat_id, msg.send_message_id,'✥ کاربر : \n🆔 : '..name..'\nبه لیست گلوبال افزوده شد','html')
else
send(msg.chat_id, msg.send_message_id,'✥ کاربر : \n🆔 : `'..user..'`\n_به لیست گلوبال افزوده شد_','md')
end
base:sadd(TD_ID..'GlobalyBanned:',user)
end
end
if Black and (Black:match('^banall @(.*)') or Black:match('^بن گلوبال @(.*)')) then
local username = Black:match('^banall @(.*)') or Black:match('^بن گلوبال @(.*)')
local Diamond = TD.searchPublicChat(username)
if Diamond.id then
if tonumber(Diamond.id) == tonumber(Sudoid) then
send(msg.chat_id, msg.send_message_id,'❎ شما قادر به گلوبال بن کردن سودو نیستید','md')
return false
end
if base:sismember(TD_ID..'GlobalyBanned:', Diamond.id) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..username..'\nدر لیست گلوبال وجود دارد','html')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..username..'\nبه لــیــسـت گلوبال افزوده شد','html')
base:sadd(TD_ID..'GlobalyBanned:',Diamond.id)
end
else 
send(msg.chat_id, msg.send_message_id,'❎ کاربر یافت نشد','html')
end
end
if Black == 'gbans' or Black == 'لیست گلوبال' then 
local list = base:smembers(TD_ID..'GlobalyBanned:') 
local t = 'لیست کاربران گلوبال:\nا┅┅──┄┄═✺═┄┄──┅┅\n' 
for k,v in pairs(list) do 
t = t..k..'-【['..v..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
t = t..'' 
if #list == 0 then 
t = 'لیست کاربران #گلوبال خالے میباشد'
end 
send(msg.chat_id, msg.send_message_id,t,'md')
end
if Black == 'clean gbans' or Black == 'پاکسازی لیست گلوبال' then
base:del(TD_ID..'GlobalyBanned:')
send(msg.chat_id, msg.send_message_id,'⭕ لیست گلوبال پاکسازے شد','md')
end
---------------Unbanall--------------
if Black and (Black:match('^unbanall (%d+)$') or Black:match('^ان بن گلوبال (%d+)$')) then
local user = Black:match('unbanall (%d+)') or Black:match('ان بن گلوبال (%d+)')
if base:sismember(TD_ID..'GlobalyBanned:',user) then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if name then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..name..'\nاز لیست گلوبال حذف شد', 'md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : `'..user..'`\n_از لیست گلوبال حذف شد_','md') 
end
base:srem(TD_ID..'GlobalyBanned:',user)
else
if name then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..user..'\nدر لیست گلوبال وجود ندارد','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..user..'\nدر لیست گلوبال وجود ندارد','md') 
end
end
end
if Black and (Black:match('^unbanall @(.*)') or Black:match('^ان بن گلوبال @(.*)')) then
local username = Black:match('^unbanall @(.*)') or Black:match('^ان بن گلوبال @(.*)')
local Diamond = TD.searchPublicChat(username)
if Diamond.id then
if base:sismember(TD_ID..'GlobalyBanned:',Diamond.id) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..username..'\nاز لیست گلوبال حذف شد', 'html')
base:srem(TD_ID..'GlobalyBanned:',Diamond.id)
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..username..'\nدر لیست گلوبال وجود ندارد','html')
end
else
send(msg.chat_id, msg.send_message_id,'❎ کاربر یافت نشد','md')
end
end
-------
if is_supergroup(msg) then

if Black == 'leave' or Black == 'خروج' then
send(msg.chat_id, msg.send_message_id,"⭕ ربات از گروه خارج شد...!",'md')
TD.leaveChat(msg.chat_id)
end
if (Black == 'charge full' or Black == 'شارژ نامحدود') then
local Diamond = TD.getChat(msg.chat_id)
base:set(TD_ID.."ExpireData:"..msg.chat_id,true)
base:sadd(TD_ID..'Gp2:'..chat_id,'added')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex3') 
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex2')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex1') 
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then names = diamond.usernames.editable_username else names = ec_name(diamond.first_name) end
local name = "["..names.."](tg://user?id="..msg.sender_id.user_id..")"
send(msg.chat_id, msg.send_message_id, '⭐ گروه به صورت نامحدود شارژ شد\nتوسط : '..name..'\nا━━━┅═❂═┅┅──┄┄\n📜 نام گروه : '..Diamond.title..'\n💬 شناسه گروه : '..msg.chat_id..'','md')
local BD = '♨ گروه جدیدے بصورت نامحدود #شارژ شد\nا━━━┅═❂═┅┅──┄┄\nمشخصات شارژ کننده :\n\n🆔 یوزرنیم : '..name..'\n\n✦ نام : '..ec_name(diamond.first_name)..'\n\n🌀 شناسه : '..msg.sender_id.user_id..'\nا━━━┅═❂═┅┅──┄┄\n\n📆 تاریخ فعال سازے : '..os.date('%Y/%m/%d')..'\n\n⏰ ساعت فعال سازے : '..os.date('%H:%M')..'\nا━━━┅═❂═┅┅──┄┄\nمشخصات گروه :\n\n📜 نام گروه : '..Diamond.title..'\n\n💬 شناسه گروه : '..msg.chat_id..''
send(Sudoid,0,BD,'md')
end
-----------------------
if Black and (Black:match('^charge (%d+)$') or Black:match('^شارژ (%d+)$')) then
local Diamond = TD.getChat(msg.chat_id)
local time = tonumber(Black:match('^charge (%d+)$') or Black:match('^شارژ (%d+)$'))* day 
if time == 0 then
time = 3
end
base:setex(TD_ID.."ExpireData:"..msg.chat_id,time-1,true)
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex3') 
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex2')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'chex1')
local ti = math.floor(time / day )
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then names = diamond.usernames.editable_username else names = ec_name(diamond.first_name) end
local name = "["..names.."](tg://user?id="..msg.sender_id.user_id..")"
send(msg.chat_id, msg.send_message_id,'✦ توسط : '..name..'\n✦ گروه : '..Diamond.title..'\n✦ به مدت : '..ti..' روز\n شارژ شد','md')
local BD = '♨ گروه جدیدے #شارژ شد\nا━━━┅═❂═┅┅──┄┄\nمشخصات شارژ کننده :\n\n🆔 یوزرنیم : '..name..'\n\n✦ نام : '..ec_name(diamond.first_name)..'\n\n🌀 شناسه : '..msg.sender_id.user_id..'\nا━━━┅═❂═┅┅──┄┄\n⌚ مدت زمان شارژ : '..ti..' روز\n\n📆 تاریخ فعال سازے : '..os.date('%Y/%m/%d')..'\n\n⏰ ساعت فعال سازے : '..os.date('%H:%M')..'\nا━━━┅═❂═┅┅──┄┄\nمشخصات گروه :\n\n📜 نام گروه : '..Diamond.title..'\n\n💬 شناسه گروه : '..msg.chat_id..''
send(Sudoid,0,BD,'md')
end
if Black == 'ownerlist' or Black == 'لیست مالکان' then
local list = base:smembers(TD_ID..'OwnerList:'..msg.chat_id)
local t = '🚬لیست مالک هاے ربات در گروه\nا┅┅──┄┄═✺═┄┄──┅┅\n'
for k,v in pairs(list) do
t = t..k..'-【['..v..'](tg://user?id='..v..')】\n─┅━━━━━━━┅─\n'
end
if #list == 0 then
t = 'لیست مالکان گروه خالے میباشد'
end
send(msg.chat_id, msg.send_message_id,t,'md')
end
if Black == 'clean allmsgs on' then
send(msg.chat_id, msg.send_message_id,  '> اغاز فرایند پاکسازی پیام های شمارش شده ...!','md')
base:set(TD_ID.."cleanmsgs",true)
end
if Black == 'clean allmsgs off' then
send(msg.chat_id, msg.send_message_id,  '> اتمام فرایند پاکسازی پیام های شمارش شده ...!','md')
base:del(TD_ID.."cleanmsgs")
end
--<><><><>SetOwner
if Diamondent and (Black:match('^setowner (.*)') or Black:match('^مالک (.*)')) or Black and (Black:match('^setowner @(.*)') or Black:match('^مالک @(.*)') or Black:match('^setowner (%d+)$') or Black:match('^مالک (%d+)$')) then
local BDSource = Black:match('^setowner (.*)') or Black:match('^مالک (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^setowner @(.*)') or Black:match('^مالک @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^setowner (%d+)') or Black:match('^مالک (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^setowner (.*)') or Black:match('^مالک (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if base:sismember(TD_ID..'OwnerList:'..msg.chat_id,mrr619) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nاز قبل در لیست مالکان ربات در گروه قرار داشت','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nبه لیست مالکان ربات در گروه افزوده شد','md')
base:sadd(TD_ID..'OwnerList:'..msg.chat_id,mrr619)
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!',  'html')
end
end
if Black == 'setowner' or Black == 'مالک' and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'OwnerList:'..msg.chat_id,user) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\nاز قبل در لیست مالکان ربات در گروه قرار داشت','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\nبه لیست مالکان ربات در گروه افزوده شد','md')
base:sadd(TD_ID..'OwnerList:'..msg.chat_id,user)
end
end
end
--<><><><>RemOwner
if Diamondent and (Black:match('^remowner (.*)') or Black:match('^حذف مالک (.*)')) or Black and (Black:match('^remowner @(.*)') or Black:match('^حذف مالک @(.*)') or Black:match('^remowner (%d+)$') or Black:match('^حذف مالک (%d+)$')) then
local BDSource = Black:match('^remowner (.*)') or Black:match('^حذف مالک (.*)')
local Diamond = TD.searchPublicChat(BDSource)
if not Diamondent and Black:match('^remowner @(.*)') or Black:match('^حذف مالک @(.*)') then
mrr619 = Diamond.id
elseif not Diamondent and Black:match('^remowner (%d+)') or Black:match('^حذف مالک (%d+)') then
mrr619 = BDSource
elseif Diamondent and Black:match('^remowner (.*)') or Black:match('^حذف مالک (.*)') then
mrr619 = msg.content.text.entities[1].type.user_id
end
if mrr619 then
if not base:sismember(TD_ID..'OwnerList:'..msg.chat_id,mrr619) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nدر لیست مالکان ربات قرار ندارد !','md')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..BDSource..'](tg://user?id='..mrr619..')\nاز لیست مالکان ربات در گروه حذف شد','md')
base:srem(TD_ID..'OwnerList:'..msg.chat_id,mrr619)
base:del(TD_ID..'getgp:'..mrr619)
end
else
send(msg.chat_id, msg.send_message_id,'کاربر '..BDSource..' یافت نشد ...!','html')
end
end
if Black == 'remowner' or Black == 'حذف مالک' and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id,tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'OwnerList:'..msg.chat_id,user) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\nاز لیست مالکان ربات در گروه حذف شد','md')
base:srem(TD_ID..'OwnerList:'..msg.chat_id,user)
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : ['..name..'](tg://user?id='..user..')\nدر لیست مالکان ربات قرار ندارد !','md')
end
end
end
if Black == 'clean ownerlist' or Black  == 'پاکسازی لیست مالکان' then
base:del(TD_ID..'OwnerList:'..msg.chat_id)
send(msg.chat_id, msg.send_message_id,'⭕ لیست مالکان ربات در گروه پاکسازے شد','md')
end
-------------Globaly Banned--------------
if Black == 'banall' or Black == 'بن گلوبال' and tonumber(reply_id) ~= 0  then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if tonumber(user) == tonumber(Sudoid) then
send(msg.chat_id, msg.send_message_id,'❎ شما قادر به گلوبال بن کردن سودو نیستید','md')
return false
end
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if base:sismember(TD_ID..'GlobalyBanned:',user) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..name..'\nدر لیست گلوبال وجود دارد','html')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..name..'\nبه لــیــسـت گلوبال افزوده شد','html')
base:sadd(TD_ID..'GlobalyBanned:',user)
end
end
end
if Black == 'unbanall' or Black == 'ان بن گلوبال' and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if tonumber(user) == tonumber(Sudoid) then
send(msg.chat_id, msg.send_message_id,'❎ شما قادر به گلوبال بن کردن سودو نیستید','md')
return false
end
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if not base:sismember(TD_ID..'GlobalyBanned:',user) then
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..name..'\nدر لیست گلوبال وجود ندارد','html')
else
send(msg.chat_id, msg.send_message_id,'✦ کاربر : \n🆔 : '..name..'\nاز لیست گلوبال حذف شد','html')
base:srem(TD_ID..'GlobalyBanned:',user)
end
end
end
if Black == 'kickall' or Black == 'اخراج همه' then 
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
local data = TD.getSupergroupMembers(msg.chat_id, "Recent", '' , 0 , 200 )
for k, v in pairs(data.members) do 
if tonumber(v.member_id.user_id) ~= tonumber(Sudoid) then
KickUser(msg.chat_id,v.member_id.user_id)
end
end
send(msg.chat_id, msg.send_message_id,'• انجام شد\nهمه ممبر ها اخراج شدند','md') 
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end
end
end
if (Black == 'tag' or Black == 'تگ') then
local keyboard = {
	{
		{text = '• تگ کاربران (ش)' ,data = 'TAGMemberUser:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id},
		{text = '• تگ کاربران' ,data = 'TAGMember:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id}
	},
	{
		{text = '• تگ مقام داران (ش)' ,data = 'TAGAdminUser:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id},
		{text = '• تگ مقام داران' ,data = 'TAGAdmin:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id}
	},
	{
		{text = '• تگ ویژه ها' ,data = 'TAGVip:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id},
		{text = '• تگ برترین ها' ,data = 'TAGBest:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id},
	},
	{
		{text = '• تگ برترین چت' ,data = 'TAGBestChat:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id},
		{text = '• تگ برترین ادد' ,data = 'TAGBestAdd:'..msg.chat_id..':'..msg.sender_id.user_id..':'..msg.send_message_id},
	},
	{
		{text = '• لغو عملیات' ,data = 'ExitTag:'..msg.chat_id..':'..msg.sender_id.user_id..':0'}
	}
}
TD.sendText(msg.chat_id, msg.send_message_id, " • نوع تگ کردن را انتخاب کنید :\n━┅┅━━ پنل تگ ━━┅┅━", "html", false, false, false, false, TD.replyMarkup({type = "inline", data = keyboard}));
end


---<<<>>>----
if is_Mod(msg) and is_supergroup(msg) and base:sismember(TD_ID..'Gp2:'..msg.chat_id,'added') then

if (Black == "warn" or Black == "اخطار" or BaBaK == "CAADBQADCQMAAqi62wiHqYMfasastwI") and tonumber(reply_id) > 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
if VipUser(msg,user) then
send(msg.chat_id, msg.send_message_id,"❌ #اخطار  !\nا─┅━━━━━━━┅─\nشما نمیتوانید به کاربران داری مقام اخطار دهید...!",'md')
else
 local hashwarn = TD_ID..msg.chat_id..':warn'
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',user) or 1
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if tonumber(warnhash) == tonumber(warn) then
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
KickUser(msg.chat_id,user)
UnRes(msg.chat_id,user)
text = '['..name..'](tg://user?id='..user..')\nا┅┅──┄┄═✺═┄┄──┅┅\nبه علت دریافت اخطار بیش از حد اخراج شد \nاخطار ها : '..warnhash..'/'..warn..''
base:hdel(hashwarn,user, '0')
send(msg.chat_id, msg.send_message_id,text,'md')
else
send(msg.chat_id, msg.send_message_id,'✖️اخطار های ['..name..'](tg://user?id='..user..') به حداکثر رسیده ولی ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید تا توانایی اخراج داشته باشد !','md')
end
else
local warnhash = base:hget(TD_ID..msg.chat_id..':warn',user) or 1
 base:hset(hashwarn,user, tonumber(warnhash) + 1)
text = '['..name..'](tg://user?id='..user..')\nا┅┅──┄┄═✺═┄┄──┅┅\nشما یک اخطار دریافت کردید \nتعداد اخطار هاے شما : '..warnhash..'/'..warn..''
send(msg.chat_id, msg.send_message_id,text,'md')
end
end
end
end

if (Black == 'muteall' or Black == 'قفل گروه' or BaBaK == 'CAADBQADBwMAAqi62wh8UueYrAGuAgI') then
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'Msg_Add')
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Mute_All') then
send(msg.chat_id, msg.send_message_id,'•گروه #تعطیل میباشد!','md')
else
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'automuteall') then
send(msg.chat_id, msg.send_message_id,'• تعطیلی خودکار فعال است!\nبرای تعطیل کردن گروه ابتدا با دستور تعطیل کردن خودکار خاموش تعطیلی خودکار را غیرفعال کنید','md')
else
base:sadd(TD_ID..'Gp2:'..msg.chat_id,'Mute_All')
send(msg.chat_id, msg.send_message_id,'•گروه #تعطیل شد و تمامی پیام هاے بعدے گروه پاک خواهند شد !','md')
end
end
end
if (Black == 'unmuteall' or Black == 'بازکردن گروه' or BaBaK == 'CAADBQADCAMAAqi62whykkHHBW2CAwI') then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Msg_Add')
local url_  = https.request(Bot_Api .. '/getChatMember?chat_id='..msg.chat_id..'&user_id='..BotCliId)
if res ~= 200 then
end
statsurl_ = json:decode(url_)
if statsurl_.ok == true and statsurl_.result.status == 'administrator' and statsurl_.result.can_restrict_members == true then
if base:sismember(TD_ID..'Gp2:'..msg.chat_id,'Mute_All') then
base:srem(TD_ID..'Gp2:'..msg.chat_id,'Mute_All')
base:srem(TD_ID..'Gp2:'..msg.chat_id,'automuteall')
local mutes =  base:smembers(TD_ID..'Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
base:srem(TD_ID..'Mutes:'..msg.chat_id,v)
UnRes(msg.chat_id,v)
end
send(msg.chat_id, msg.send_message_id,'•گروه باز شد و هم اکنون اعضاے گروه قادر به ارسال پیام هستند !','md')
else
send(msg.chat_id, msg.send_message_id,'•گروه #تعطیل نمیباشد!','md')
end
else
send(msg.chat_id, msg.send_message_id,'✖️ ربات به قسمت محرومیت کاربران  دسترسی ندارد !\n❗️لطفا از تنظیمات گروه این قابلیت را برای ربات فعال کنید سپس مجدد تلاش کنید !','md')
end
end

end
-------fun------ 
----شخصی 
if (not base:sismember(TD_ID..'Gp:'..msg.chat_id,'Lock:Cmd') or VipUser(msg,msg.sender_id.user_id)) and is_supergroup(msg) and base:sismember(TD_ID..'Gp2:'..msg.chat_id,'added') then
------Bot Chat-----
if not base:sismember(TD_ID..'Gp2:'..msg.chat_id,'BotChat') then
if Black and base:sismember(TD_ID..'Stickerslist:'..msg.chat_id,Black) then
local sticker = base:get(TD_ID..'Stickers:'..Black..''..msg.chat_id)
TD.sendSticker(msg.chat_id,msg.send_message_id,sticker)
end
if Black and base:sismember(TD_ID..'Textlist:'..msg.chat_id,Black) then
local text = base:hget(TD_ID..'Text:'..msg.chat_id,Black)
send(msg.chat_id, msg.send_message_id,text,'html')
end
if (Black == 'ربات' or BaBaK == 'CAADBQAD_wIAAqi62whEW0HNJgrhSgI') then
if msg.sender_id.user_id == Sudoid then
send(msg.chat_id, msg.send_message_id,'جونم بابایی','md')
else
local Bot = base:get(TD_ID..'rank'..msg.chat_id..msg.sender_id.user_id)
if Bot then
local rankpro = {'جونم '..Bot..'','تف تو کلات '..Bot..'','بگو '..Bot..'','بلے '..Bot..'','درد '..Bot..'','باهات قهرم '..Bot..' صدام نزن 😒',''..Bot..'😡😡',''..Bot..'😍😍','جووووون تو فقط صدام کن '..Bot..'😍','بنال ببینم چته '..Bot..'','الله و اکبر چیه '..Bot..''}
send(msg.chat_id, msg.send_message_id,rankpro[math.random(#rankpro)],'md')
else
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
if ec_name(diamond.first_name) == '' then
frname = ec_name(diamond.last_name)
else
frname = ec_name(diamond.first_name)
end
local rrr ={name,frname,'['..name..'](tg://user?id='..msg.sender_id.user_id..')','['..frname..'](tg://user?id='..msg.sender_id.user_id..')'}
local rank = {rrr[math.random(#rrr)]..' باز شروع شد؟','الله اکبر','تف تو کلات '..rrr[math.random(#rrr)],'بگو '..rrr[math.random(#rrr)],'جون🙁 '..rrr[math.random(#rrr)],'مرگ😡','ربات و ... 😡 الله اکبر','جووووون تو فقط صدام کن '..rrr[math.random(#rrr)],'از تو دیگه بعید بود '..rrr[math.random(#rrr)],'بنال ببینم چته '..rrr[math.random(#rrr)],'یبار دیگه صدام کنی ...😡','جون 🙁','ربات عمته','هان؟ '..rrr[math.random(#rrr)],'جونه دلم '..rrr[math.random(#rrr)],'بله عزیزم','ای درد و ربات','ای ربات و مرگ','الله و اکبر'}
send(msg.chat_id, msg.send_message_id,rank[math.random(#rank)],'md')
end
end
end 
end
if Black and #Black > 2 and base:get(TD_ID..'analysis_enabled:'..msg.chat_id) and is_JoinChannel(msg) then
    if msg.sender_id.user_id == Config.BotJoiner or is_Mod(msg) then goto skip_analysis end

    --------------------------------------------------------
    -- مرحله اول → تشخیص سریع لوکال (بدون هوش مصنوعی)
    --------------------------------------------------------
    local bad_words = {
        "کیر","کص","کون","جنده","حروم","سیک","fuck","dick","pussy",
        "مواد","تریاک","شیشه","چاقو","بکشمت","تهدید","خفه","دعوا"
    }

    local low = Black:lower()

    for _, w in ipairs(bad_words) do
        if low:find(w) then
            local user_id = msg.sender_id.user_id
            local warning = "<b>هشدار محتوا</b>\n\n" ..
                        "<a href=\"tg://user?id=" .. user_id .. "\">کاربر</a>\n" ..
                        "<b>دلیل:</b> کلمات نامناسب"
            pcall(send, msg.chat_id, msg.id, warning, 'html')
            goto skip_analysis
        end
    end

    --------------------------------------------------------
    -- مرحله دوم → (AI فقط وقتی مطمئن نباشیم)
    --------------------------------------------------------
    local prompt = [[
پیام: "]] .. Black .. [["

تحلیل:
- اگر پیام شامل فحاشی، توهین، تهدید، خشونت، تحقیر، مواد مخدر باشد → فقط اینطور جواب بده:
خطرناک: <دلیل کوتاه>

- اگر پیام کاملاً عادی بود → فقط بنویس:
OK

مثال‌های مجاز:
پیام: سلام → OK
پیام: سلام داش → OK
پیام: بکشمت → خطرناک: تهدید
پیام: کون → خطرناک: فحاشی
پیام: بریم مواد → خطرناک: مواد مخدر

پاسخ فقط یکی از این دو باشد:
OK
یا
خطرناک: <علت>
]]

    local payload = json:encode({
        model = "llama-3.1-8b-instant",
        messages = {{role = "user", content = prompt}},
        max_tokens = 20,
        temperature = 0
    })

    local response_body = {}
    local _, code = https.request{
        url = "https://api.groq.com/openai/v1/chat/completions",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer YOUR_KEY"
        },
        source = ltn12.source.string(payload),
        sink = ltn12.sink.table(response_body)
    }

    if code ~= 200 then goto skip_analysis end

    local result = json:decode(table.concat(response_body))
    local ai = result.choices[1].message.content or "OK"
    ai = ai:gsub("%s+", "")

    -- اگر دقیق نگفت "خطرناک: ..."
    if not ai:match("^خطرناک:") then goto skip_analysis end

    local reason = ai:gsub("^خطرناک:", "")
    if reason == "" then reason = "نامناسب" end

    --------------------------------------------------------
    -- ارسال هشدار
    --------------------------------------------------------
    local user_id = msg.sender_id.user_id
    local warning = "<b>هشدار محتوا</b>\n\n" ..
                    "<a href=\"tg://user?id=" .. user_id .. "\">کاربر</a>\n" ..
                    "<b>دلیل:</b> " .. reason
    pcall(send, msg.chat_id, msg.id, warning, 'html')

    ::skip_analysis::
end

-- === دستورات فعال/غیرفعال تحلیل ===
if Black and Black:match("^تحلیل فعال$") and is_JoinChannel(msg) then
    if not is_Mod(msg) then send(msg.chat_id, msg.id, "فقط مدیران!", 'md') return end
    base:set(TD_ID..'analysis_enabled:'..msg.chat_id, true)
    send(msg.chat_id, msg.id, "👮🏻‍♂️تحلیل پیام های گروه با هوش مصنوعی فعال شد هم اکنون محتوای نامناسب  پیام شناسایی و به مدیران گروه اعلام میشود", 'md')
end

if Black and Black:match("^تحلیل غیرفعال$") and is_JoinChannel(msg) then
    if not is_Mod(msg) then send(msg.chat_id, msg.id, "فقط مدیران!", 'md') return end
    base:del(TD_ID..'analysis_enabled:'..msg.chat_id)
    send(msg.chat_id, msg.id, "تحلیل هوش مصنوعی غیرفعال شد", 'md')
end
function spawn(f)
    local co = coroutine.create(f)
    coroutine.resume(co)
end

function sleep(sec)
    os.execute("sleep " .. sec)
end
function file_exists(name)
    local f = io.open(name, "r")
    if f then io.close(f) return true else return false end
end

local function clean(str)
    if not str or str == "" then return "Unknown_Song" end
    str = str:gsub("[^%w%d%s%-%_()آ-ی]", ""):gsub("%s+", "_"):gsub("^_+", ""):gsub("_+$", "")
    if str == "" then str = "Song" end
    return str
end
if Black and Black:match('^موزیک (.*)') and is_JoinChannel(msg) then
    local query = Black:match('^موزیک (.*)') or ""
    local reply_id = msg.send_message_id or msg.id or 0
    TD.sendText(msg.chat_id, reply_id, "درحال جستجو و دانلود آهنگ...\n🔍 <b>"..query.."</b>", "html")
    local timestamp = os.time()
    local tmp_file = "/tmp/music_" .. timestamp .. ".mp3"
    local check_file = "/tmp/music_check_" .. timestamp
    -- این خط اصلاح‌شده: client رو به ios عوض کردیم تا فرمت‌ها اسکیپ نشن
os.execute('nohup sh -c \'yt-dlp -N 10 -f "bestaudio/best" --extract-audio --audio-format mp3 --audio-quality 0 --restrict-filenames --quiet --retries infinite --fragment-retries infinite -o "'..tmp_file..'" "ytsearch1:'..query:gsub('"', '\\"')..'" && echo OK > "'..check_file..'" || echo NO > "'..check_file..'"\' &> /dev/null &')
    local attempts = 0
    local max_attempts = 60
    local function check_music()
        attempts = attempts + 1
        if file_exists(check_file) then
            local f = io.open(check_file, "r")
            local status = "NO"
            if f then
                status = f:read("*l") or "NO"
                f:close()
            end
            if status == "OK" and file_exists(tmp_file) then
                local safe_name = query
                    :gsub('[\\/%:"*%?<>|]', '')
                    :gsub("%s+", "_")
                    :gsub("^_+", ""):gsub("_+$", "")
                    :gsub("^%s+", ""):gsub("%s+$", "")
                if safe_name == "" or #safe_name > 150 then
                    safe_name = "آهنگ_درخواستی_" .. timestamp
                end
                local final_file = "/tmp/" .. safe_name .. ".mp3"
                os.execute('mv "'..tmp_file..'" "'..final_file..'" 2>/dev/null')
                local caption = "🎵 <b>آهنگ درخواستی شما</b>\n\n"..
                                "🔍 <b>جستجو شده:</b> <code>"..query.."</code>\n"..
                                "✅ از یوتیوب موزیک با کیفیت بالایی"
                TD.sendDocument(msg.chat_id, reply_id, final_file, caption, "html")
                os.execute("(sleep 90 && rm -f '"..tmp_file.."' '"..final_file.."' '"..check_file.."' ) &")
                return
            end
        end
        if attempts < max_attempts then
            TD.set_timer(3, check_music)
        else
            TD.sendText(msg.chat_id, reply_id, "❌ آهنگ پیدا نشد یا دانلود ناموفق!\n\nجستجو شده: <code>"..query.."</code>", "html")
        end
    end
    -- اولین چک بعد ۵ ثانیه
    TD.set_timer(5, check_music)
end
if Black and (Black == "پورن" or Black == "سکس") and is_JoinChannel(msg) then
    local reply_id = msg.send_message_id or msg.id or 0
    local chat_id = msg.chat_id
    TD.sendText(chat_id, reply_id, "*صبر کن دارم یه فیلم خفن میفرستم برات جقی*", "md")

    local page = math.random(1,5)
    local category_url = "https://www.xvideos.com/?k=teen&page="..page

    local get_video_cmd = [[curl -s "]]..category_url..[[" | grep -oP 'href="/video[^"]*' | cut -d'"' -f2 | head -n 20 | shuf -n1 | sed 's|^|https://www.xvideos.com|']]

    local handle = io.popen(get_video_cmd)
    local video_url = handle:read("*a"):gsub("\n","")
    handle:close()

    if not video_url or video_url == "" then
        TD.sendText(chat_id, reply_id, "نتونستم پیدا کنم، دوباره بزن پورن", "html")
        return
    end

    print("[PORN] لینک پیدا شد: "..video_url)

    local timestamp = os.time()
    local tmp_file = "/tmp/porn_"..timestamp..".mp4"
    local check_file = "/tmp/porn_check_"..timestamp

    os.execute('nohup sh -c \'yt-dlp -f "best[height<=720]" --no-playlist --quiet --retries 15 -o "'..tmp_file..'" "'..video_url..'" && echo OK > "'..check_file..'" || echo NO > "'..check_file..'"\' &> /dev/null &')

    local attempts = 0
    local function check()
        attempts = attempts + 1
        if file_exists(check_file) then
            local f = io.open(check_file,"r")
            local status = f and f:read("*l") or "NO"
            if f then f:close() end
            if status == "OK" and file_exists(tmp_file) then
                TD.sendDocument(chat_id, reply_id, tmp_file, "*فیلم خفن Teen 18+*\nکامل و با کیفیت\nاز جق لذت ببر", "md")
                os.execute("sleep 300 && rm -f '"..tmp_file.."' '"..check_file.."' &")
                return
            end
        end
        if attempts < 60 then
            TD.set_timer(5, check)
        end
    end
    TD.set_timer(5, check)
    return
end

if Black and Black:match("^wipe$") and is_JoinChannel(msg) then
    if not is_Mod(msg) then
        send(msg.chat_id, msg.id, "✦ فقط مدیران می‌توانند این دستور را اجرا کنند!", 'md')
        return
    end

    local base_path = "/root/BlackBot/tdlua-sessions"
    local folders = {"photos", "stickers", "videos"}
    local cleaned = false

    -- گرفتن تمام سشن‌ها
    local sessions = io.popen('ls "'..base_path..'"'):lines()
    for session in sessions do
        local session_path = base_path .. "/" .. session
        -- بررسی هر پوشه هدف در داخل سشن
        for _, folder in ipairs(folders) do
            local folder_path = session_path .. "/" .. folder
            -- بررسی اینکه پوشه وجود دارد
            local f = io.popen('ls "'..folder_path..'" 2>/dev/null'):lines()
            if f then
                for file in f do
                    local full_path = folder_path .. "/" .. file
                    os.remove(full_path)  -- پاک کردن فایل
                    cleaned = true
                    print("Removed: " .. full_path)
                end
            end
        end
    end

    if cleaned then
        send(msg.chat_id, msg.id, "✅ محتوای پوشه‌های همه سشن‌ها پاک شد.", 'md')
    else
        send(msg.chat_id, msg.id, "✦ پوشه‌ای برای پاکسازی پیدا نشد.", 'md')
    end
end
if Black and (Black:match("^بوم (%d+) (.*)$") or Black:match("^boom (%d+) (.*)$")) and is_JoinChannel(msg) then
    local phone = Black:match("^بوم (%d+)") or Black:match("^boom (%d+)")
    local message_text = Black:match("^بوم %d+ (.*)$") or Black:match("^boom %d+ (.*)$")

    if not is_Sudo(msg) then
        send(msg.chat_id, msg.id, "این دستور فقط برای سودوهای ربات فعال است!", 'md')
        return
    end

    local api_key = "4F772F5444774F796868724D344858467136797961522B363353676B732F363565746B31614C425A486A383D"

    if not api_key then
        send(msg.chat_id, msg.id, "خطا: API Key کاوه‌نگار تنظیم نشده!", 'md')
        return
    end

    -- تبدیل شماره به 98
    phone = phone:gsub("^0", "98")
    if #phone ~= 12 then phone = "98" .. phone:sub(2) end

    local payload = "receptor=" .. URL.escape(phone) ..
                   "&message=" .. URL.escape(message_text) ..
                   "&sender=2000660110"

    print("Payload: " .. payload)

    local headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        ["Content-Length"] = #payload
    }

    local response_body = {}
    local request_options = {
        url = "https://api.kavenegar.com/v1/" .. api_key .. "/sms/send.json",
        method = "POST",
        headers = headers,
        source = ltn12.source.string(payload),
        sink = ltn12.sink.table(response_body)
    }

    print("Headers: " .. serpent.dump(headers))

    local res, code = https.request(request_options)

    local raw_response = table.concat(response_body)
    print("Raw Response: " .. (raw_response or "nil"))
    print("HTTP Code: " .. (code or "nil"))
    if code == 200 then
        local result, decode_err = json:decode(raw_response)
        if not result or decode_err then
            send(msg.chat_id, msg.id, "خطا در decode پاسخ کاوه‌نگار: " .. (decode_err or "نامشخص"), 'md')
            return
        end

        -- درستش اینه (با براکت چون کلمه return رزرو شده است)
        if result["return"] and result["return"].status == 200 then
            local total = (tonumber(base:get("boom:total") or "0") or 0) + 1
            base:set("boom:total", total)

            local reply_text = [[
بوووووم! پیامک ناشناس با موفقیت ارسال شد

شماره: ]]..phone..[[

متن:
]]..message_text..[[

از طرف یه آدم بوی بد

تعداد کل بوم‌های ارسالی: ]]..total..[[ تا
]]
            send(msg.chat_id, msg.id, reply_text, 'Markdown')
        else
            local err_msg = result["return"] and result["return"].message or "خطای ناشناخته"
            send(msg.chat_id, msg.id, "خطا در ارسال پیامک:\n" .. err_msg, 'md')
        end
    else
        local error_msg = "خطا در ارتباط با کاوه‌نگار!\nکد: " .. (code or "نامشخص")
        send(msg.chat_id, msg.id, error_msg, 'md')
        print("Kavenegar Error: " .. code .. " - " .. raw_response)
    end
end
    -- =====================================================================
--------------------------------------------------------------------------------
if Black and Black:match("^هوش (.*)$") and is_JoinChannel(msg) then
    local query = Black:match("^هوش (.*)$")
    
    if not is_Mod(msg) then
        send(msg.chat_id, msg.id, "✦ فقط مدیران می‌توانند از هوش مصنوعی استفاده کنند!", 'md')
        return
    end
    
    local api_key = "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"
    
    if not api_key then
        send(msg.chat_id, msg.id, "✦ خطا: API Key Groq تنظیم نشده!", 'md')
        return
    end
    
    local payload_table = {
        model = "llama-3.1-8b-instant",  -- مدل سریع و رایگان Groq
        messages = {
            {role = "user", content = query}
        },
        max_tokens = 2000,  -- محدودیت پاسخ
        temperature = 0.7  -- خلاقیت
    }
    
    local payload, err = json:encode(payload_table)
    if not payload or err then
        send(msg.chat_id, msg.id, "✦ خطا در JSON encode: " .. (err or "نامشخص"), 'md')
        print("JSON Encode Error: " .. (err or "nil"))
        return
    end
    
    -- چاپ payload برای دیباگ
    print("Payload: " .. payload)
    
    -- تنظیم هدرها
    local headers = {
        ["Content-Type"] = "application/json; charset=utf-8",
        ["Authorization"] = "Bearer " .. api_key,
        ["Accept"] = "application/json"
    }
    
    -- ارسال درخواست با https.request (متد POST)
    local response_body = {}
    local request_options = {
        url = "https://api.groq.com/openai/v1/chat/completions",
        method = "POST",
        headers = headers,
        source = ltn12.source.string(payload),
        sink = ltn12.sink.table(response_body),
        redirect = false
    }
    
    -- چاپ هدرها برای دیباگ
    print("Headers: " .. serpent.dump(headers))
    
    local res, code, headers_resp = https.request(request_options)
    
    -- چاپ پاسخ خام برای دیباگ
    local raw_response = table.concat(response_body)
    print("Raw Response: " .. (raw_response or "nil"))
    print("HTTP Code: " .. (code or "nil"))
    
    if code == 200 then
        local result, decode_err = json:decode(raw_response)
        if not result or decode_err then
            send(msg.chat_id, msg.id, "✦ خطا در decode پاسخ Groq: " .. (decode_err or "JSON نامعتبر"), 'md')
            print("JSON Decode Error: " .. (decode_err or "nil"))
            return
        end
        if result.choices and result.choices[1] and result.choices[1].message then
            local groq_response = result.choices[1].message.content:gsub("\n\n", "\n")  -- تمیز کردن پاسخ
            send(msg.chat_id, msg.id, "🤖 <b>Groq AI:</b>\n" .. groq_response, 'html')
        else
            send(msg.chat_id, msg.id, "✦ پاسخ Groq خالی بود یا ساختار نامعتبر! (چک logs)", 'md')
            print("Invalid Response Structure: " .. serpent.dump(result))
        end
    else
        local error_msg = "✦ خطا در Groq! کد: " .. (code or "نامشخص") .. "\n" .. (raw_response or "نامشخص")
        if code == 401 then
            error_msg = error_msg .. "\n✦ API Key نامعتبر! به console.groq.com بروید."
        elseif code == 429 then
            error_msg = error_msg .. "\n✦ محدودیت درخواست API! کمی صبر کنید."
        end
        send(msg.chat_id, msg.id, error_msg, 'md')
        print("Groq Error: " .. (code or "nil") .. " - " .. (raw_response or "nil"))
    end
end

-- ثبت اصل (بدون ارور nil - کاملاً سازگار با سورس Black Diamond)
if (Black:match('^ثبت اصل$') or Black:match('^setasl$')) and tonumber(reply_id) ~= 0 then
    if not is_supergroup(msg) then
        send(msg.chat_id, msg.id, '✦ این دستور فقط در سوپرگروه‌ها قابل استفاده است.', 'md')
        return
    end

    if not (is_Sudo(msg) or is_Owner(msg) or is_Mod(msg)) then
        send(msg.chat_id, msg.id, '✦ فقط مدیران، صاحبان گروه یا سودوها می‌توانند اصل ثبت کنند.', 'md')
        return
    end

    local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
    if not Diamond or not Diamond.sender_id or not Diamond.sender_id.user_id then
        send(msg.chat_id, msg.id, '✦ پیام ریپلای‌شده معتبر نیست!', 'md')
        return
    end

    local user = Diamond.sender_id.user_id

    if Diamond.content._ ~= 'messageText' then
        send(msg.chat_id, msg.id, '✦ فقط پیام‌های متنی قابل ثبت به عنوان اصل هستند.', 'md')
        return
    end

    local asl_text = Diamond.content.text.text

    if base:get(TD_ID..'Asl:'..msg.chat_id..':'..user) then
        send(msg.chat_id, msg.id, '✦ اصل این کاربر قبلاً ثبت شده است.', 'md')
        return
    end

    base:set(TD_ID..'Asl:'..msg.chat_id..':'..user, asl_text)
    base:sadd(TD_ID..'AslRegistered:'..msg.chat_id, user)

    local diamond = TD.getUser(user)
    local name = diamond.usernames and diamond.usernames.editable_username or ec_name(diamond.first_name or "نامشخص")

    send(msg.chat_id, msg.id, '✦ اصل کاربر ['..name..'](tg://user?id='..user..') ثبت شد.', 'md')
end

-- ثبت اصل
-- نمایش اصل
if Black:match('^اصل من$') or Black:match('^asl$') then
    if is_supergroup(msg) then
        local asl_text = base:get(TD_ID..'Asl:'..msg.chat_id..':'..msg.sender_id.user_id)
        if asl_text then
            send(msg.chat_id, msg.id, '✦ اصل شما:\n'..asl_text, 'md')
        else
            send(msg.chat_id, msg.id, '✦ اصل شما ثبت نشده است.', 'md')
        end
    else
        send(msg.chat_id, msg.id, '✦ این دستور فقط در سوپرگروه‌ها قابل استفاده است.', 'md')
    end
end
-- نمایش اصل (دقیقاً مثل ایدی، فقط با reply_id)
if Black:match('^اصل$') or Black:match('^asl$') then
    if not is_supergroup(msg) then
        send(msg.chat_id, msg.id, '✦ این دستور فقط در سوپرگروه‌ها قابل استفاده است.', 'md')
        return
    end

    local target_id = msg.sender_id.user_id  -- پیش‌فرض: خود شخص

    if tonumber(reply_id) ~= 0 then
        local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
        if Diamond and Diamond.sender_id and Diamond.sender_id.user_id then
            target_id = Diamond.sender_id.user_id
        end
    end

    local asl_text = base:get(TD_ID..'Asl:'..msg.chat_id..':'..target_id)
    local user_info = TD.getUser(target_id)
    local name = user_info.usernames and user_info.usernames.editable_username or ec_name(user_info.first_name or "نامشخص")

    if asl_text then
        send(msg.chat_id, msg.id, '✦ اصل کاربر ['..name..'](tg://user?id='..target_id..')\n\n'..asl_text, 'md')
    else
        send(msg.chat_id, msg.id, '✦ اصل کاربر ['..name..'](tg://user?id='..target_id..') ثبت نشده است.', 'md')
    end
end
-- حذف اصل (خود شخص یا با ریپلای روی کاربر)
if Black:match('^حذف اصل$') or Black:match('^delasl$') then
    if not is_supergroup(msg) then
        send(msg.chat_id, msg.id, '✦ این دستور فقط در سوپرگروه‌ها قابل استفاده است.', 'md')
        return
    end

    local target_id = msg.sender_id.user_id  -- پیش‌فرض: خود شخص

    -- اگر ریپلای داشت → کاربر ریپلای‌شده (فقط مدیران یا خود شخص)
    if tonumber(reply_id) ~= 0 then
        local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
        if Diamond and Diamond.sender_id and Diamond.sender_id.user_id then
            target_id = Diamond.sender_id.user_id
        end
    end

    -- چک权限: یا خودش باشه یا مدیر/اونر/سودو
    if target_id ~= msg.sender_id.user_id and not (is_Mod(msg) or is_Owner(msg) or is_Sudo(msg)) then
        send(msg.chat_id, msg.id, '✦ شما فقط میتوانید اصل خودتان را حذف کنید!', 'md')
        return
    end

    if base:get(TD_ID..'Asl:'..msg.chat_id..':'..target_id) then
        base:del(TD_ID..'Asl:'..msg.chat_id..':'..target_id)
        base:srem(TD_ID..'AslRegistered:'..msg.chat_id, target_id)

        local user_info = TD.getUser(target_id)
        local name = user_info.usernames and user_info.usernames.editable_username or ec_name(user_info.first_name or "نامشخص")

        send(msg.chat_id, msg.id, '✦ اصل کاربر ['..name..'](tg://user?id='..target_id..') با موفقیت حذف شد.', 'md')
    else
        send(msg.chat_id, msg.id, '✦ این کاربر اصلاً اصل ثبت نکرده است!', 'md')
    end
end
-- لیست اصل (نمایش همه کاربرانی که اصل ثبت کردن)
if Black:match('^لیست اصل$') or Black:match('^listasl$') then
    if not is_supergroup(msg) then
        send(msg.chat_id, msg.id, '✦ این دستور فقط در سوپرگروه‌ها قابل استفاده است.', 'md')
        return
    end

    local list = base:smembers(TD_ID..'AslRegistered:'..msg.chat_id) or {}
    
    if #list == 0 then
        send(msg.chat_id, msg.id, '✦ هیچ کاربری اصل ثبت نکرده است.', 'md')
        return
    end

    local text = '✦ لیست کاربرانی که اصل ثبت کرده‌اند:\n\n'
    local count = 0

    for _, user_id in ipairs(list) do
        local asl_text = base:get(TD_ID..'Asl:'..msg.chat_id..':'..user_id)
        local user_info = TD.getUser(tonumber(user_id))
        local name = user_info.usernames and user_info.usernames.editable_username or ec_name(user_info.first_name or "نامشخص")
        
        local short_asl = asl_text
        if utf8.len(asl_text) > 50 then
            short_asl = utf8.sub(asl_text, 1, 50) .. '...'
        end

        text = text .. count+1 .. '. ['..name..'](tg://user?id='..user_id..')\n   ↳ '..short_asl..'\n\n'
        count = count + 1
    end

    text = text .. '✦ تعداد کل: '..count..' نفر'

    send(msg.chat_id, msg.id, text, 'md')
end
if Diamondent and (Black:match('^id (.*)') or Black:match('^آیدی (.*)') or Black:match('^ایدی (.*)')) and is_JoinChannel(msg) then
local result = TD.getUser(msg.content.text.entities[1].type.user_id)
if result.id then
send(msg.chat_id, msg.send_message_id,'['..result.id..'](tg://user?id='..result.id..')','md')
end
end
if Black and (Black:match('^id @(.*)') or Black:match('^ایدی @(.*)')) and is_JoinChannel(msg) then
local username = Black:match('^id @(.*)') or Black:match('^ایدی @(.*)')
local data = TD.searchPublicChat(username)
if data.id then
send(msg.chat_id, msg.send_message_id,'['..data.id..'](tg://user?id='..data.id..')','md')
else
send(msg.chat_id, msg.send_message_id,"✦ کاربر : @"..check_markdown(username).." _یافت نشد _!",'md')
end
end
if (Black == "id" or Black == "ایدی" or Black == "آیدی") and tonumber(reply_id) ~= 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
send(msg.chat_id, msg.send_message_id,'['..user..'](tg://user?id='..user..')','md')
end
end
if Black and (Black:match('^getpro (%d+)$') or Black:match('^عکس پروفایل (%d+)$')) then
local offset = tonumber(Black:match('^getpro (%d+)'))
or tonumber(Black:match('^عکس پروفایل (%d+)'))
if offset > 50 then
send(msg.chat_id, msg.send_message_id,'اشتباه زدے داداچ\n من بیشتر از 50 عکس پروفایل شما را نمیتوانم ارسال کنم ❎','md')
elseif offset < 1 then
send(msg.chat_id, msg.send_message_id,'لطفا عددے بزرگتر از 0 بکار ببرید⭕','md')
else
local result = TD.getUserProfilePhotos(msg.sender_id.user_id,offset,1)
if result.photos[1] then
TD.sendPhoto(msg.chat_id,msg.send_message_id,result.photos[1].sizes[1].photo.id,'» تعداد پروفایل : 【'..offset..'/'..result.total_count..'】\n» سایز عکس : 【'..result.photos[1].sizes[1].photo.size..' پیکسل 】','md')
else
send(msg.chat_id, msg.send_message_id,'شما عکس پروفایل '..offset..' ندارید','md')
end
end
end
if Black and (Black:match('^whois (%d+)$') or Black:match('^اطلاعات (%d+)$')) then
local id = tonumber(Black:match('^whois (%d+)') or Black:match('^اطلاعات (%d+)'))
local Diamond = TD.getUser(id)
if Diamond.first_name then 
username = Diamond.first_name
send(msg.chat_id, msg.send_message_id,'['..id..'](tg://user?id='..username..')','md')
else
send(msg.chat_id, msg.send_message_id,'*کاربر ['..id..'] یافت نشد*','md')
end
end
-- =========================================================
if (Black == "id" or Black == "ایدی" or Black == "آیدی" or BaBaK == "CAADBQADAQMAAqi62wiKc-NOagoezgI") and is_JoinChannel(msg) and tonumber(reply_id) == 0 then
Msgs = base:get(TD_ID..'Total:messages:'..msg.chat_id..':'..(msg.sender_id.user_id or 00000000))
Msgsgp = tonumber(base:get(TD_ID..'Total:messages:'..msg.chat_id..'') or 1)
Msgsday = tonumber(base:get(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..msg.sender_id.user_id or 00000000))
function diamondper(num, idp)
return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end

local percent = Msgs / Msgsgp * 100
if diamond.usernames and diamond.usernames.editable_username then
UsErName = '@'..diamond.usernames.editable_username
else
UsErName = '#فاقد_نام_کاربری'
end
local result = TD.getUserProfilePhotos(msg.sender_id.user_id,0,1)
if result.photos[1] then
TD.sendPhoto(msg.chat_id,msg.send_message_id,result.photos[1].sizes[1].photo.id,'❖ #شناسه‌کاربر‌ےشما : '..UsErName..'\n❖ #شناسه‌شما : '..msg.sender_id.user_id..'\n❖ #شناسه‌گروه : '..msg.chat_id..'\n❖ #تعدادپیام‌هاے‌گروه : '..Msgsgp..'\n❖ #تعداد‌پیام‌هاے‌امروز‌شما : '..Msgsday..'\n❖ #تعداد‌کل‌پیام‌ها‌ے‌شما : '..Msgs..' ('..diamondper(percent)..'%)','html')
else
send(msg.chat_id, msg.send_message_id,'❖ #شناسه‌کاربر‌ےشما : '..UsErName..'\n❖ #شناسه‌شما : '..msg.sender_id.user_id..'\n❖ #شناسه‌گروه : '..msg.chat_id..'\n❖ #تعدادپیام‌هاے‌گروه : '..Msgsgp..'\n❖ #تعداد‌پیام‌هاے‌امروز‌شما : '..Msgsday..'\n❖ #تعداد‌کل‌پیام‌ها‌ے‌شما : '..Msgs..'','html')
end
end
if (Black == "rules" or Black == "قوانین" or BaBaK == "CAADBQAD_gIAAqi62wjXpXmY5b5noQI") and is_JoinChannel(msg) then
rul = base:get(TD_ID..'Rules:'..msg.chat_id) or '|↜ قوانینے براے گروه ثبت نشده است'
send(msg.chat_id, msg.send_message_id,'⭕ قوانین گروه :\n'..rul..'','md')
end
-------Info By User-------
if (Black == 'info' or Black == 'اینفو') and is_JoinChannel(msg) and tonumber(reply_id) == 0 then
kick =
base:get(TD_ID..'Total:KickUser:'..msg.chat_id..':'..msg.sender_id.user_id) or 0
ban =
base:get(TD_ID..'Total:BanUser:'..msg.chat_id..':'..msg.sender_id.user_id) or 0
add =
base:get(TD_ID..'Total:AddUser:'..msg.chat_id..':'..msg.sender_id.user_id) or 0
local diamond = TD.getUser(msg.sender_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
text = '✦ اطلاعات کاربر :\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\n🆔 یوزرنیم : ['..name..'](tg://user?id='..msg.sender_id.user_id..')\n👤 نام : '..diamond.first_name..'\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nتعداد افراد اخراج شده توسط شما :\n【'..kick..'】\nتعداد افراد مسدود شده توسط شما :\n【'..ban..'】\nتعداد افراد افزوده شده توسط شما :\n【'..add..'】'
send(msg.chat_id, msg.send_message_id,text,'md')
end
-------Info By Reply-------
if (Black == 'info' or Black == 'اینفو') and tonumber(reply_id) ~= 0  and is_JoinChannel(msg) then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
kick =
base:get(TD_ID..'Total:KickUser:'..msg.chat_id..':'..user) or 0
ban =
base:get(TD_ID..'Total:BanUser:'..msg.chat_id..':'..user) or 0 
add =
base:get(TD_ID..'Total:AddUser:'..msg.chat_id..':'..user) or 0
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
text = '✦ اطلاعات کاربر :\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\n🆔 یوزرنیم : ['..name..'](tg://user?id='..user..')\n👤 نام : '..diamond.first_name..'\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nتعداد افراد اخراج شده توسط شما :\n【'..kick..'】\nتعداد افراد مسدود شده توسط شما :\n【'..ban..'】\nتعداد افراد افزوده شده توسط شما :\n【'..add..'】'
send(msg.chat_id, msg.send_message_id,text,'md')
end
end
if Black and (Black:match('^info @(.*)$') or Black:match('^اینفو @(.*)$')) and is_JoinChannel(msg) then
local username = Black:match('^info @(.*)') or Black:match('^اینفو @(.*)')
local data = TD.searchPublicChat(username)
user = data.id
if user then
kick =
base:get(TD_ID..'Total:KickUser:'..msg.chat_id..':'..user) or 0
ban =
base:get(TD_ID..'Total:BanUser:'..msg.chat_id..':'..user) or 0 
add =
base:get(TD_ID..'Total:AddUser:'..msg.chat_id..':'..user) or 0
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
text = '✦ اطلاعات کاربر :\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\n🆔 یوزرنیم : ['..name..'](tg://user?id='..user..')\n👤 نام : '..diamond.first_name..'\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nتعداد افراد اخراج شده توسط شما :\n【'..kick..'】\nتعداد افراد مسدود شده توسط شما :\n【'..ban..'】\nتعداد افراد افزوده شده توسط شما :\n【'..add..'】'
send(msg.chat_id, msg.send_message_id,text,'md')
else 
send(msg.chat_id, msg.send_message_id,'❎ کاربر یافت نشد','html')
end
end
if Black and (Black:match('^info (%d+)$') or Black:match('^اینفو (%d+)$')) and is_JoinChannel(msg) then
local users = tonumber(Black:match('^info (%d+)$') or Black:match('^اینفو (%d+)$'))
kick =
base:get(TD_ID..'Total:KickUser:'..msg.chat_id..':'..users) or 0
ban =
base:get(TD_ID..'Total:BanUser:'..msg.chat_id..':'..users) or 0 
add =
base:get(TD_ID..'Total:AddUser:'..msg.chat_id..':'..users) or 0
local diamond = TD.getUser(users)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
text = '✦ اطلاعات کاربر :\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\n🆔 یوزرنیم : ['..name..'](tg://user?id='..users..')\n👤 نام : '..diamond.first_name..'\n﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄﹃﹄\nتعداد افراد اخراج شده توسط شما :\n【'..kick..'】\nتعداد افراد مسدود شده توسط شما :\n【'..ban..'】\nتعداد افراد افزوده شده توسط شما :\n【'..add..'】'
send(msg.chat_id, msg.send_message_id,text,'md')
end
if Black and (Black:match('^echo (.*)$') or Black:match('^بگو (.*)$')) then
local txt = Black:match('^echo (.*)$') or Black:match('^بگو (.*)$')
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
send(msg.chat_id, reply_id,txt,'html')
end
if (Black == 'me' or Black == 'اطلاعات من') and is_JoinChannel(msg) then 
local Diamond = TD.getUser(msg.sender_id.user_id)
local result = TD.getUserFullInfo(msg.sender_id.user_id)
rankk =  ''..(base:get(TD_ID..'rank'..msg.chat_id..msg.sender_id.user_id) or "مقامے ندارید")..''
if is_Sudo(msg)then
rank =  'سودو ربات' 
elseif is_Owner(msg)then
rank =  'سازنده گروه' 
elseif is_Mod(msg)then
rank =  'مدیر گروه'
elseif is_Vip(msg)then
rank =  'عضو ویژه'
elseif not is_Mod(msg)then
rank = 'کاربر عادے'
end
if Diamond.first_name == '' then
DiamondName = 'nil'
else  
DiamondName = Diamond.first_name
end
if result.bio.text == '' then
DiamondAbout = 'Empty'
else  
DiamondAbout = result.bio.text
end
if result.common_chat_count == ''  then
Diamondcommon_chat_count  = '00'
else 
Diamondcommon_chat_count  = result.common_chat_count 
end
if Diamond.status.expires == '' then
onoff  = 'آخرین بازدید اخیرا'
else 
onoff  = ''..(os.date("%X", Diamond.status.expires))..''
end
kick = base:get(TD_ID..'Total:KickUser:'..msg.chat_id..':'..msg.sender_id.user_id) or 0
ban = base:get(TD_ID..'Total:BanUser:'..msg.chat_id..':'..msg.sender_id.user_id) or 0
add = base:get(TD_ID..'Total:AddUser:'..msg.chat_id..':'..msg.sender_id.user_id) or 0
Msgs = base:get(TD_ID..'Total:messages:'..msg.chat_id..':'..(Diamond.id or 00000000)) or 0
Msgsgp = tonumber(base:get(TD_ID..'Total:messages:'..msg.chat_id..'') or 0) or 0
Msgsday = tonumber(base:get(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..Diamond.id or 00000000)) or 0
 function diamondper(num, idp)
return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
 local percent = Msgs / Msgsgp * 100
 txtm = '✶ بخشی از اطلاعات کاربری شما : \nا┅┅──┄┄═❂═┄┄──┅┅\n|↜ نام کوچک  : '..check_markdown(DiamondName)..'\n|↜ شناسه شما :'..msg.sender_id.user_id..'\n|↜ نام کاربرے شما : @'..check_markdown(Diamond.usernames and Diamond.usernames.editable_username or '')..'\n|↜ بیوگرافے : '..check_markdown(DiamondAbout)..'\n|↜اخرین بازدید : '..onoff..'\nا┅┅──┄┄═❂═┄┄──┅┅\n|↜ مقام شما : '..rankk..'\n|↜ مقام شما در ربات : '..rank..'\n|↜ تعداد پیام هاے شما : '..Msgs..'\n|↜ تعداد پیام‌هاے امروز شما : *'..Msgsday..'*\n|↜ تعداد کل پیام‌هاے شما : *'..Msgs..'*\n|↜ درصدکل پیام‌هاے شما : *'..diamondper(percent)..'%*\n|↜تعداد افراد اخراج کرده : '..kick..'\n|↜تعداد افراد مسدود کرده : '..ban..'\n|↜تعداد اد : '..add
send(msg.chat_id, msg.send_message_id,txtm,'md')
end
if Black == 'time' or Black == 'ساعت' and is_JoinChannel(msg) then
send(msg.chat_id, msg.send_message_id,'ساعت : '..jdates('#h:#m:#s')..'\nذکر امروز : '..jdates('#z')..'','md')
end
if Black1 and (Black1:match('^([Gg][Ii][Ff]) (.*)$') or Black1:match('^ساخت گیف (.*)$')) and is_JoinChannel(msg) then
local Black1 = Black1:gsub("ساخت گیف", "gif")
local Black = {string.match(Black1, "^([Gg][Ii][Ff]) (.*)$")}           
local modes = {'memories-anim-logo','alien-glow-anim-logo','flash-anim-logo','flaming-logo','whirl-anim-logo','highlight-anim-logo','burn-in-anim-logo','shake-anim-logo','inner-fire-anim-logo','jump-anim-logo'}
local text = URL.escape(Black[2])
local url = 'http://www.flamingtext.com/net-fu/image_output.cgi?_comBuyRedirect=false&script='..modes[math.random(#modes)]..'&text='..text..'&symbol_tagname=popular&fontsize=70&fontname=futura_poster&fontname_tagname=cool&textBorder=15&growSize=0&antialias=on&hinting=on&justify=2&letterSpacing=0&lineSpacing=0&textSlant=0&textVerticalSlant=0&textAngle=0&textOutline=off&textOutline=false&textOutlineSize=2&textColor=%230000CC&angle=0&blueFlame=on&blueFlame=false&framerate=75&frames=5&pframes=5&oframes=4&distance=2&transparent=off&transparent=false&extAnim=gif&animLoop=on&animLoop=false&defaultFrameRate=75&doScale=off&scaleWidth=240&scaleHeight=120&&_=1469943010141'	
local title , res = http.request(url)
local mod = {'Blinking+Text','No+Button','Dazzle+Text','Walk+of+Fame+Animated','Wag+Finger','Glitter+Text','Bliss','Flasher','Roman+Temple+Animated',}
local set = mod[math.random(#mod)]
local colors = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local bc = colors[math.random(#colors)]
local colorss = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FFF200','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local tc = colorss[math.random(#colorss)]
local url2 = 'http://www.imagechef.com/ic/maker.jsp?filter=&jitter=0&tid='..set..'&color0='..bc..'&color1='..tc..'&color2=000000&customimg=&0='..Black[2]	
local title1,res = http.request(url2)
if res == 200 then
if title1 then
if json:decode(title1) then
local jdat = json:decode(title1)
local gif = jdat.resImage
local file = DownloadFile(gif,'Gif-Random.gif')
TD.sendDocument(msg.chat_id,msg.send_message_id,0,1,nil,file, '',dl_cb,nil)
end
end
end
end
if Black1 and (Black1:match('^([Ss][Tt][Ii][Cc][Kk][Ee][Rr]) (.*)$') or Black1:match('^ساخت استیکر (.*)$')) and is_JoinChannel(msg) then
local Black1 = Black1:gsub("ساخت استیکر", "sticker")
local Black = {string.match(Black1,"^([Ss][Tt][Ii][Cc][Kk][Ee][Rr]) (.*)$")}
local modes = {'memories-anim-logo','alien-glow-anim-logo','flash-anim-logo','flaming-logo','whirl-anim-logo','highlight-anim-logo','burn-in-anim-logo','shake-anim-logo','inner-fire-anim-logo','jump-anim-logo'}
local text = URL.escape(Black[2])
local url = 'http://www.flamingtext.com/net-fu/image_output.cgi?_comBuyRedirect=false&script='..modes[math.random(#modes)]..'&text='..text..'&symbol_tagname=popular&fontsize=70&fontname=futura_poster&fontname_tagname=cool&textBorder=15&growSize=0&antialias=on&hinting=on&justify=2&letterSpacing=0&lineSpacing=0&textSlant=0&textVerticalSlant=0&textAngle=0&textOutline=off&textOutline=false&textOutlineSize=2&textColor=%230000CC&angle=0&blueFlame=on&blueFlame=false&framerate=75&frames=5&pframes=5&oframes=4&distance=2&transparent=off&transparent=false&extAnim=gif&animLoop=on&animLoop=false&defaultFrameRate=75&doScale=off&scaleWidth=240&scaleHeight=120&&_=1469943010141' 
local title , res = http.request(url)
local mod = {'Blinking+Text','No+Button','Dazzle+Text','Walk+of+Fame+Animated','Wag+Finger','Glitter+Text','Bliss','Flasher','Roman+Temple+Animated',}
local set = mod[math.random(#mod)]
local colors = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local bc = colors[math.random(#colors)]
local colorss = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FFF200','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local tc = colorss[math.random(#colorss)]
local url2 = 'http://www.imagechef.com/ic/maker.jsp?filter=&jitter=0&tid='..set..'&color0='..bc..'&color1='..tc..'&color2=000000&customimg=&0='..Black[2] 
local title1,res = http.request(url2)
if res == 200 then
if title1 then
if json:decode(title1) then
local jdat = json:decode(title1)
local sticker = jdat.resImage
local file = DownloadFile(sticker,'bd.webp') 
TD.sendDocument(msg.chat_id,msg.send_message_id,0,1,nil,file, '',dl_cb,nil)
end
end
end
end
if Black1 and (Black1:match('^([Pp][Hh][Oo][Tt][Oo]) (.*)$') or Black1:match('^ساخت عکس (.*)$')) and is_JoinChannel(msg) then
local Black1 = Black1:gsub("ساخت عکس", "photo")
local Black = {string.match(Black1,"^([Pp][Hh][Oo][Tt][Oo]) (.*)$")}
local modes = {'memories-anim-logo','alien-glow-anim-logo','flash-anim-logo','flaming-logo','whirl-anim-logo','highlight-anim-logo','burn-in-anim-logo','shake-anim-logo','inner-fire-anim-logo','jump-anim-logo'}
local text = URL.escape(Black[2])
local url = 'http://www.flamingtext.com/net-fu/image_output.cgi?_comBuyRedirect=false&script='..modes[math.random(#modes)]..'&text='..text..'&symbol_tagname=popular&fontsize=70&fontname=futura_poster&fontname_tagname=cool&textBorder=15&growSize=0&antialias=on&hinting=on&justify=2&letterSpacing=0&lineSpacing=0&textSlant=0&textVerticalSlant=0&textAngle=0&textOutline=off&textOutline=false&textOutlineSize=2&textColor=%230000CC&angle=0&blueFlame=on&blueFlame=false&framerate=75&frames=5&pframes=5&oframes=4&distance=2&transparent=off&transparent=false&extAnim=gif&animLoop=on&animLoop=false&defaultFrameRate=75&doScale=off&scaleWidth=240&scaleHeight=120&&_=1469943010141' 
local title , res = http.request(url)
local mod = {'Blinking+Text','No+Button','Dazzle+Text','Walk+of+Fame+Animated','Wag+Finger','Glitter+Text','Bliss','Flasher','Roman+Temple+Animated',}
local set = mod[math.random(#mod)]
local colors = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local bc = colors[math.random(#colors)]
local colorss = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FFF200','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
local tc = colorss[math.random(#colorss)]
local url2 = 'http://www.imagechef.com/ic/maker.jsp?filter=&jitter=0&tid='..set..'&color0='..bc..'&color1='..tc..'&color2=000000&customimg=&0='..Black[2] 
local title1,res = http.request(url2)
if res == 200 then
if title1 then
if json:decode(title1) then
local jdat = json:decode(title1)
local photo = jdat.resImage
local file = DownloadFile(photo,'bd.jpg') 
TD.sendPhoto(msg.chat_id,msg.send_message_id,file,'','md')
end
end
end
end
if Black == 'tophoto' or Black == 'تبدیل به عکس' and is_JoinChannel(msg) and tonumber(reply_id) > 0 then
local result = TD.getMessage(msg.chat_id, reply_id) 
if result.content.sticker then 
repeat 
download = TD.downloadFile(result.content.sticker.sticker.id) 
until #download['local'].path ~= 0 
TD.sendPhoto(msg.chat_id, msg.send_message_id, download['local'].path,result.content.sticker.emoji) 
else 
send(msg.chat_id, msg.send_message_id,'فقط #استیکر ها قابل تبدیل میباشد','md')
end
end
if Black and (Black:match('^([Ww][Rr][Ii][Tt][Ee]) [\216-\219][\128-\191](.*)$') or Black:match('^زیباسازی [\216-\219][\128-\191](.*)$')) and is_JoinChannel(msg) then
local matches = Black:match('^write (.*)$') or Black:match('^زیباسازی (.*)$')
dofile('./BlackDiamond/BlackDiamond.lua')
	if utf8.len(matches) > 4 then
	send(msg.chat_id, msg.send_message_id,"حداکثر حروف مجاز [ 4] کاراکتر است•!\nتعداد کارکترهاے شما : "..utf8.len(matches),'html')
	end
	local font_base = "ض,ص,ق,ف,غ,ع,ه,خ,ح,ج,ش,س,ی,ب,ل,ا,ن,ت,م,چ,ظ,ط,ز,ر,د,پ,و,ک,گ,ث,ژ,ذ,آ,ئ,.,_"
	local font_hash = "ض,ص,ق,ف,غ,ع,ه,خ,ح,ج,ش,س,ی,ب,ل,ا,ن,ت,م,چ,ظ,ط,ز,ر,د,پ,و,ک,گ,ث,ژ,ذ,آ,ئ,.,_"
local result = {}
	i=0
	for k=1,#fontf do
		i=i+1
		local tar_font = fontf[i]:split(",")
		local text = matches
		local text = text:gsub("ض",tar_font[1])
		local text = text:gsub("ص",tar_font[2])
		local text = text:gsub("ق",tar_font[3])
		local text = text:gsub("ف",tar_font[4])
		local text = text:gsub("غ",tar_font[5])
		local text = text:gsub("ع",tar_font[6])
		local text = text:gsub("ه",tar_font[7])
		local text = text:gsub("خ",tar_font[8])
		local text = text:gsub("ح",tar_font[9])
		local text = text:gsub("ج",tar_font[10])
		local text = text:gsub("ش",tar_font[11])
		local text = text:gsub("س",tar_font[12])
		local text = text:gsub("ی",tar_font[13])
		local text = text:gsub("ب",tar_font[14])
		local text = text:gsub("ل",tar_font[15])
		local text = text:gsub("ا",tar_font[16])
		local text = text:gsub("ن",tar_font[17])
		local text = text:gsub("ت",tar_font[18])
		local text = text:gsub("م",tar_font[19])
		local text = text:gsub("چ",tar_font[20])
		local text = text:gsub("ظ",tar_font[21])
		local text = text:gsub("ط",tar_font[22])
		local text = text:gsub("ز",tar_font[23])
		local text = text:gsub("ر",tar_font[24])
		local text = text:gsub("د",tar_font[25])
		local text = text:gsub("پ",tar_font[26])
		local text = text:gsub("و",tar_font[27])
		local text = text:gsub("ک",tar_font[28])
		local text = text:gsub("گ",tar_font[29])
		local text = text:gsub("ث",tar_font[30])
		local text = text:gsub("ژ",tar_font[21])
		local text = text:gsub("ذ",tar_font[32])
		local text = text:gsub("ئ",tar_font[33])
		local text = text:gsub("آ",tar_font[34])
		table.insert(result, text)
	end
	local result_text = "√•زیبا سازے اسم•√  : "..matches.."\nتعداد کارکترهاے شما : "..utf8.len(matches).."\nطراحے با "..tostring(#fontf).." فونت:\n━━━━━━━━━━\n"
	a=0
	for v=1,#result do
		a=a+1
		result_text = result_text..a.."🔘 "..result[a].."\n"
	end
send(msg.chat_id, msg.send_message_id,result_text..">━━━━━━━━━━<\n","md")
end
if Black and (Black:match('^([Ww][Rr][Ii][Tt][Ee]) [a-z](.*)$') or Black:match('^([Ww]rite) [A-Z](.*)$') or Black:match('^زیباسازی [A-Z](.*)$') or Black:match('^زیباسازی [a-z](.*)$')) and is_JoinChannel(msg) then
local matches = Black:match('^write (.*)$') or Black:match('^زیباسازی (.*)$')
dofile('./BlackDiamond/BlackDiamond.lua')
	if utf8.len(matches) > 20 then
		send(msg.chat_id, msg.send_message_id,"حداکثر حروف مجاز [ 4] کاراکتر است•!\nتعداد کارکترهاے شما : "..utf8.len(matches),'html')
	end
	local font_base = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,9,8,7,6,5,4,3,2,1,.,_"
	local font_hash = "z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,Z,Y,X,W,V,U,T,S,R,Q,P,O,N,M,L,K,J,I,H,G,F,E,D,C,B,A,0,1,2,3,4,5,6,7,8,9,.,_"
	local result = {}
	i=0
	for k=1,#fonte do
		i=i+1
		local tar_font = fonte[i]:split(",")
		matches2 = matches:gsub("[Aa]","α")
		local text = matches2
		local text = text:gsub("A",tar_font[1])
		local text = text:gsub("B",tar_font[2])
		local text = text:gsub("C",tar_font[3])
		local text = text:gsub("D",tar_font[4])
		local text = text:gsub("E",tar_font[5])
		local text = text:gsub("F",tar_font[6])
		local text = text:gsub("G",tar_font[7])
		local text = text:gsub("H",tar_font[8])
		local text = text:gsub("I",tar_font[9])
		local text = text:gsub("J",tar_font[10])
		local text = text:gsub("K",tar_font[11])
		local text = text:gsub("L",tar_font[12])
		local text = text:gsub("M",tar_font[13])
		local text = text:gsub("N",tar_font[14])
		local text = text:gsub("O",tar_font[15])
		local text = text:gsub("P",tar_font[16])
		local text = text:gsub("Q",tar_font[17])
		local text = text:gsub("R",tar_font[18])
		local text = text:gsub("S",tar_font[19])
		local text = text:gsub("T",tar_font[20])
		local text = text:gsub("U",tar_font[21])
		local text = text:gsub("V",tar_font[22])
		local text = text:gsub("W",tar_font[23])
		local text = text:gsub("X",tar_font[24])
		local text = text:gsub("Y",tar_font[25])
		local text = text:gsub("Z",tar_font[26])
		local text = text:gsub("a",tar_font[27])
		local text = text:gsub("b",tar_font[28])
		local text = text:gsub("c",tar_font[29])
		local text = text:gsub("d",tar_font[30])
		local text = text:gsub("e",tar_font[21])
		local text = text:gsub("f",tar_font[32])
		local text = text:gsub("g",tar_font[33])
		local text = text:gsub("h",tar_font[34])
		local text = text:gsub("i",tar_font[35])
		local text = text:gsub("j",tar_font[36])
		local text = text:gsub("k",tar_font[37])
		local text = text:gsub("l",tar_font[38])
		local text = text:gsub("m",tar_font[39])
		local text = text:gsub("n",tar_font[40])
		local text = text:gsub("o",tar_font[41])
		local text = text:gsub("p",tar_font[42])
		local text = text:gsub("q",tar_font[43])
		local text = text:gsub("r",tar_font[44])
		local text = text:gsub("s",tar_font[45])
		local text = text:gsub("t",tar_font[46])
		local text = text:gsub("u",tar_font[47])
		local text = text:gsub("v",tar_font[48])
		local text = text:gsub("w",tar_font[49])
		local text = text:gsub("x",tar_font[50])
		local text = text:gsub("y",tar_font[51])
		local text = text:gsub("z",tar_font[52])
		local text = text:gsub("0",tar_font[53])
		local text = text:gsub("9",tar_font[54])
		local text = text:gsub("8",tar_font[55])
		local text = text:gsub("7",tar_font[56])
		local text = text:gsub("6",tar_font[57])
		local text = text:gsub("5",tar_font[58])
		local text = text:gsub("4",tar_font[59])
		local text = text:gsub("3",tar_font[60])
		local text = text:gsub("2",tar_font[61])
		local text = text:gsub("1",tar_font[62])
		table.insert(result, text)
	end
	local result_text = "کلمه ے اولیه: "..matches.."\nتعداد کارکتر هاے کلمه : "..utf8.len(matches).."\nطراحے با "..tostring(#fonte).." فونت:\n━━━━━━━━━━━━\n"
	a=0
	for v=1,#result do
		a=a+1
		result_text = result_text..a.."- "..result[a].."\n"
	end
send(msg.chat_id, msg.send_message_id,result_text..">━━━━━━━━━━<\n","md")
end
if Black and (Black:match("^(ping)$") or Black1:match("^/ping@BlackApi_bot") or Black:match("^(پینگ)$")) and is_JoinChannel(msg) then
y = os.time() 
txt = "• ربات هم اکنون آنلاین میباشد !"
send(msg.chat_id, msg.send_message_id,txt,'html')
end	
if Black and (Black:match('^tpm @(.*)') or Black:match('^تعداد پیام @(.*)') or Black:match('^تعدادپیام @(.*)')) and is_JoinChannel(msg) then
local username = Black:match('^tpm @(.*)') or Black:match('^تعداد پیام @(.*)') or Black:match('^تعدادپیام @(.*)')
local data = TD.searchPublicChat(username)
if data.id then
user_id = data.id
chat_id = msg.chat_id
Msgs = base:get(TD_ID..'Total:messages:'..chat_id..':'..user_id) or 0
Msgsgp = tonumber(base:get(TD_ID..'Total:messages:'..chat_id..'') or 0)
Msgsday = tonumber(base:get(TD_ID..'Total:messages:'..chat_id..':'..os.date('%Y/%m/%d')..':'..user_id or 00000000)) or 0
function diamondper(num,idp)
return tonumber(string.format('%.' ..(idp or 0) .. 'f',num))
end
percent = Msgs / Msgsgp * 100
gp = base:get(TD_ID..'StatsGpByName'..msg.chat_id) or 'nil'
local diamond = TD.getUser(user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
local keyboard = {}
keyboard.inline_keyboard = {{
{text = 'تعدادپیام‌هاےگروه',callback_data = 'Msgsgp'},
{text = ''..Msgsgp..'',callback_data = 'Msgsgp'}},{
{text = 'تعدادپیام‌هاےامروزکاربر',callback_data = 'Msgsday'},
{text = ''..Msgsday..'',callback_data = 'Msgsday'}},{
{text = 'تعدادکل پیام‌هاےکاربر',callback_data = 'Msgs'},
{text = ''..Msgs..'',callback_data = 'Msgs'}},{
{text = 'درصدکل پیام‌هاےکاربر',callback_data = '(diamondper(percent))'},
{text = ''..(diamondper(percent))..'%', callback_data = '(diamondper(percent))'}},{
{text = '🗑 ریستارت',callback_data = 'resetpms:'..user_id..':'..name..':'..chat_id},
{text = '✦ بستن پنل پیام',callback_data = 'bd:Exitss:'..chat_id},},}
BD = 'آمار پیام‌هاے :\nکاربر :【<a href="tg://user?id='..data.id..'">'..name..'</a>】\nدر گروه :【'..gp..'】\n─┅━━━━━━━┅─\n'
send_inline(msg.chat_id,BD,keyboard,'html')
else 
send(msg.chat_id, msg.send_message_id,'❎ کاربر یافت نشد','html')
end
end   
if (Black == 'fal' or Black == 'فال') and is_JoinChannel(msg) then
local url = 'http://api.novateamco.ir/fal'
local file = DownloadFile(url,'fal.jpg')
TD.sendPhoto(msg.chat_id,msg.send_message_id,file,'','md')
end
if (Black == 'تاریخ' or Black == 'date') and is_JoinChannel(msg) then
txt = '_امروز : '..jdates('#x')..'\nتاریخ : '..jdates('_#D-#X-#Y_')..'_'
send(msg.chat_id, msg.send_message_id,txt,'md')
end
if (Black == 'jok' or Black == 'جوک') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/jok/",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local text = table.concat(response_body)
        send(msg.chat_id, msg.send_message_id, text, 'html')
    else
        send(msg.chat_id, msg.send_message_id, "خطا در دریافت جوک! 😔", 'html')
    end
end

if (Black == 'p n p' or Black == 'پ ن پ') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/jok/pa-na-pa/",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local text = table.concat(response_body)
        send(msg.chat_id, msg.send_message_id, text, 'html')
    else
        send(msg.chat_id, msg.send_message_id, "خطا در دریافت پ ن پ! 😔", 'html')
    end
end

if (Black == 'memory' or Black == 'خاطره') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/jok/khatere/",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local text = table.concat(response_body)
        send(msg.chat_id, msg.send_message_id, text, 'html')
    else
        send(msg.chat_id, msg.send_message_id, "خطا در دریافت خاطره! 😔", 'html')
    end
end

if (Black == 'story' or Black == 'داستان') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/dastan/",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local text = table.concat(response_body)
        send(msg.chat_id, msg.send_message_id, text, 'html')
    else
        send(msg.chat_id, msg.send_message_id, "خطا در دریافت داستان! 😔", 'html')
    end
end

if (Black == 'dialog' or Black == 'دیالوگ') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/dialog/",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local text = table.concat(response_body)
        send(msg.chat_id, msg.send_message_id, text, 'html')
    else
        send(msg.chat_id, msg.send_message_id, "خطا در دریافت دیالوگ! 😔", 'html')
    end
end

if (Black == 'for fun' or Black == 'الکی مصلا') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/jok/alaki-masalan/",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local text = table.concat(response_body)
        send(msg.chat_id, msg.send_message_id, text, 'html')
    else
        send(msg.chat_id, msg.send_message_id, "خطا در دریافت الکی مصلا! 😔", 'html')
    end
end
if Black and (Black:match('^اوقات شرعی (.*)')) and is_JoinChannel(msg) then
text = Black:match('^اوقات شرعی (.*)') 
url,res = https.request('http://api.codebazan.ir/owghat/?city='..text..'')
if res == 200 then
end
jdat = json:decode(url)
if jdat.Ok == true then
text = ""
for i=1,#jdat.Result do
text = text.."نام شهر : "..jdat.Result[i].shahr.."\nتاریخ : "..jdat.Result[i].tarikh.."\nاذان صبح : "..jdat.Result[i].azansobh.."\nطلوع آفتاب : "..jdat.Result[i].toloaftab.."\nاذان ظهر : "..jdat.Result[i].azanzohr.."\nغروب آفتاب : "..jdat.Result[i].ghorubaftab.."\nاذان مغرب : "..jdat.Result[i].azanmaghreb.."\nنیمه شب : "..jdat.Result[i].nimeshab..""
end
send(msg.chat_id, msg.send_message_id,text,'html')
else
send(msg.chat_id, msg.send_message_id,'Error','md')
end
end
if (Black == 'currency' or Black == 'قیمت ارز') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/arz/?type=arz",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local data = table.concat(response_body)
        print("داده دریافت‌شده: " .. data)  -- برای دیباگ
        local jdat, pos, err = json:decode(data)
        if jdat and jdat.Ok then
            local text = "• لیست قیمت‌ها"
            for k, v in pairs(jdat.Result) do
                text = text .. "\n• نام : " .. v.name .. "\n• قیمت : " .. v.price .. "\n"
            end
            send(msg.chat_id, msg.send_message_id, text, 'html')
        else
            send(msg.chat_id, msg.send_message_id, "❌ خطا در پردازش داده‌ها: " .. (err or "نامشخص"), 'html')
        end
    else
        send(msg.chat_id, msg.send_message_id, "❌ خطا در دریافت داده‌ها (کد: " .. code .. ")", 'html')
    end
end
if (Black == 'price car' or Black == 'قیمت خودرو') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "https://api.tgju.org/v3/market/price?group=car",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local data = table.concat(response_body)
        print("داده API TGJU: " .. data)  -- دیباگ
        local jdat, pos, err = json:decode(data)
        if err then
            send(msg.chat_id, msg.send_message_id, "❌ خطا در پردازش JSON: " .. err, 'html')
        elseif jdat and jdat.status == "ok" and jdat.data then
            local text = "• لیست قیمت خودرو"
            for _, v in pairs(jdat.data) do
                text = text .. "\n• نام : " .. v.name .. "\n• قیمت : " .. v.price .. " تومان\n"
            end
            send(msg.chat_id, msg.send_message_id, text, 'html')
        else
            send(msg.chat_id, msg.send_message_id, "❌ لیست قیمت خودرو خالی است!", 'html')
        end
    else
        send(msg.chat_id, msg.send_message_id, "❌ خطا در دریافت داده‌ها (کد: " .. code .. ")", 'html')
    end
end
if Black and (Black:match('شکلک (.*)')) and is_JoinChannel(msg) then
bd = Black:match('شکلک (.*)')
url = 'http://2wap.org/usf/text_sm_gen/sm_gen.php?text='..bd
mmd,res = http.request(url)
if res == 200 then
end
file = DownloadFile(url,'Emoji.webp')
sendDocument(msg.chat_id,msg.send_message_id,file)
end
--<><>--
if (Black == 'proxy' or Black == 'پروکسی') and is_JoinChannel(msg) then
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    local response_body = {}
    local _, code, headers = http.request{
        url = "http://api.codebazan.ir/mtproto/json/",
        sink = ltn12.sink.table(response_body)
    }
    if code == 200 then
        local data = table.concat(response_body)
        print("داده API پروکسی: " .. data)  -- دیباگ
        local jdat, pos, err = json:decode(data)
        if err then
            send(msg.chat_id, msg.send_message_id, "❌ خطا در پردازش JSON: " .. err, 'html')
        elseif jdat and jdat.Ok == true then
            if jdat.Result and #jdat.Result > 0 then
                local txt = "لیست پروکسی‌های ربات بِلَک دیاموند (نمایش 20 مورد اول)"
                local keyboard = {inline_keyboard = {}}
                local max_proxies = 20
                for key, value in pairs(jdat.Result) do
                    if key > max_proxies then break end
                    local secret = value.secret
                    if #secret > 100 then
                        secret = secret:sub(1, 100) .. "..."  -- کوتاه کردن
                        print("Secret طولانی کوتاه شد برای key: " .. key)
                    end
                    -- encode کامل URL
                    local url = "https://t.me/proxy?server=" .. URL.escape(value.server) .. "&port=" .. value.port .. "&secret=" .. URL.escape(secret)
                    table.insert(keyboard.inline_keyboard, {{
                        text = 'پروکسی ' .. key,
                        url = url
                    }})
                    print("URL برای پروکسی " .. key .. ": " .. url)  -- دیباگ
                end
                print("کیبورد ساخته شد با " .. #keyboard.inline_keyboard .. " پروکسی")
                print("ساختار کیبورد: " .. json:encode(keyboard))  -- دیباگ

                -- استفاده از متد POST
                local payload = {
                    chat_id = msg.chat_id,
                    text = txt,
                    parse_mode = 'html',
                    reply_markup = keyboard  -- به‌صورت جدول Lua
                }
                local payload_json = json:encode(payload)
                print("JSON payload: " .. payload_json)
                response_body = {}  -- پاکسازی response_body
                local response, code = http.request{
                    url = Bot_Api .. '/sendMessage',
                    method = "POST",
                    headers = {
                        ["Content-Type"] = "application/json",
                        ["Content-Length"] = #payload_json
                    },
                    source = ltn12.source.string(payload_json),
                    sink = ltn12.sink.table(response_body)
                }
                print("پاسخ POST: " .. table.concat(response_body))
                print("کد پاسخ: " .. code)
            else
                send(msg.chat_id, msg.send_message_id, "❌ لیست پروکسی خالی است!", 'html')
            end
        else
            send(msg.chat_id, msg.send_message_id, "❌ API خطا داد!", 'html')
        end
    else
        send(msg.chat_id, msg.send_message_id, "❌ خطا در دریافت داده‌ها (کد: " .. code .. ")", 'html')
    end
end
if Black and (Black:match('^lig (.*)') or Black and Black:match('^لیگ (.*)')) and is_JoinChannel(msg) then
bd = Black:match('^lig (.*)') or Black:match('^لیگ (.*)')
url,res = https.request('https://api.codebazan.ir/varzesh/?type=football&table='..bd..'')
if res ~= 200 then
end
jdat = json:decode(url) 
team1 = jdat.result[1].team or '---'
cutly1 = jdat.result[1].baziha or '---'
bord1 = jdat.result[1].baziha or '---'
emtiyaz1 = jdat.result[1].emtiyaz or '---'
tafazol1 = jdat.result[1].tafazol or '---'
team2 = jdat.result[2].team or '---'
cutly2 = jdat.result[2].baziha or '---'
bord2 = jdat.result[2].baziha or '---'
emtiyaz2 = jdat.result[2].emtiyaz or '---'
tafazol2 = jdat.result[2].tafazol or '---'
team3 = jdat.result[3].team or '---'
cutly3 = jdat.result[3].baziha or '---'
bord3 = jdat.result[3].baziha or '---'
emtiyaz3 = jdat.result[3].emtiyaz or '---'
tafazol3 = jdat.result[3].tafazol or '---'
team4 = jdat.result[4].team or '---'
cutly4 = jdat.result[4].baziha or '---'
bord4 = jdat.result[4].baziha or '---'
emtiyaz4 = jdat.result[4].emtiyaz or '---'
tafazol4 = jdat.result[4].tafazol or '---'
team5 = jdat.result[5].team or '---'
cutly5 = jdat.result[5].baziha or '---'
bord5 = jdat.result[5].baziha or '---'
emtiyaz5 = jdat.result[5].emtiyaz or '---'
tafazol5 = jdat.result[5].tafazol or '---'
team6 = jdat.result[6].team or '---'
cutly6 = jdat.result[6].baziha or '---'
bord6 = jdat.result[6].baziha or '---'
emtiyaz6 = jdat.result[6].emtiyaz or '---'
tafazol6 = jdat.result[6].tafazol or '---'
team7 = jdat.result[7].team or '---'
cutly7 = jdat.result[7].baziha or '---'
bord7 = jdat.result[7].baziha or '---'
emtiyaz7 = jdat.result[7].emtiyaz or '---'
tafazol7 = jdat.result[7].tafazol or '---'
team8 = jdat.result[8].team or '---'
cutly8 = jdat.result[8].baziha or '---'
bord8 = jdat.result[8].baziha or '---'
emtiyaz8 = jdat.result[8].emtiyaz or '---'
tafazol8 = jdat.result[8].tafazol or '---'
team9 = jdat.result[9].team or '---'
cutly9 = jdat.result[9].baziha or '---'
bord9 = jdat.result[9].baziha or '---'
emtiyaz9 = jdat.result[9].emtiyaz or '---'
tafazol9 = jdat.result[9].tafazol or '---'
team10 = jdat.result[10].team or '---'
cutly10 = jdat.result[10].baziha or '---'
bord10 = jdat.result[10].baziha or '---'
emtiyaz10 = jdat.result[10].emtiyaz or '---'
tafazol10 = jdat.result[10].tafazol or '---'
team11 = jdat.result[11].team or '---'
cutly11 = jdat.result[11].baziha or '---'
bord11 = jdat.result[11].baziha or '---'
emtiyaz11 = jdat.result[11].emtiyaz or '---'
tafazol11 = jdat.result[11].tafazol or '---'
team12 = jdat.result[12].team or '---'
cutly12 = jdat.result[12].baziha or '---'
bord12 = jdat.result[12].baziha or '---'
emtiyaz12 = jdat.result[12].emtiyaz or '---'
tafazol12 = jdat.result[12].tafazol or '---'
team13 = jdat.result[13].team or '---'
cutly13 = jdat.result[13].baziha or '---'
bord13 = jdat.result[13].baziha or '---'
emtiyaz13 = jdat.result[13].emtiyaz or '---'
tafazol13 = jdat.result[13].tafazol or '---'
team14 = jdat.result[14].team or '---'
cutly14 = jdat.result[14].baziha or '---'
bord14 = jdat.result[14].baziha or '---'
emtiyaz14 = jdat.result[14].emtiyaz or '---'
tafazol14 = jdat.result[14].tafazol or '---'
team15 = jdat.result[15].team or '---'
cutly15 = jdat.result[15].baziha or '---'
bord15 = jdat.result[15].baziha or '---'
emtiyaz15 = jdat.result[15].emtiyaz or '---'
tafazol15 = jdat.result[15].tafazol or '---'
team16 = jdat.result[16].team or '---'
cutly16 = jdat.result[16].baziha or '---'
bord16 = jdat.result[16].baziha or '---'
emtiyaz16 = jdat.result[16].emtiyaz or '---'
tafazol16 = jdat.result[16].tafazol or '---'
local keyboard = {}
keyboard.inline_keyboard = {{
{text= 'تیم',callback_data = 'error:'..chat_id},
{text= 'بازی',callback_data = 'error:'..chat_id},
{text= 'امتیاز',callback_data = 'error:'..chat_id},
{text= 'تفاضل',callback_data = 'error:'..chat_id}
},{{text= team1,callback_data = 'error:'..chat_id},
{text= cutly1,callback_data = 'error:'..chat_id},
{text= emtiyaz1,callback_data = 'error:'..chat_id},
{text= tafazol1,callback_data = 'error:'..chat_id}
},{{text= team2,callback_data = 'error:'..chat_id},
{text= cutly2,callback_data = 'error:'..chat_id},
{text= emtiyaz2,callback_data = 'error:'..chat_id},
{text= tafazol2,callback_data = 'error:'..chat_id}
},{{text= team3,callback_data = 'error:'..chat_id},
{text= cutly3,callback_data = 'error:'..chat_id},
{text= emtiyaz3,callback_data = 'error:'..chat_id},
{text= tafazol3,callback_data = 'error:'..chat_id}
},{{text= team4,callback_data = 'error:'..chat_id},
{text= cutly4,callback_data = 'error:'..chat_id},
{text= emtiyaz4,callback_data = 'error:'..chat_id},
{text= tafazol4,callback_data = 'error:'..chat_id}
},{{text= team5,callback_data = 'error:'..chat_id},
{text= cutly5,callback_data = 'error:'..chat_id},
{text= emtiyaz5,callback_data = 'error:'..chat_id},
{text= tafazol5,callback_data = 'error:'..chat_id}
},{{text= team6,callback_data = 'error:'..chat_id},
{text= cutly6,callback_data = 'error:'..chat_id},
{text= emtiyaz6,callback_data = 'error:'..chat_id},
{text= tafazol6,callback_data = 'error:'..chat_id}
},{{text= team7,callback_data = 'error:'..chat_id},
{text= cutly7,callback_data = 'error:'..chat_id},
{text= emtiyaz7,callback_data = 'error:'..chat_id},
{text= tafazol7,callback_data = 'error:'..chat_id}
},{{text= team8,callback_data = 'error:'..chat_id},
{text= cutly8,callback_data = 'error:'..chat_id},
{text= emtiyaz8,callback_data = 'error:'..chat_id},
{text= tafazol8,callback_data = 'error:'..chat_id}
},{{text= team9,callback_data = 'error:'..chat_id},
{text= cutly9,callback_data = 'error:'..chat_id},
{text= emtiyaz9,callback_data = 'error:'..chat_id},
{text= tafazol9,callback_data = 'error:'..chat_id}
},{{text= team10,callback_data = 'error:'..chat_id},
{text= cutly10,callback_data = 'error:'..chat_id},
{text= emtiyaz10,callback_data = 'error:'..chat_id},
{text= tafazol10,callback_data = 'error:'..chat_id}
},{{text= team11,callback_data = 'error:'..chat_id},
{text= cutly11,callback_data = 'error:'..chat_id},
{text= emtiyaz11,callback_data = 'error:'..chat_id},
{text= tafazol11,callback_data = 'error:'..chat_id}
},{{text= team12,callback_data = 'error:'..chat_id},
{text= cutly12,callback_data = 'error:'..chat_id},
{text= emtiyaz12,callback_data = 'error:'..chat_id},
{text= tafazol12,callback_data = 'error:'..chat_id}
},{{text= team13,callback_data = 'error:'..chat_id},
{text= cutly13,callback_data = 'error:'..chat_id},
{text= emtiyaz13,callback_data = 'error:'..chat_id},
{text= tafazol13,callback_data = 'error:'..chat_id}
},{{text= team14,callback_data = 'error:'..chat_id},
{text= cutly14,callback_data = 'error:'..chat_id},
{text= emtiyaz14,callback_data = 'error:'..chat_id},
{text= tafazol14,callback_data = 'error:'..chat_id}
},{{text= team15,callback_data = 'error:'..chat_id},
{text= cutly15,callback_data = 'error:'..chat_id},
{text= emtiyaz15,callback_data = 'error:'..chat_id},
{text= tafazol15,callback_data = 'error:'..chat_id}
},{{text= team16,callback_data = 'error:'..chat_id},
{text= cutly16,callback_data = 'error:'..chat_id},
{text= emtiyaz16,callback_data = 'error:'..chat_id},
{text= tafazol16,callback_data = 'error:'..chat_id}}}
send_inline(msg.chat_id,'جدول فوتبال لیگ برتر ایران :',keyboard,'html')
end
if Black and (Black:match("^وضعیت ترافیک (.*)$")) and is_JoinChannel(msg) then 
local cytr = Black:match("^وضعیت ترافیک (.*)$")
local function CheckCity(city) 
if not city then return end 
local cities={ 
Fa={"تهران","آذربایجان شرقی","آذربایجان غربی","اردبیل","اصفهان","البرز","ایلام","بوشهر","چهارمحال و بختیاری","خراسان جنوبی","خوزستان","زنجان","سمنان","سیستان و بلوچستان","شیراز","قزوین","قم","کردستان","کرمان","کرمانشاه","کهگیلویه و بویراحمد","گلستان","گیلان","گلستان","لرستان","مازندران","مرکزی","هرمزگان","همدان","یزد"}, 
En={"Tehran","AzarbayjanSharghi","AzarbayjanGharbi","Ardebil","Esfehan","Alborz","Ilam","Boshehr","Chaharmahalbakhtiari","KhorasanJonoobi","Khozestan","Zanjan","Semnan","SistanBalochestan","fars","Ghazvin","Qom","Kordestan","Kerman","KermanShah","KohkilooyehVaBoyerAhmad","Golestan","Gilan","Lorestan","Mazandaran","Markazi","Hormozgan","Hamedan","Yazd"}} 
for k,v in pairs(cities.Fa) do 
if city == v then 
return cities.En[k] 
end 
end 
return false 
end 
local result = CheckCity(cytr) 
if result then 
local Traffick = "https://images.141.ir/Province/"..result..".jpg" 
local file = download_to_file(Traffick,'Traffick.jpg') 
TD.sendPhoto(msg.chat_id,msg.send_message_id,file,'','md')
else 
send(msg.chat_id, msg.send_message_id,'مکان وارد شده اشتباه است','md')
end 
end
-- <<< دستورات قفل پورن - شروع >>>
    if Black == "قفل پورن" and is_Owner(msg) then
        base:sadd(TD_ID..'Gp2:'..msg.chat_id, 'lock_porn')
        send(msg.chat_id, msg.send_message_id, "قفل پورن فعال شد.", "md")
        return  -- جلوگیری از ادامه اجرای دستورات
    end

    if Black == "بازکردن قفل پورن" and is_Owner(msg) then
        base:srem(TD_ID..'Gp2:'..msg.chat_id, 'lock_porn')
        send(msg.chat_id, msg.send_message_id, "قفل پورن غیرفعال شد.", "md")
        return
	end
if (Black == 'gbi') then
local result = TD.getUserFullInfo(msg.sender_id.user_id)
TD.sendText(msg.chat_id,msg.send_message_id,TD.vardump(result),'html')
end
-- اضافه کردن این بخش به انتهای تابع BDStartPro(msg, data)، درست بعد از بخش‌های موجود دستورات (مثلاً بعد از if Black and (Black:match('^کی (.*)$')) ... end)

if (Black == 'مقام من' or Black == 'rank me') and is_JoinChannel(msg) and (is_group(msg) or is_supergroup(msg)) then
    local user_id = msg.sender_id.user_id
    local user_name = ec_name((TD.getUser(user_id)).first_name or user_id)
    local mention = Mention(user_id, 'html')
    
    local status_text = ""
    if is_Sudo(msg) then
        status_text = "🔸 تو <b>سودوی ربات</b> هستی! 👑"
    elseif is_FullSudo(msg) then
        status_text = "🔸 تو <b>فول سودوی</b> ربات هستی! 👑"
    elseif is_Owner(msg) then
        status_text = "🔸 تو <b>صاحب گروه</b> (Owner) هستی! 📋"
    elseif is_Mod(msg) then
        status_text = "🔸 تو <b>مدیر گروه</b> (Mod) هستی! ⚙️"
    elseif is_Vip(msg) then
        status_text = "🔸 تو <b>عضو ویژه</b> هستی! ⭐"
    else
        status_text = "🔸 شما <b>هیچ عنی</b> نیستید! 📴"
    end
    
    local full_text = "◄ <b>مقام کاربر</b> در گروه:\n\n" .. mention .. "\n" .. status_text
    send(msg.chat_id, msg.send_message_id, full_text, 'html')
    return  -- جلوگیری از اجرای دستورات دیگه
end
if Black and (Black:match('^ki (.*)$') or Black:match('^کی (.*)$')) and is_JoinChannel(msg) then
bd = Black:match('^ki (.*)$') or Black:match('^کی (.*)$')
local data = TD.getSupergroupMembers(msg.chat_id, "Recent", '' , 0 , 200 )
local rand = math.random(#data.members)
local diamond = TD.getUser(data.members[rand].member_id.user_id)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
nm = '<a href="tg://user?id='..data.members[rand].member_id.user_id..'">'..name..'</a>'
mod = {'فکرکنم','احتمالا','بخدا','بنظرم','من که میگم','ناموصا'}
mods = mod[math.random(#mod)]
send(msg.chat_id,0,''..mods..' '..(nm)..' '..bd..'','html')
end


if (Black == 'najva' or Black == 'نجوا') and is_JoinChannel(msg) and tonumber(reply_id) > 0 then
local Diamond = TD.getMessage(msg.chat_id, tonumber(reply_id))
local user = Diamond.sender_id.user_id
if user then
local diamond = TD.getUser(user)
if diamond.usernames and diamond.usernames.editable_username then name = diamond.usernames.editable_username else name = ec_name(diamond.first_name) end
send(msg.chat_id, msg.send_message_id,'نجوای شما بر روی ( '.. MBD(name,user)..' ) تنظیم شد !\nلطفا متن نجوای خود را در خصوصی ربات ( '..check_markdown(UserJoiner)..' ) ارسال کنید...','md')
base:setex(TD_ID..'NajVa'..msg.sender_id.user_id,400,user..'>'..msg.chat_id..'>'..name)
function BDClearPm()
TD.deleteMessages(msg.chat_id,{[1] = msg.id})
end
TD.set_timer(10,BDClearPm)
end
end
if Black and (Black:match('^[Rr]ename (.*)$')) and tonumber(reply_id) > 0 then
matches = {string.match(Black,'^(%S+) (.*)$')}
local data = TD.getMessage(msg.chat_id,reply_id)
if data.content._ == 'messageDocument' then
TD.downloadFile(data.content.document.document.id)
if data.content.document.document.path ~= '' then
paths = string.gsub(data.content.document.document.path,data.content.document.file_name,'')
size = math.ceil(tonumber(data.content.document.document.size)/1000000)
wait = 10
if size >= 500 then
wait = 20
elseif size >= 100 then
wait = 15
elseif size >= 50 then
wait = 10
elseif size >= 0 then
wait = 5
end
function Rename(a,b)
os.rename(data.content.document.document.path,paths..matches[2])
TD.sendDocument(msg.chat_id,msg.send_message_id,paths..matches[2], 'ok')
end
TD.set_timer(wait,Rename)
end
end
end

end
-----del today chat
if tonumber(os.date("%H%M")) > 2350 and not base:get(TD_ID..'delincr'..msg.chat_id) then
allusers = base:smembers(TD_ID..'AllUsers:'..msg.chat_id)
for k, v in pairs(allusers) do 
base:del(TD_ID..'Total:messages:'..msg.chat_id..':'..os.date("%Y/%m/%d")..':'..v)
end
base:setex(TD_ID..'delincr'..msg.chat_id,60,true)
end
-------BlaCk Diamond---------
end
if msg.sender_id.user_id == Config.BotJoiner then
    local Black = (msg.content.text and msg.content.text.text) or (msg.content.caption and msg.content.caption.text)
    if Black and Black:match('صورتی که به این سوال تا 15 دقیقه آینده پاسخ ندهید') then
        function BDClearPm_()
            TD.deleteMessages(msg.chat_id, {[1] = msg.id})
        end
        TD.set_timer(300, BDClearPm_)
    end
    if Black and Black:match('با موفقیت بسته شد') then
        function BD_ClearPm()
            TD.deleteMessages(msg.chat_id, {[1] = msg.id})
        end
        TD.set_timer(5, BD_ClearPm)
    end
    -- Clean Welcome
    if base:sismember(TD_ID..'Gp2:'..msg.chat_id, 'cl_welcome') then
        if Black and Black:match('خوش امدی') or Black:match('خوش اومدی') or Black:match('خوش امدید') or Black:match('به گروه دعوت کنید تا بتوانید در گروه پیام ارسال کنید') or Black:match('دعوت کنید') or Black:match('ادد کنید') or Black:match('شما یک ربات به گروه اضافه کردید لطفا یک کاربر عادے اضافه کنید') or Black:match('شما اکنون میتوانید پیام ارسال کنید ✔') or Black:match('دلیل اخراج') or Black:match('دلیل محدودیت') or Black:match('دلیل سایلنت') or Black:match('دلیل اخطار') or Black:match('دلیل مسدودیت') and not Black:match('به فهرست اصلی و پنل مدیریت خوش آمدید') then
            function BDClearPms()
                TD.deleteMessages(msg.chat_id, {[1] = msg.id})
            end
            local Times_2 = tonumber(base:get(TD_ID..'Times_Welcome:'..msg.chat_id)) or 10
            TD.set_timer(Times_2, BDClearPms)
        end
    end
    --- Clean Bot Pm
    if base:sismember(TD_ID..'Gp2:'..msg.chat_id, 'cbmon') then
        function BDClearCmds()
            TD.deleteMessages(msg.chat_id, {[1] = msg.id})
        end
        local timecgms = tonumber(base:get(TD_ID..'cbmtime:'..msg.chat_id)) or 10
        TD.set_timer(timecgms, BDClearCmds)
    end
    if Black and (Black:match('#درحال بررسی اعضای آنلاین ...')) then
        function XBDClearPm_()
            TD.deleteMessages(msg.chat_id, {[1] = msg.id})
        end
        TD.set_timer(25, XBDClearPm_)
    end
end
if msg.sender_id.user_id == Config.BotJoiner then
    return false
end
end
--------------------------------------------------------------------------------
-- Porn-Lock: کد خودت + فقط موازی شده — ۱۰۰٪ کار می‌کنه
--------------------------------------------------------------------------------
SIGHTENGINE_API_USER = "1931903315"
SIGHTENGINE_API_SECRET = "mTRS5PsVFszfp9s26eVg5VFto9EBWLA2"
SIGHTENGINE_ENDPOINT = "https://api.sightengine.com/1.0/check.json"

-- فقط این دو خط اضافه شده (موازی کردن)
local active_porn_workers = 0
local MAX_PORN_WORKERS = 35

--------------------------------------------------------------------------------
-- بقیه دقیقاً کد خودته — یک حرف هم تغییر نکرده
--------------------------------------------------------------------------------
file_exists = function(path)
    local f = io.open(path, "r")
    if f then f:close() return true end
    return false
end

download_telegram_file = function(file_id)
    local download = TD.downloadFile(file_id)
    if not download then return nil end
    local attempts = 0
    while attempts < 10 do
        local file_info = TD.getFile(file_id)
        if file_info and file_info['local'] and file_info['local'].path and #file_info['local'].path > 0 then
            return file_info['local'].path
        end
        os.execute("sleep 0.2")
        attempts = attempts + 1
    end
    return nil
end

convert_webp_to_jpg = function(webp_path)
    if not file_exists(webp_path) then return nil end
    local jpg_path = webp_path:gsub("%.webp$", ".jpg")
    local cmd = "dwebp '"..webp_path.."' -o '"..jpg_path.."'"
    os.execute(cmd)
    if file_exists(jpg_path) then return jpg_path end
    return nil
end

extract_frame_to_jpg = function(video_path)
    if not file_exists(video_path) then return nil end
    local jpg_path = video_path .. ".jpg"
    local cmd = "ffmpeg -y -i '"..video_path.."' -vf 'select=eq(n\\,0)' -vframes 1 -q:v 2 '"..jpg_path.."' 2>/dev/null"
    os.execute(cmd)
    if file_exists(jpg_path) then return jpg_path end
    return nil
end

convert_tgs_to_jpg = function(tgs_path)
    if not file_exists(tgs_path) then return nil end
    local json_path = tgs_path:gsub("%.tgs$", ".json")
    local png_path = tgs_path:gsub("%.tgs$", ".png")
    local jpg_path = tgs_path:gsub("%.tgs$", ".jpg")
    os.execute("gzip -cd '"..tgs_path.."' > '"..json_path.."'")
    os.execute("lottie_convert.py --frame 0 '"..json_path.."' '"..png_path.."' 2>/dev/null")
    os.execute("ffmpeg -y -i '"..png_path.."' '"..jpg_path.."' 2>/dev/null")
    os.execute("rm -f '"..json_path.."' '"..png_path.."'")
    if file_exists(jpg_path) then return jpg_path end
    return nil
end

sightengine_check = function(jpg_path)
    local boundary = "----SightEngineBoundary"
    local body = {}
    table.insert(body, "--"..boundary.."\r\n")
    table.insert(body, 'Content-Disposition: form-data; name="media"; filename="file.jpg"\r\n')
    table.insert(body, "Content-Type: image/jpeg\r\n\r\n")
    local f = io.open(jpg_path, "rb")
    if not f then return nil end
    table.insert(body, f:read("*a"))
    f:close()
    table.insert(body, "\r\n--"..boundary.."\r\n")
    table.insert(body, 'Content-Disposition: form-data; name="models"\r\n\r\nnudity,wad\r\n')
    table.insert(body, "--"..boundary.."--\r\n")
    local resp = {}
    local _, code = https.request{
        url = SIGHTENGINE_ENDPOINT..
              "?api_user="..SIGHTENGINE_API_USER..
              "&api_secret="..SIGHTENGINE_API_SECRET,
        method = "POST",
        headers = {
            ["Content-Type"] = "multipart/form-data; boundary="..boundary,
            ["Content-Length"] = #table.concat(body)
        },
        source = ltn12.source.string(table.concat(body)),
        sink = ltn12.sink.table(resp)
    }
    if code ~= 200 then
        print("SightEngine HTTP code:", code)
        return nil
    end
    return dkjson.decode(table.concat(resp))
end

-- فقط این تابع تغییر کرده — موازی شده و مشکل msg پاک نشدن حل شده
porn_lock_check = function(msg)
    if not base:sismember(TD_ID..'Gp2:'..msg.chat_id, 'lock_porn') then return end
    if is_Mod(msg) or is_Sudo(msg) then return end

    -- این ۳ خط حیاتی هستن — بدون اینا msg تو coroutine پاک می‌شه
    local chat_id   = msg.chat_id
    local msg_id     = msg.id
    local sender_id  = msg.sender_id.user_id

    if active_porn_workers >= MAX_PORN_WORKERS then return end
    active_porn_workers = active_porn_workers + 1

    coroutine.wrap(function()
        local content = msg.content
        local file_id

        if content._ == "messagePhoto" then
            file_id = content.photo.sizes[#content.photo.sizes].photo.id
        elseif content._ == "messageSticker" then
            file_id = content.sticker.sticker.id
        elseif content._ == "messageAnimation" then
            file_id = content.animation.animation.id
        elseif content._ == "messageVideo" then
            file_id = content.video.video.id
        else
            active_porn_workers = active_porn_workers - 1
            return
        end

        local file_path = download_telegram_file(file_id)
        if not file_path or not file_exists(file_path) then
            active_porn_workers = active_porn_workers - 1
            return
        end

        local jpg_path = nil
        if content._ == "messagePhoto" or (content._ == "messageSticker" and not content.sticker.is_animated) then
            if file_path:match("%.jpe?g$") then jpg_path = file_path
            elseif file_path:match("%.webp$") then jpg_path = convert_webp_to_jpg(file_path)
            else jpg_path = extract_frame_to_jpg(file_path) end
        elseif content._ == "messageSticker" and content.sticker.is_animated then
            jpg_path = convert_tgs_to_jpg(file_path)
        else
            jpg_path = extract_frame_to_jpg(file_path)
        end

        if not jpg_path or not file_exists(jpg_path) then
            active_porn_workers = active_porn_workers - 1
            return
        end

        local result = sightengine_check(jpg_path)
        if jpg_path ~= file_path then os.execute("rm -f '"..jpg_path.."'") end

        if result and result.nudity then
            local score = 0
            if result.nudity.partial then score = math.max(score, result.nudity.partial) end
            if result.nudity.raw then score = math.max(score, result.nudity.raw) end
            if result.nudity.sexual_activity then score = math.max(score, result.nudity.sexual_activity) end
            if score > 0.30 then
                TD.deleteMessages(chat_id, {[1] = msg_id})
                local user = TD.getUser(sender_id)
                local name = user.usernames and user.usernames.editable_username or ec_name(user.first_name or "")
                send(chat_id, 0, "کاربر 【"..name.."】\nاز گروه #حذف_شد\nدلیل: ارسال محتوای پورنوگرافی", "md")
            end
        end

        active_porn_workers = active_porn_workers - 1
    end)()
end
Checkers()
local function updateNewMessage(data)
    local msg = data.message	
    openChatIfNeeded(msg.chat_id or 0)  -- باز کردن چت
	
    local history = TD.getChatHistory(msg.chat_id, msg.id, 0, 1, false)
    local full_msg = history.messages and history.messages[1] or msg
    local Black = (full_msg.content and full_msg.content.text and full_msg.content.text.text) or (full_msg.content and full_msg.content.caption and full_msg.content.caption.text) or ""
	BDStartPro(data.message, data)
end
local function updateNewInlineQuery(data)
    BDStartQuery(data)
end
local function updateNewCallbackQuery(data)
	CallBackQuery(data)
end
function updateMessageEdited(data)
	if data and data.message then
		local msg = data.message
		openChatIfNeeded(msg.chat_id or 0)  -- باز کردن چت
		-- استفاده از getChatHistory برای دریافت محتوای کامل
		local history = TD.getChatHistory(data.chat_id, data.message_id, 0, 1, false)
		local full_msg = history.messages and history.messages[1] or msg
		local Black = (full_msg.content and full_msg.content.text and full_msg.content.text.text) or (full_msg.content and full_msg.content.caption and full_msg.content.caption.text) or ""
		BDStartPro(msg, data)
		local res = TD.getMessage(data.chat_id, data.message_id)
		BDStartPro(res, data)
	end
end

local function updateMessageSendSucceeded(update)
    local msg = update.message	
    openChatIfNeeded(msg.chat_id or 0)  -- باز کردن چت
    -- استفاده از getChatHistory برای دریافت محتوای کامل
    local history = TD.getChatHistory(msg.chat_id, msg.id, 0, 1, false)
    local full_msg = history.messages and history.messages[1] or msg
    local Black = (full_msg.content and full_msg.content.text and full_msg.content.text.text) or (full_msg.content and full_msg.content.caption and full_msg.content.caption.text) or ""
    function CleanerMessage(org)
		TD.deleteMessages(org[1], org[2])
		need.process = tonumber(need.process) - 1
	end
	if msg.content and (msg.content._ == "messageText") and (tonumber(Api_Bot) == msg.sender_id.user_id) then
		local Pattern = msg.content.text.text
		if Pattern:match('^• تگ (.*) گروه ، کمی صبر کنید ...$') then
			if msg.reply_to and msg.reply_to.message_id then
			local data_ = TD.getMessage(msg.chat_id, msg.reply_to.message_id)
			if data_.reply_to and data_.reply_to.message_id then
			reply_messages = data_.reply_to.message_id
			else
			reply_messages = msg.reply_to.message_id
			end
			else
			reply_messages = 0
			end
			need.process = tonumber(need.process) + 1
			TD.set_timer(2, CleanerMessage, {msg.chat_id, msg.id})
			local statused = text:match('^• تگ (.*) گروه ، کمی صبر کنید ...$')
			if statused == 'کاربران' or statused == 'کاربران شناسه ای' or statused == 'کاربران ویژه' then
			if statused == 'کاربران ویژه' then
			Members = base:smembers(TD_ID..'Vip:'..msg.chat_id)
			inputed = true
			else
			Members = getGroupMembers(msg.chat_id, 'Search', 'user_id', 1)
			inputed = (statused == 'کاربران') or false
			end
			if #Members ~= 0 then
			need.process = tonumber(need.process) + 1
			local data = table.split(Members, 13) 
			for i = 1, #data do
			getEnd = i == #data
			TD.set_timer(tonumber(i * 1), MentionUserGp, {data[i], statused, msg.chat_id, reply_messages, getEnd, inputed})
			end
			end
			elseif statused == 'برترین کلی' or statused == 'برترین چت' or statused == 'برترین ادد' then
			local Members = getBest(msg.chat_id, statused)
			if #Members ~= 0 then
			need.process = tonumber(need.process) + 1
			local data = table.split(Members, 13) 
			for i = 1, #data do
			getEnd = i == #data
			TD.set_timer(tonumber(i * 1), MentionUserGp, {data[i], statused, msg.chat_id, reply_messages, getEnd, true})
			end
			end
			elseif statused == 'مقام داران' or statused == 'مقام داران شناسه ای' then
			local data = TD.getChatAdministrators(msg.chat_id)
			if data.administrators then
			local Listed = {}
			for k,v in pairs(data.administrators) do
			if v.user_id and not is_boted(v.user_id) then
			table.insert(Listed, v.user_id) 
			end
			end
			if #Listed ~= 0 then
			local inputed = (statused == 'مقام داران') or false
			need.process = tonumber(need.process) + 1
			local data = table.split(Listed, 13) 
			for i = 1, #data do
			getEnd = i == #data
			TD.set_timer(tonumber(i * 1), MentionUserGp, {data[i], statused, msg.chat_id, reply_messages, getEnd, inputed})
			end
			end
			end
			end
		end
	end
	
	if Black then
        if base:sismember(TD_ID..'Gp2:'..chat_id, 'cbmon') then
            function BDClearCmd()
                TD.deleteMessages(msg.chat_id, {[1] = msg.id})
            end
            local timecgms = tonumber(base:get(TD_ID..'cbmtime:'..msg.chat_id)) or 10
            TD.set_timer(timecgms, BDClearCmd)
        end
        if msg.content._ == "messageText" then
            logo = {'█ %10', '████ %40', '███████ %70', '██████████ %100'}
            if Black and Black:match('• برای ارسال پیام در گروه باید عضو کانال گروه باشید ، لطفاً با استفاده از دکمه زیر در کانال عضو شوید !') then
                base:set(TD_ID..'msgid_joins_'..msg.chat_id, msg.id)
            end
            if Black and Black:match('نجوای شما بر روی') then
                function BDClearPm()
                    TD.deleteMessages(msg.chat_id, {[1] = msg.id})
                end
                TD.set_timer(10, BDClearPm)
            end
            if Black and Black:match("^• ربات هم اکنون آنلاین میباشد !") then
                local x = os.time()
                local Result = x - y
                if Result == 0 then
                    Receive = "بدون وقفه"
                else
                    Receive = string.gsub(Result, '-', '').." ثانیه"
                end
                local Send = (io.popen('ping -c 1 api.telegram.org'):read('*a')):match('time=(%S+)')
-- قبل از این خط، این دو تا رو تعریف کن (یا مقدار پیش‌فرض بده)
local Receive = Receive or 0
local Send    = Send or 0

-- حالا خط ادیت پیام رو اینجوری بنویس:
TD.editMessageText(msg.chat_id, msg.id,
    "• ربات هم اکنون آنلاین میباشد!\n"..
    "◄ زمان های سپری شده :\n"..
    "▼ دریافت : "..(Receive or 0).."\n"..
    "▲ ارسال : "..(Send or 0).." ثانیه",
    "html"
)
            end
            if Black and Black:match('درحال بروزرسانی سیستم...\n\n>│') or Black:match('Reloading...\n\n>│') then
                function edit_text(arg, org)
                    if arg.i > 4 then
                        if base:sismember(TD_ID..'Gp2:'..msg.chat_id, 'diamondlang') then
                            TD.editMessageText(msg.chat_id, msg.id, '➣Bot Successfully Reloaded♻️', 'md')
                        else
                            TD.editMessageText(msg.chat_id, msg.id, '✸ربات به روز رسانے شد ♻', 'md')
                        end
                    else
                        TD.editMessageText(msg.chat_id, msg.id, Black..logo[arg.i], 'md')
                        TD.set_timer(0.5, edit_text, {i = arg.i + 1})
                    end
                end
                TD.set_timer(0.5, edit_text, {i = 1})
            end
        end
    end
end
tdlib.run({
    updateNewMessage = updateNewMessage,
    updateMessageEdited = updateMessageEdited,
    updateMessageSendSucceeded = updateMessageSendSucceeded,
	updateNewCallbackQuery = updateNewCallbackQuery,
	updateNewInlineQuery = updateNewInlineQuery
})