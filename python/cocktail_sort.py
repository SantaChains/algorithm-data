def cocktail_sort(arr: list) -> list:
    """
    鸡尾酒排序（双向冒泡排序）
    @param arr: 待排序数组
    @return: 排序后的数组
    """
    n = len(arr)
    left = 0
    right = n - 1
    while left < right:
        swapped = False
        for i in range(left, right):
            if arr[i] > arr[i + 1]:
                arr[i], arr[i + 1] = arr[i + 1], arr[i]
                swapped = True
        if not swapped:
            break
        right -= 1
        swapped = False
        for i in range(right, left, -1):
            if arr[i - 1] > arr[i]:
                arr[i - 1], arr[i] = arr[i], arr[i - 1]
                swapped = True
        left += 1
        if not swapped:
            break
    return arr
