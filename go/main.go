package main

import (
	"fmt"
	"regexp"
	"strings"
)

func regexpEscape(s string) string {
	var sb strings.Builder
	for _, r := range s {
		switch r {
		case '\\', '^', '$', '.', '*', '+', '?', '(', ')', '[', ']', '{', '}', '|':
			sb.WriteRune('\\')
		}
		sb.WriteRune(r)
	}
	return sb.String()
}

func main() {
	userInput := "hello.world?"
	safe := regexpEscape(userInput)
	regex := regexp.MustCompile(safe)
	fmt.Println(regex.MatchString(userInput))

	untrusted := "[*]"
	safePattern := regexpEscape(untrusted)
	dynamicRegex := regexp.MustCompile(safePattern)
	fmt.Println(dynamicRegex.FindString("[*] is a web school."))

	fmt.Println(regexpEscape("foo"))
	fmt.Println(regexpEscape("foo.bar"))
	fmt.Println(regexpEscape("(foo)"))
	fmt.Println(regexpEscape("foo-bar"))
}
