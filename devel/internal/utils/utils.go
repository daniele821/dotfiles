package utils

import (
	"cmp"
	"slices"
)

// Returns all values from a map
func Values[M ~map[K]V, K comparable, V any](m M) []V {
	r := make([]V, 0, len(m))
	for _, v := range m {
		r = append(r, v)
	}
	return r
}

// Returns all elements of m1 which are not contained also in m2.
// The result is then sorted and all duplicates are removed
func Sub[M cmp.Ordered](m1 []M, m2 []M) []M {
	slices.Sort(m1)
	slices.Sort(m2)
	m1 = slices.Compact(m1)
	m2 = slices.Compact(m2)
	var res []M
	for _, m := range m1 {
		if !slices.Contains(m2, m) {
			res = append(res, m)
		}
	}
	slices.Sort(res)
	res = slices.Compact(res)
	return res
}

// Copy and returns pointer to said copy.
func Point[T any](t T) *T {
	return &t
}
