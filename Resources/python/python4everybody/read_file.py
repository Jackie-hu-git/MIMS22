fh = open("clown.txt")


for line in fh:
    line = line.strip()
    word = line.split()

    #print(word)

di = dict()

for w in word:
    di[w] = di.get(w,0) + 1


print(di)

new_list = []

for k,v in di.items():
    newt = (v,k)
    new_list.append(newt)

sort_list = sorted(new_list, reverse = True)

final_list = sort_list[:5]
print(final_list)

for v,k in final_list:
    print(k,v)





#largest = -1
#the_word = None

#for k,v in di.items():
    #if v > largest:
        #largest = v
        #the_word = k
        #print(k,v)



    #if len(word) < 1 or word[0] != "From":
         #continue
    #print(word[2])
