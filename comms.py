import serial

ser = serial.Serial("/dev/tty...")

MAT_A = [
    1, 2, 4,
    3, 8, 20,
    2, 7, 0
]

MAT_B = [
    0, 1, 3,
    30, 18, 21,
    11, 17, 10
]

for elem in MAT_A:
    ser.write(bytes([elem]))
for elem in MAT_B:
    ser.write(bytes([elem]))

b = ser.read(9)
print(b)
ser.close()
