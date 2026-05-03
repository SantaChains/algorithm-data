def bubble_sort(arr: list) -> list:
    """
    冒泡排序
    @param arr: 待排序数组
    @return: 排序后的数组
    """
    n =len(arr)
    for i in range(n):
        swapped = False
        for j in range(n-1-i):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr

