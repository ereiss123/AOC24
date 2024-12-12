using  Test

# ------------------------------Part 1------------------------------

"""
Given a string of update rules return a dictionary
where the keys are page numbers and the values are all pages that should precede it
"""
function parserules(str)
    str = split(str)
    rules = Dict()
    for line in str
        if !('|' in line)
            break
        end
        rule = [parse(Int, x) for x in split(line,'|')]
        if !(haskey(rules, rule[2]))
            rules[rule[2]] = []
        end
        push!(rules[rule[2]],rule[1])
    end
    return rules
end

"""Parse puzzle input and return an array of updates"""
function parseupdates(str)
    str = split(str)
    updates = []
    for line in str
        if ('|' in line) || (line == "")
            continue
        end
        update = [parse(Int, x) for x in split(line,',')]
        push!(updates,update)
    end
    return updates
end

function validupdate(update, rules)
    for (i,val) in enumerate(update)
        # for each number we need to check that all necessary updates are there
        ruleval = haskey(rules, val) ? rules[val] : []
        for prec in ruleval
            if (prec in update) && !(prec in update[1:i]) return false end
        end
    end
    return true
end

function part1(inputfile)
    str = read(inputfile, String)
    rules = parserules(str)
    updates = parseupdates(str)
    sum = 0
    for update in updates
        middle = iseven(length(update)) ? length(update)/2 : Int64(floor(length(update)/2)) + 1
        sum = validupdate(update, rules) ? sum + update[middle] : sum
    end
    @show sum
end

@test part1("test.dat") == 143
part1("input.dat")
# ------------------------------Part 2------------------------------
function sortupdate(update, rules, depth=1000)
    count = 0
    while !validupdate(update, rules)
        modified = false
        for (i,val) in enumerate(update)
            # for each number we need to check that all necessary updates are there
            ruleval = haskey(rules, val) ? rules[val] : []
            for prec in ruleval
                # if we find an invalid update swap the values and then
                # break to check again
                if (prec in update) && !(prec in update[1:i])
                    prec_idx = findlast(x->x==prec, update)
                    update[prec_idx] = val
                    update[i] = prec
                    modified = true
                    break
                end
            end
            if modified break end
        end
        count += 1
        @assert count < depth # protect against infinite loop
    end
    return update
end

function part2(inputfile)
    str = read(inputfile, String)
    rules = parserules(str)
    updates = parseupdates(str)
    sum = 0
    row = 0
    for update in updates
        if !validupdate(update, rules)
            println("Invalid update at row $row")
            update = sortupdate(update, rules)
            middle = iseven(length(update)) ? length(update)/2 : Int64(floor(length(update)/2)) + 1
            sum += update[middle]
            println()
        end
        row += 1
    end
    @show sum
end
@test part2("test.dat") == 123
part2("input.dat")