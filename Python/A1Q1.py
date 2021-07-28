#Ramin Roufeh
import csv

def remove_duplicates(filename: str):
    result = []
    duplicates = set()
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
        return result


if __name__ == '__main__':
    # putting filename inside list
    filenames = ['people_1.txt', 'people_2.txt']

    # empty list to enter our result
    results = []

    # for loop going thrugh each file
    for f in filenames:
        # passing eachfile to remove_duplicate() function
        results += remove_duplicates(f)
    # open csv file
    with open('data/results.csv', 'w+') as c:
        cw = csv.writer(c, delimiter=',')
        # write result into results
        cw.writerows(results)
