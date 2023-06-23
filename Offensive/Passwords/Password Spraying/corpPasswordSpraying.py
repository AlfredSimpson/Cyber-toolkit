"""
This program was developed using known corporate procedures for default passwords.
While an ideal world would never use default passwords, and an even more ideal world would then see end users change those passwords, this is not always the case.
To test compliance, you can feed this program some generalized information. It will then print a password list for your testing purposes.

"""

import string


def getYears(year):
    y4 = [str(year - i) for i in range(5)] + [str(year + i) for i in range(1, 3)]
    y2 = [y[-2:] for y in y4]
    return y4, y2


def genPasses(prefixList, yList, symList, capitalize=False):
    passList = []
    for prefix in prefixList:
        for year in yList:
            for symbol in symList:
                if capitalize:
                    passList.extend(
                        [
                            prefix.lower() + year + symbol,
                            prefix.capitalize() + year + symbol,
                            prefix.upper() + year + symbol,
                        ]
                    )
                else:
                    passList.append(prefix + year + symbol)
    return passList


def main():
    seasons = ["Summer", "Fall", "Spring", "Winter", "Autumn"]
    symList = list(string.punctuation)
    cName = input("What is the name of the company? ")

    while True:
        try:
            year = int(input("What is the current year? "))
            break
        except ValueError:
            print("Invalid input, please enter a valid year.")

    y4, y2 = getYears(year)
    passList = genPasses([cName], y4 + y2, symList)
    passList.extend(genPasses(seasons, y4 + y2, symList, capitalize=True))

    with open("potentialPasswords.txt", "w") as f:
        for password in passList:
            f.write("%s\n" % password)


if __name__ == "__main__":
    main()
