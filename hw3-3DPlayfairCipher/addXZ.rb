# Add X-Z to complete graphs
palabra = "AAA"
puts "Word to split in trigraphs: " + palabra
palabra = palabra.split(//)
#los trios de la palabra
trios = []
remain = ""
for letra in palabra do
    #puts remain.length
    #puts remain
    if remain.length % 3 != 0 and letra == remain[remain.length-1]
        remain << "X"
        if remain.length % 3 == 0
            puts "Trio: " + remain
            trios << remain
            remain = ""
        end
        remain << letra
    else
        remain << letra
    end
    if remain.length % 3 == 0
        puts "Trio: " + remain
        trios << remain
        remain = ""
    end
end
if remain.length % 3 != 0
    remain << "X"
end

if(remain.length % 3 != 0)
    remain << "Z"
end
puts "Trio: " + remain
trios << remain
remain = ""
puts "Trigraphs: "
for tri in trios do
    puts tri
end