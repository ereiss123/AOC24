using Test


"""
Check in every direction given an (x,y) cooridinate looking for a given character

Returns a vector of cooridinate tuples indicating matches
"""
function checkletter(grid, xy, c)
    x = xy[1]
    y = xy[2]
    x_len = length(grid)
    y_len = length(grid[1])
    cooridinates = []
    leftgood = x-1 > 0
    rightgood = x+1 <= x_len
    upgood = y-1 > 0
    downgood = y+1 <= y_len

    # check up
    if leftgood && (grid[x-1][y] == c)
        push!(cooridinates,(x-1,y))
    end
    # check down
    if rightgood && (grid[x+1][y] == c)
        push!(cooridinates,(x+1,y))
    end
    # check left
    if upgood && (grid[x][y-1] == c)
        push!(cooridinates,(x,y-1))
    end
    # check right
    if downgood && (grid[x][y+1] == c)
        push!(cooridinates, (x,y+1))
    end
    # check up/left
    if (upgood && leftgood) && (grid[x-1][y-1] == c)
        push!(cooridinates, (x-1, y-1))
    end
    #check down/left
    if (upgood && rightgood) && (grid[x+1][y-1] == c)
        push!(cooridinates, (x+1, y-1))
    end
    #check up/right
    if (downgood && leftgood) && (grid[x-1][y+1] == c)
        push!(cooridinates, (x-1, y+1))
    end
    #check down/left
    if (downgood && rightgood) && (grid[x+1][y+1] == c)
        push!(cooridinates, (x+1, y+1))
    end
    return cooridinates
end

"""Test checkletter functionality"""
function test_checkletter()
    i1 = split("""aaa
    aaa
    aaa""")
    i2 = split("""abcd
    bcda
    cdab
    dabc
    """)

    @test checkletter(i1,(2,2),'a') == [(1,2),(3,2),(2,1),(2,3),(1,1),(3,1),(1,3),(3,3)]
    @test checkletter(i1,(2,2),'b') == []
    @test checkletter(i2,(1,1),'c') == [(2,2)]
    @test checkletter(i2,(3,2),'d') == [(4,1),(2,3)]
    @test checkletter(i2,(4,4),'b') == [(3,4),(4,3)]
end
test_checkletter()

"""Given the location of an X, find the rest of the word"""
function findxmas(grid, xy)
    wordcount = 0
    # println("starting at $xy")
    # Find the Ms
    marr = checkletter(grid,xy,'M')
    # find the As
    aarr = []
    for mxy in marr
        found = checkletter(grid,mxy,'A')
        append!(aarr,found)
    end
    # find the Ss
    sarr = []
    for axy in aarr
        found = checkletter(grid,axy,'S')
        append!(sarr,found)
    end
    wordcount = length(sarr)
    return wordcount
end

"""Given an x,y cooridinate and direction,
 find the next four letters in a straight line"""
function checkline(grid, xy, dir)
    word = grid[xy[1]][xy[2]]
    xoffset = 0
    yoffset = 0
    # Julia does not have a switch statement T_T
    if dir == "up" xoffset = -1
    elseif dir == "down" xoffset = 1
    elseif dir == "left" yoffset = -1
    elseif dir == "right" yoffset = 1
    elseif dir == "upleft"
        xoffset = -1
        yoffset = -1
    elseif dir == "upright"
        xoffset = -1
        yoffset = 1
    elseif dir == "dnleft"
        xoffset = 1
        yoffset = -1
    elseif dir == "dnright"
        xoffset = 1
        yoffset = 1
    else
        throw(ArgumentError("$dir is not a valid direction"))
    end
    xidx = 0
    yidx = 0
    for _ in 1:3
        xidx += xoffset
        yidx += yoffset
        try
            word *= grid[xy[1]+xidx][xy[2]+yidx]
        catch
            word = "OutOfBounds"
            break
        end
    end
    return word
end

"""Given the location of an X, find the rest of the word"""
function findxmaspt1(grid, xy)
    wordcount = 0
    # Find the Ms
    marr = checkletter(grid,xy,'M') # All Ms are valid
    for m in marr
        # determine relationship to X
        dir = "None"
        up = down = left = right = false
        if (xy[1] == m[1]-1)
            dir = "down"
            down = true
        end
        if (xy[1] == m[1]+1)
            dir = "up"
            up = true
        end
        if (xy[2] == m[2]-1)
            dir = "right"
            right = true
        end
        if (xy[2] == m[2]+1)
            dir = "left"
            left = true
        end
        if (up && left) dir = "upleft" end
        if (down && left) dir = "dnleft" end
        if (up && right) dir = "upright" end
        if (down && right) dir = "dnright" end
        @show dir
        @show xy
        @show m
        word = checkline(grid,xy,dir)
        @show word
        wordcount = (word == "XMAS") ? wordcount+1 : wordcount
    end
    return wordcount
end

function test_checkline()
    i1 = split("""abcd
    1234
    efgh
    5678
    """)
    @test checkline(i1, (1,1), "down") == "a1e5"
    @test checkline(i1, (1,1), "left") == "OutOfBounds"
    @test checkline(i1, (1,1), "right") == "abcd"
    @test checkline(i1, (1,1), "dnright") == "a2g8"
    @test checkline(i1, (4,4), "upleft") == "8g2a"
    @test checkline(i1, (1,4), "dnleft") == "d3f5"
    @test checkline(i1, (4,1), "up") == "5e1a"
    @test checkline(i1, (4,1), "upright") == "5f3d"
end
test_checkline()

function test_findxmas()
    i1 = split("""XMAS""")
    @test findxmas(i1,(1,1)) == 1
    i2 = split("""MMMSXXMASM
                  MSAMXMSMSA
                  AMXSXMAAMM
                  MSAMASMSMX
                  XMASAMXAMM
                  XXAMMXXAMA
                  SMSMSASXSS
                  SAXAMASAAA
                  MAMMMXMMMM
                  MXMXAXMASX""")
    @test findxmas(i2,(1,6)) == 6
end
test_findxmas()



function part1(input_file)
    grid = readlines(input_file)
    sum = 0
    for (x,row) in enumerate(grid)
        for (y,c) in enumerate(row)
            if c == 'X' sum += findxmaspt1(grid, (x,y)) end
        end
    end
    @show sum
end
@test part1("test.dat") == 18
part1("input.dat")
