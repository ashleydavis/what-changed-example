import assert from "node:assert/strict";
import { greet } from "../src/greet.js";

//
// The expensive suite, standing in for the end to end tests you would not want on every commit: a
// browser to start, a server to wait for, fixtures to load. Here that cost is five seconds of doing
// nothing, so you can watch it being skipped.
//
// It is a plain script rather than a *.test.js file, so `node --test test/` cannot pick it up. The
// two suites stay separate, which is the whole point: they are separate targets that run at
// separate times.
//

const SECONDS = 5;

console.log(`Starting the pretend browser, driving the pretend app (${SECONDS}s)...`);

for (let second = 1; second <= SECONDS; second++) {
    await new Promise(resolve => setTimeout(resolve, 1000));
    console.log(`  ${second}/${SECONDS}`);
}

assert.equal(greet("world"), "Hello, world!");

console.log("End to end tests passed.");
