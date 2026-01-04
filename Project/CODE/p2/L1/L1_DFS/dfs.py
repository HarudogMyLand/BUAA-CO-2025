def main():
    n = int(input().strip())
    m = int(input().strip())

    maze = []
    for _ in range(n):
        row = []
        for _ in range(m):
            row.append(int(input().strip()))
        maze.append(row)

    sx = int(input().strip()) - 1 
    sy = int(input().strip()) - 1  
    ex = int(input().strip()) - 1  
    ey = int(input().strip()) - 1  

    result = count_paths(maze, n, m, sx, sy, ex, ey)
    print(result)


def count_paths(maze, n, m, sx, sy, ex, ey):
    visited = [[False] * m for _ in range(n)]
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    count = 0

    def dfs(x, y):
        nonlocal count
        if x == ex and y == ey:
            count += 1
            return

        visited[x][y] = True
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if 0 <= nx < n and 0 <= ny < m and maze[nx][ny] == 0 and not visited[nx][ny]:
                dfs(nx, ny)
        visited[x][y] = False

    dfs(sx, sy)
    return count
main()