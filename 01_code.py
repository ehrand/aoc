#!/usr/bin/env python3

def divider (value , divisor):
    result = value // divisor
    return result;

def substractor (value, substract):
    result = value - substract
    if result > 0:
        return result
    else:
        return 0

def summarizer (values):
    required_fuel = 0
    for v in values:
        divided = divider(v, 3)
        fuel = substractor(divided, 2)
        required_fuel += fuel
    return required_fuel

def read_integers(filename):
    with open(filename) as f:
        return list(map(int, f))

def main():
    vals = read_integers("01_data.txt")
    total_fuel = summarizer(vals)
    print("Total fuel required: ", total_fuel)
    return

if __name__=="__main__":
    main()
