//
// The whole application: one function.
//
// This is deliberately wrong. The test and the end to end check both expect "Hello", this says
// "Hi", so they fail and the pre-commit hook refuses the commit. Changing "Hi" to "Hello" is the
// one-word fix.
//
export function greet(name) {
    return `Hi, ${name}!`;
}
