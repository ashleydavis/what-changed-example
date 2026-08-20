import { test } from "node:test";
import assert from "node:assert/strict";
import { greet } from "../src/greet.js";

//
// The fast suite: the one you would happily run on every commit.
//
test("greet says hello to the person it is greeting", () => {
    assert.equal(greet("world"), "Hello, world!");
});
