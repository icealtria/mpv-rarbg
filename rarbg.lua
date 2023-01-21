local language = {
    '2_English',
    '38_Chinese'
}

local utils = require 'mp.utils'

function find_subs()
    local path = mp.get_property("path", "")
    local dir, filename = utils.split_path(path)
    filename = remove_extension(filename)

    local subs_path = dir .. "/Subs/" .. filename .. "/"

    if not utils.file_info(subs_path) then
        mp.msg.warn("No subs folder found.")
        return
    end

    local subs = {}
    local files = utils.readdir(subs_path)
    for _, file in pairs(files) do
        for _, lang in pairs(language) do
            if string.find(file, lang) then
                table.insert(subs, subs_path .. file)
            end
        end

    end

    if #subs > 0 then
        for _, sub in pairs(subs) do
            mp.commandv("sub-add", sub)
        end
    else
        mp.msg.warn("No sub found.")
    end
end

function remove_extension(filename)
    local parts = {}
    for part in string.gmatch(filename, "[^.]+") do
        table.insert(parts, part)
    end
    table.remove(parts, #parts)
    filename = table.concat(parts, ".")
    return filename
end

mp.register_event("file-loaded", find_subs)
