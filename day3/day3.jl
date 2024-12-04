function part1()
    puzzle_in = read("input.dat", String)
    pat1 = r"mul\(\d{1,3},\d{1,3}\)"
    muls = collect(eachmatch(pat1,puzzle_in))
    sum = 0
    for m in muls
        str_list = split(m.match,r"\(|,|\)")
        sum += (parse(Int,str_list[2]) * parse(Int,str_list[3]))
    end
    @show sum
end
part1()

function part2()
    test = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    puzzle_in = read("input.dat", String)
    pat1 = r"mul\(\d{1,3},\d{1,3}\)"
    pat2 = r"do\(\)"
    pat3 = r"don't\(\)"
    muls = collect(eachmatch(pat1,puzzle_in))
    dos = collect(eachmatch(pat2, puzzle_in))
    donts = collect(eachmatch(pat3, puzzle_in))
    sum = 0
    do_idx = 1
    dont_idx = 1
    mul_idx = 1
    do_add = true
    for i in eachindex(puzzle_in)
        if i == muls[mul_idx].offset # Reached a mul
            if do_add
                str_list = split(muls[mul_idx].match,r"\(|,|\)")
                sum += (parse(Int,str_list[2]) * parse(Int,str_list[3]))
            end
            mul_idx = mul_idx == length(muls) ? mul_idx : mul_idx+1
        end
        if i == dos[do_idx].offset # Reached a do
            do_add = true
            do_idx = do_idx == length(dos) ? do_idx : do_idx+1
        end
        if i == donts[dont_idx].offset # Reached a don't
            do_add = false
            dont_idx = dont_idx == length(donts) ? dont_idx : dont_idx+1
        end
    end
    @show sum
end
part2()