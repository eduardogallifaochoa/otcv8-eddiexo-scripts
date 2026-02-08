setDefaultTab("Tools")

if not storage.dropper then
    storage.dropper = {
      enabled = false,
      trashItems = { 283, 284, 285 },
      useItems = { 21203, 14758 },
      capItems = { 21175 }
    }
end

local config = storage.dropper

local function properTable(t)
    local r = {}
  
    for _, entry in pairs(t) do
      table.insert(r, entry.id)
    end
    return r
end

macro(200, function()
    if not config.enabled then return end
    local tables = {properTable(config.capItems), properTable(config.useItems), properTable(config.trashItems)}

    local containers = getContainers()
    for i=1,3 do
        for _, container in pairs(containers) do
            for __, item in ipairs(container:getItems()) do
                for ___, userItem in ipairs(tables[i]) do
                    if item:getId() == userItem then
                        return i == 1 and freecap() < 150 and dropItem(item) or
                               i == 2 and use(item) or
                               i == 3 and dropItem(item)
                    end
                end
            end
        end
    end

end)
