import unittest
from python import bubble_sort, cocktail_sort


class TestBubbleSort(unittest.TestCase):

    def test_basic(self):
        self.assertEqual(bubble_sort([3, 1, 2]), [1, 2, 3])
        self.assertEqual(bubble_sort([5, 4, 3, 2, 1]), [1, 2, 3, 4, 5])

    def test_edge(self):
        self.assertEqual(bubble_sort([]), [])
        self.assertEqual(bubble_sort([1]), [1])
        self.assertEqual(bubble_sort([1, 2]), [1, 2])
        self.assertEqual(bubble_sort([2, 1]), [1, 2])


class TestCocktailSort(unittest.TestCase):

    def test_basic(self):
        self.assertEqual(cocktail_sort([3, 1, 2]), [1, 2, 3])
        self.assertEqual(cocktail_sort([5, 4, 3, 2, 1]), [1, 2, 3, 4, 5])

    def test_edge(self):
        self.assertEqual(cocktail_sort([]), [])
        self.assertEqual(cocktail_sort([1]), [1])
        self.assertEqual(cocktail_sort([1, 2]), [1, 2])
        self.assertEqual(cocktail_sort([2, 1]), [1, 2])

    def test_unbalanced(self):
        self.assertEqual(cocktail_sort([1, 3, 2, 5, 4]), [1, 2, 3, 4, 5])


if __name__ == "__main__":
    unittest.main()
