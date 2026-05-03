// RegExp.escape() - ES2025 (Stage 4, Feb 2025)
// Baseline: May 2025 - Chrome 136, Edge 136, Firefox 134, Safari 18.2, Opera 121
// https://tc39.es/proposal-regex-escaping/
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/escape

// Polyfill (for environments before May 2025)
if (typeof RegExp.escape !== "function") {
  RegExp.escape = function (s) {
    if (typeof s !== "string") throw new TypeError("RegExp.escape: argument must be a string");
    return s.replace(/[\\^$.*+?()[\]{}|]/g, "\\$&");
  };
}

// ---------- Examples ----------

// 1. Escape user input for safe use in RegExp constructor
const userInput = "hello.world?";
const safe = RegExp.escape(userInput);
const regex = new RegExp(safe, "i");
console.log(regex.test("hello.world?")); // true

// 2. Dynamically build a regex from untrusted input
const untrusted = "[*]";
const safePattern = RegExp.escape(untrusted);
const dynamicRegex = new RegExp(safePattern);
console.log("[*] is a web school.".match(dynamicRegex)); // [ '[*]' ]

// 3. Escape leading digit / ASCII letter (prevent misinterpretation after \0, \1, \c)
console.log(RegExp.escape("foo"));      // \x66oo  (f -> \x66)
// console.log(RegExp.escape("123"));    // \x31\x32\x33

// 4. Escape regex syntax characters
console.log(RegExp.escape("foo.bar"));  // \x66oo\.bar
console.log(RegExp.escape("(foo)"));    // \(foo\)

// 5. Escape punctuators that can't be escaped with \ alone
console.log(RegExp.escape("foo-bar"));  // \x66oo\x2dbar
