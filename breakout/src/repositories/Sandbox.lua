-- maximum memory (in KB) that can be used
local memlimit = 1000

-- maximum "steps" that can be performed
local steplimit = 1000
local function checkmem ()
    if collectgarbage("count") > memlimit then
        error("script uses too much memory")
    end
end
local count = 0
local function step ()
    checkmem()
    count = count + 1
    if count > steplimit then
        error("script uses too much CPU")
    end
end

local score_count = 0

local ENV = {}

function ENV.Root()  end

function ENV.Score()
    score_count = score_count + 1
end

local f = assert(loadfile('/Users/sebastian.olivera/Library/Application Support/LOVE/breakout/breakout_score_format.lst', "t", ENV))

debug.sethook(step, "", 1) -- set hook

f()

print('count:', score_count)
