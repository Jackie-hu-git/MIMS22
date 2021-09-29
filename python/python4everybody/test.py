# try:
    # hour = float(input("Enter an hour: "))
    # rate = float(input("Enter the rate: "))
# except:
    # print("Enter a numeric value!")
    # quit()

# print(hour, rate)

# if hour > 40:
    # pay = hour * rate * 1.1
    # print("Overworked!")
# else:
    # pay = hour * rate

# print("pay is", pay)

#####

total = 0.0
count = 0.0

while True:

    imput1 = input("Enter a num: ")
    # have to put the testing statement right before the typecast conversion
    if imput1 == "done":
        break
    # check the data type is correct, otherwise, continue the while loop.
    try:
        val1 = float(imput1)
    except:
        print("Invalid input.")
        continue

    count += 1
    total += val1

print (total, count, total/count)
