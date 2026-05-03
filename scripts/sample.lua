local M = {}

function M.date_fmt(fmt)
    fmt = fmt or "%Y-%m-%d %H:%M:%S"
    local t = os.date("*t")
    return os.date(fmt, os.time(t))
end

function M.date_diff(s1, s2)
    local t1 = os.time({
        year = tonumber(s1:sub(1,4)), month = tonumber(s1:sub(6,7)),
        day = tonumber(s1:sub(9,10)), hour = tonumber(s1:sub(12,13)),
        min = tonumber(s1:sub(15,16)), sec = tonumber(s1:sub(18,19))
    })
    local t2 = os.time({
        year = tonumber(s2:sub(1,4)), month = tonumber(s2:sub(6,7)),
        day = tonumber(s2:sub(9,10)), hour = tonumber(s2:sub(12,13)),
        min = tonumber(s2:sub(15,16)), sec = tonumber(s2:sub(18,19))
    })
    return math.floor((t2 - t1) / 86400)
end

M.Task = {}
M.Task.__index = M.Task

function M.Task.new(title)
    return setmetatable({
        title = title, done = false, priority = 2,
        created = os.time(), deadline = nil, tags = {}
    }, M.Task)
end

function M.Task:mark_done() self.done = true; self.done_time = os.time() end
function M.Task:delay(days) self.deadline = (self.deadline or os.time()) + days * 86400 end
function M.Task:is_overdue() return self.deadline and os.time() > self.deadline and not self.done end
function M.Task:add_tag(tag) table.insert(self.tags, tag) end

M.TaskManager = {}
M.TaskManager.__index = M.TaskManager

function M.TaskManager.new()
    return setmetatable({tasks = {}, next_id = 1}, M.TaskManager)
end

function M.TaskManager:add(title, priority, deadline)
    local task = M.Task.new(title)
    task.id = self.next_id
    task.priority = priority or 2
    if deadline then
        local t = {}
        for d in deadline:gmatch("%d+") do table.insert(t, tonumber(d)) end
        task.deadline = os.time({year=t[1], month=t[2], day=t[3], hour=23, min=59, sec=59})
    end
    self.tasks[self.next_id] = task
    self.next_id = self.next_id + 1
    return task
end

function M.TaskManager:done(id)
    if self.tasks[id] then self.tasks[id]:mark_done() end
end

function M.TaskManager:delete(id) self.tasks[id] = nil end

function M.TaskManager:filter(opts)
    opts = opts or {}
    local result = {}
    for _, task in pairs(self.tasks) do
        if opts.done ~= nil and task.done ~= opts.done then goto continue end
        if opts.tag and not table.concat(task.tags):find(opts.tag) then goto continue end
        if opts.priority and task.priority ~= opts.priority then goto continue end
        if opts.overdue and not task:is_overdue() then goto continue end
        table.insert(result, task)
        ::continue::
    end
    table.sort(result, function(a, b)
        if a.done ~= b.done then return not a.done end
        if a.priority ~= b.priority then return a.priority < b.priority end
        return a.created > b.created
    end)
    return result
end

function M.TaskManager:report()
    local total, done, overdue = 0, 0, 0
    for _, t in pairs(self.tasks) do
        total = total + 1
        if t.done then done = done + 1
        elseif t:is_overdue() then overdue = overdue + 1 end
    end
    return {total = total, done = done, overdue = overdue, pending = total - done}
end

M.TimeRecorder = {}
M.TimeRecorder.__index = M.TimeRecorder

function M.TimeRecorder.new(name)
    return setmetatable({name = name, records = {}}, M.TimeRecorder)
end

function M.TimeRecorder:start(tag)
    if self.current then self:stop() end
    self.current = {tag = tag, start = os.time()}
end

function M.TimeRecorder:stop()
    if not self.current then return end
    local elapsed = os.time() - self.current.start
    self.current.end_time = os.time()
    self.current.duration = elapsed
    table.insert(self.records, self.current)
    self.current = nil
    return elapsed
end

function M.TimeRecorder:total_by_tag(tag)
    local total = 0
    for _, r in ipairs(self.records) do
        if r.tag == tag then total = total + r.duration end
    end
    return total
end

function M.TimeRecorder:report()
    local summary = {}
    for _, r in ipairs(self.records) do
        summary[r.tag] = (summary[r.tag] or 0) + r.duration
    end
    return summary
end

function M.TimeRecorder:fmt_duration(s)
    local h = math.floor(s / 3600)
    local m = math.floor((s % 3600) / 60)
    local sec = s % 60
    if h > 0 then return string.format("%dh %dm", h, m)
    elseif m > 0 then return string.format("%dm %ds", m, sec)
    else return string.format("%ds", sec) end
end

M.Pomodoro = {}
M.Pomodoro.__index = M.Pomodoro

function M.Pomodoro.new(work_min, break_min)
    return setmetatable({
        work_min = work_min or 25, break_min = break_min or 5,
        sessions = 0, state = "idle", start_time = nil, remaining = 0
    }, M.Pomodoro)
end

function M.Pomodoro:start()
    self.state = "working"
    self.start_time = os.time()
    self.remaining = self.work_min * 60
end

function M.Pomodoro:tick()
    if self.state == "idle" then return nil end
    self.remaining = self.remaining - 1
    if self.remaining <= 0 then
        if self.state == "working" then
            self.sessions = self.sessions + 1
            self.state = "break"
            self.remaining = self.break_min * 60
            return "break"
        else
            self.state = "idle"
            return "done"
        end
    end
    return nil
end

function M.Pomodoro:skip()
    self.state = "idle"
    self.remaining = 0
end

function M.Pomodoro:status()
    return {
        state = self.state,
        remaining = self.remaining,
        sessions = self.sessions,
        total_min = self.sessions * self.work_min
    }
end

M.Expense = {}
M.Expense.__index = M.Expense

function M.Expense.new()
    return setmetatable({items = {}, next_id = 1, balance = 0}, M.Expense)
end

function M.Expense:add(amount, category, note)
    local item = {
        id = self.next_id, amount = amount, category = category,
        note = note or "", date = os.date("%Y-%m-%d"), time = os.time()
    }
    self.next_id = self.next_id + 1
    table.insert(self.items, item)
    self.balance = self.balance + amount
    return item
end

function M.Expense:by_category()
    local cat = {}
    for _, item in ipairs(self.items) do
        cat[item.category] = (cat[item.category] or 0) + item.amount
    end
    return cat
end

function M.Expense:by_month(year, month)
    local month_str = string.format("%04d-%02d", year, month)
    local total = 0
    for _, item in ipairs(self.items) do
        if item.date:sub(1, 7) == month_str then total = total + item.amount end
    end
    return total
end

function M.Expense:report()
    return {
        total = self.balance,
        count = #self.items,
        by_category = self:by_category()
    }
end

M.Memo = {}
M.Memo.__index = M.Memo

function M.Memo.new()
    return setmetatable({notes = {}}, M.Memo)
end

function M.Memo:add(title, content)
    table.insert(self.notes, 1, {
        title = title, content = content,
        created = os.date("%Y-%m-%d %H:%M"), updated = os.date("%Y-%m-%d %H:%M")
    })
end

function M.Memo:search(keyword)
    local result = {}
    for _, n in ipairs(self.notes) do
        if n.title:find(keyword) or (n.content and n.content:find(keyword)) then
            table.insert(result, n)
        end
    end
    return result
end

function M.Memo:update(idx, title, content)
    if self.notes[idx] then
        self.notes[idx].title = title or self.notes[idx].title
        self.notes[idx].content = content or self.notes[idx].content
        self.notes[idx].updated = os.date("%Y-%m-%d %H:%M")
    end
end

M.Schedule = {}
M.Schedule.__index = M.Schedule

function M.Schedule.new()
    return setmetatable({events = {}}, M.Schedule)
end

function M.Schedule:add(start_time, end_time, title, location)
    table.insert(self.events, {
        start = start_time, end = end_time, title = title, location = location
    })
    table.sort(self.events, function(a, b) return a.start < b.start end)
end

function M.Schedule:today()
    local today_str = os.date("%Y-%m-%d")
    local result = {}
    for _, e in ipairs(self.events) do
        if e.start:sub(1, 10) == today_str then table.insert(result, e) end
    end
    return result
end

function M.Schedule:upcoming(days)
    local now = os.time()
    local future = now + days * 86400
    local result = {}
    for _, e in ipairs(self.events) do
        local et = os.time({year=e.end:sub(1,4), month=e.end:sub(6,7), day=e.end:sub(9,10),
            hour=e.end:sub(12,13), min=e.end:sub(15,16)})
        if et >= now and et <= future then table.insert(result, e) end
    end
    return result
end

function M.Schedule:free_slots(date, start_hour, end_hour)
    local slots = {}
    local busy = {}
    for _, e in ipairs(self.events) do
        if e.start:sub(1, 10) == date then
            local sh = tonumber(e.start:sub(12,13))
            local eh = tonumber(e.end:sub(12,13))
            for h = sh, eh - 1 do busy[h] = true end
        end
    end
    local cur = start_hour
    while cur < end_hour do
        if not busy[cur] then
            local slot_start = cur
            while cur < end_hour and not busy[cur] do cur = cur + 1 end
            table.insert(slots, {start = slot_start, end = cur})
        else cur = cur + 1 end
    end
    return slots
end

function M.readline(prompt)
    io.write(prompt or "")
    io.flush()
    return io.read("*l")
end

function M.confirm(msg)
    io.write(msg .. " (y/n): ")
    io.flush()
    local ans = io.read("*l"):lower()
    return ans == "y" or ans == "yes"
end

function M.read_num(prompt)
    while true do
        io.write(prompt or "")
        io.flush()
        local input = io.read("*l")
        local num = tonumber(input)
        if num then return num end
        print("Invalid number, please retry.")
    end
end

return M
