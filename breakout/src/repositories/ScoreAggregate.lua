
local count = 0

function Root()  end

function Score()
    count = count + 1
end

dofile('/Users/sebastian.olivera/Library/Application Support/LOVE/breakout/breakout_score_format.lst')

print('count:', count)

local sum = 0

function Score(score)
    sum = sum + score._points
end

dofile('/Users/sebastian.olivera/Library/Application Support/LOVE/breakout/breakout_score_format.lst')

print('sum:', sum)
