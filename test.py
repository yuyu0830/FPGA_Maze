import string

def generate_binary_array(rows, cols):
    alphabet = string.ascii_uppercase  # A부터 Z까지 알파벳
    binary_array = []

    for i in range(rows):
        row = []
        for j in range(cols):
            # 알파벳의 인덱스를 이진수로 변환하여 1 또는 0으로 설정
            value = format((i * cols + j) % len(alphabet), 'b')[-1]
            row.append(int(value))
        binary_array.append(row)

    return binary_array

def print_binary_array(binary_array):
    for row in binary_array:
        print(' '.join(map(str, row)))

if __name__ == "__main__":
    rows = 5
    cols = 7
    binary_array = generate_binary_array(rows, cols)
    print_binary_array(binary_array)