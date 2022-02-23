<p align="left">
  <a href="https://github.com/RobertBorghese/Haxe-ExtraFeatures" title="extra-features-logo"><img src="logo/Logo.png" /></a>
</p>

Provides extra features not available in vanilla Haxe. Typically these are features that are applicable to nearly all expressions and favor function-calling/chaining syntax.

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

### "decon" (deconstruct feature)

Based on [C#'s deconstructing](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/functional/deconstruct). Call "decon" on an expression to assign its fields to new or existing variables of the same names of the fields.
```haxe
function getObj() return { name: "John", age: 66 };

var name = "Default";
getObj().decon(name, var age);

assert(name == "John");
assert(age == 66);
```  

&nbsp;  

### "onlyif"/"unless" (posfix condition feature)

Based on [Ruby's postfix conditionals](https://www.tutorialspoint.com/ruby/ruby_if_else.htm). Append "onlyif" to an expression, and the entire expression will only execute if the condition provided to the "onlyif" evaluates to true at runtime. Long story short, it's an if-statement that can be used at the end of a statement for aesthetic purposes. "unless" does the same thing, but the condition must evaluate to false for the expression to run.
```haxe
// example of use-case with hypothetical "Player" class
var player = new Player();

player.update().onlyif(player.canUpdate());
player.draw().unless(player.invisible());

// at compile-time, these statements are converted to:
//
// if(player.canUpdate()) player.update();
// if(!player.invisible()) player.draw();
```  

&nbsp;  

### "with"/"also" (scope functions)

Based on [Kotlin's scope functions](https://kotlinlang.org/docs/scope-functions.html). These functions use macros to provide zero-cost inline/chain calls to block expressions with the lvalue stored in a variable.
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

&nbsp;  

### "as"/"retype" (function-call cast)

Based on [C# "as" operator](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/type-testing-and-cast#as-operator). These allow for type casting with a function-like syntax.
```haxe
var getChild = function(): Base { return new Child(); };

// equivalent to "cast(getChild(), Child)"
var child1 = getChild().as(Child);

// equivalent to "cast getChild()"
var child2: Child = getChild().retype();
```