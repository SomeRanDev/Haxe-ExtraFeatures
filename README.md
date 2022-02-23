<p align="center">
  <a href="https://github.com/RobertBorghese/Haxe-ExtraFeatures" title="extra-features-logo"><img src="logo/Logo.png" /></a>
</p>

Provides extra features not available in vanilla Haxe. Typically these are features that are applicable to nearly all expressions and favor postfix expression-calling syntax.

This library provides exclusively macro functions, so no additional bloat is added to transpiled code/executable.

---

# [Installation]

Install via haxelib.
```
haxelib install extra-features
```

Add this top of the file or `import.hx`.
```haxe
using ExtraFeatures;
```

---

# [Features]

"unwrap" (destructuring feature)
================================

Call "unwrap" on an expression to assign its fields to new or existing variables of the same names of the fields.
```haxe
function getObj() return { name: "John", age: 66 };

var name = "Default";
getObj().unwrap(name, var age);

assert(name == "John");
assert(age == 66);
```

"with"/"also" (scope functions)
===============================

Based on [Kotlin's scope functions](https://kotlinlang.org/docs/scope-functions.html), these functions use macros to provide zero-cost inline/chain calls to block expressions with the lvalue stored in a variable.
```haxe
// with vs also
123.with({ it.toString() }); // returns "123"
123.also({ it.toString() }); // returns 123
```
```haxe
// example of use-case with hypothetical "Player" class
var player = new Player();

Math.floor(player.x / 100.0).with({
    trace(it);
});

var meters = player.getDistance().with(dist, {
    recordDistance(dist);
    if(dist > 1000) triggerEffect();
    convertDistanceToMeters(dist); // convert to meters and return
});
```

"as"/"retype" (function-call cast)
==================================

Based on [C# "as" operator](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/type-testing-and-cast#as-operator), these allow for type casting with a function-like syntax.
```haxe
var getChild = function(): Base { return new Child(); };

// equivalent to "cast(getChild(), Child)"
var child1 = getChild().as(Child);

// equivalent to "cast getChild()"
var child2: Child = getChild().retype();
```