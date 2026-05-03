if (typeof RegExp.escape !== "function") {
  RegExp.escape = function (s: string): string {
    if (typeof s !== "string") throw new TypeError("RegExp.escape: argument must be a string");
    return s.replace(/[\\^$.*+?()[\]{}|]/g, "\\$&");
  };
}

const userInput = "hello.world?";
const safe = RegExp.escape(userInput);
const regex = new RegExp(safe, "i");
console.log(regex.test(userInput));

const untrusted = "[*]";
const safePattern = RegExp.escape(untrusted);
const dynamicRegex = new RegExp(safePattern);
console.log("[*] is a web school.".match(dynamicRegex));

console.log(RegExp.escape("foo"));
console.log(RegExp.escape("foo.bar"));
console.log(RegExp.escape("(foo)"));
console.log(RegExp.escape("foo-bar"));
