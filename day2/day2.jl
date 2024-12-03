
#--------------------------------------------Part 1--------------------------------------------

function part1()
    reports = [rstrip(lstrip(x)) for x in readlines("day2.dat")]
    safe = 0
    for line in reports
        line = split(line, " ")
        decreasing = true
        # Check if all decreasing
        for i in range(1,length(line)-1)
            if parse(Int64,line[i]) >=parse(Int64, line[i+1])
                decreasing = true
            else
                decreasing = false
                break
            end
        end
        # Check if all increasing
        increasing = true
        for i in range(1,length(line)-1)
            if parse(Int64,line[i]) <=parse(Int64, line[i+1])
                increasing = true
            else
                increasing = false
                break
            end
        end
        # check difference
        max_diff = 0
        min_diff = 4
        if (increasing && ~decreasing) || (decreasing && ~increasing)
            for i in range(1,length(line)-1)
                diff = abs(parse(Int64,line[i]) -parse(Int64, line[i+1]))
                max_diff = diff > max_diff ? diff : max_diff
                min_diff = diff < min_diff ? diff : min_diff
            end
        end
        inc_dec = (increasing && ~decreasing) || (decreasing && ~increasing)
        diff_safe = (min_diff >= 1) && (max_diff <= 3)
        safe = inc_dec && diff_safe ? safe + 1 : safe
    end
    println("Part 1 $safe")
end


#--------------------------------------------Part 2--------------------------------------------
@enum DIR begin
    dn=0
    up=1
end

"Find the direction of an array. Return 1 if increasing, 0 if decreasing."
function findDirection(report)

    increasing = 0
    decreasing = 0
    for i in 1:length(report)-1
        if report[i] < report[i+1]
            increasing += 1
        elseif report[i] > report[i+1]
            decreasing += 1
        end
    end
    return increasing > decreasing ? up : dn
end

"Recursively determine if a report is safe"
function safe(report, direction, can_recurse = true)
    is_safe = true
    diff_violation = (x1,x2)-> !(1 <= abs(x1-x2) <= 3)
    for i in 1:length(report)-1
        if direction == up
            violation = report[i] >= report[i+1] || diff_violation(report[i],report[i+1])
            if violation
                if can_recurse
                    deleteat!(report,i+1)
                    is_safe = safe(report, direction, false)
                    break
                else
                    return false
                end
            end
        elseif direction == dn
            violation = report[i] <= report[i+1] || diff_violation(report[i],report[i+1])
            if violation
                if can_recurse
                    deleteat!(report,i+1)
                    is_safe = safe(report, direction, false)
                    break
                else
                    return false
                end
            end
        else
            println("INVALID STATE")
        end
    end
    return is_safe
end

function part2()
    reports = [rstrip(lstrip(x)) for x in readlines("day2.dat")]
    safe_cnt = 0
    for line in reports
        line = [parse(Int64,x) for x in split(line, " ") if x != ""]
        safe_cnt = safe(line, findDirection(line)) ? safe_cnt + 1 : safe_cnt
    end
    println("Part 2 $safe_cnt")
end

part1()
part2()