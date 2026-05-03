pub fn cocktail_sort<T: PartialOrd + Copy>(arr: &mut [T]) {
    let len = arr.len();
    if len < 2 {
        return;
    }

    let mut left = 0;
    let mut right = len - 1;

    while left < right {
        let mut swapped = false;

        for i in left..right {
            if arr[i] > arr[i + 1] {
                arr.swap(i, i + 1);
                swapped = true;
            }
        }

        if !swapped {
            break;
        }
        right -= 1;

        swapped = false;
        for i in (left + 1..=right).rev() {
            if arr[i - 1] > arr[i] {
                arr.swap(i - 1, i);
                swapped = true;
            }
        }

        if !swapped {
            break;
        }
        left += 1;
    }
}
