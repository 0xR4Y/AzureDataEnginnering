#Ramin Roufeh

import json

def split_by(file: str, slices: int):
    with open(file, encoding='utf8') as f:
        j = json.load(f)
        jarr = list(j['movie'])
        l = len(jarr)
        count = 0
        for i in range(0, l, (l//slices)+1):
            end = i + (l//slices)+1
            count += 1
            with open('movies_slices/'+str(count)+'.json', 'w+', encoding='utf8') as d:
                json.dump(jarr[i:end], d, indent=4)


if __name__ == '__main__':
    filename = 'movie.json'
    split_by(filename, 8)
