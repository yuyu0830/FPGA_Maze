import random

def generate_maze(rows, cols):
    # 미로 초기화
    maze = [['1' for _ in range(cols)] for _ in range(rows)]

    def is_valid(x, y):
        return 0 <= x < rows and 0 <= y < cols and maze[x][y] == '1'

    def carve(x, y):
        maze[x][y] = '0'

        directions = [(0, 2), (2, 0), (0, -2), (-2, 0)]
        random.shuffle(directions)

        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if is_valid(nx, ny):
                maze[(x + nx) // 2][(y + ny) // 2] = '0'
                carve(nx, ny)

    # 시작 지점을 홀수로 선택
    start_x, start_y = random.randrange(1, rows, 2), random.randrange(1, cols, 2)
    carve(start_x, start_y)

    return maze

def print_maze(maze):
    for row in maze:
        print(''.join(row))

if __name__ == "__main__":
    rows = 31  # 홀수로 선택
    cols = 41  # 홀수로 선택
    maze = generate_maze(rows, cols)
    print_maze(maze)