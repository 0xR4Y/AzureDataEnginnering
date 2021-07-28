
#Ramin Roufeh
import csv

filenames = ['people_1.txt', 'people_2.txt']

# result set for each file
result = []

finalresult = []
duplicates = set()

for filename in filenames:
    with open('data/' + filename) as f:
        contents = [line.strip() for line in f]
        for c in contents:
            info = c.split('\t')
            fn = info[0].lower().strip(' ')
            ln = info[1].lower().strip(' ')
            em = info[2].lower().strip(' ')
            ph = info[3].strip(' ').replace('-', '')
            ad = info[4].lower().replace('no.', '').replace('#', '')
            total = fn + ' ' + ln + ' ' + em + ' ' + ph + ' ' + ad
            if total not in duplicates:
                duplicates.add(total)
                result.append([fn, ln, em, ph, ad])
        print(f'{len(contents) - len(duplicates)} duplicates founded for {filename}')
        finalresult += result

# open csv file and write final result to it
with open('data/results.csv', 'w+') as c:
    cw = csv.writer(c, delimiter=',')
    # write final result into results
    cw.writerows(finalresult)
