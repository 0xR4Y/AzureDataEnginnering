#Ramin Roufeh

import json

filename = 'data/movie.json'
slices = 8

with open(filename, encoding='utf8') as f:
        j = json.load(f)
        jarr = list(j['movie'])
        l = len(jarr)
        count = 0
        for i in range(0, l, (l//slices)+1):
            end = i + (l//slices)+1
            count += 1
            with open('data/'+str(count)+'.json', 'w+', encoding='utf8') as d:
                json.dump(jarr[i:end], d, indent=4)
