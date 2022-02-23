package;

using ExtraFeatures;

function assert(b: Bool, ?pos: haxe.PosInfos) {
	if(!b) {
		throw "assert failed at " + pos.fileName + ":" + pos.lineNumber;
	}
}

function main() {

	trace("Testing [Extra Features]");

	/**********************************************
	 * decon
	 * 
	 * Deconstructs (destructures) any type with
	 * fields into a new or existing variable.
	 * Declaring with "final" is not supported.
	 **********************************************/
	// decon anonymous structure
	var two = 123;
	var data = { one: 1, two: 2 };

	// "one" is declared as a new variable
	// "two" is reassigned
	data.decon(var one, two);

	assert(one == 1);
	assert(two == 2);

	// ---

	// decon class
	var baseInst = new Base();
	assert(baseInst.decon(var three, two, one) == baseInst);

	assert(one == 100);
	assert(two == 200);
	assert(three == 300);

	/**********************************************
	 * iftrue
	 * 
	 * Append to an expression to have it only
	 * execute when a condition is true.
	 **********************************************/
	var counter = new Counter();

	assert(counter.count == 0);

	counter.inc().onlyif(counter.count == 0);

	assert(counter.count == 1);

	counter.inc().onlyif(counter.count == 0);

	assert(counter.count == 1);

	counter.inc().onlyif(counter.count > 0);

	assert(counter.count == 2);

	assert(counter.getCount().onlyif(true) == 2);
	assert(counter.getCount().onlyif(false) == null);

	// note: using onlyif/unless on expression that returns
	//       Void will always also return "nothing" (Void).

	/**********************************************
	 * unless
	 * 
	 * Append to an expression to have it only
	 * execute when a condition is false.
	 **********************************************/
	counter.inc().unless(counter.count == 2);

	assert(counter.count == 2);

	counter.inc().unless(counter.count < 2);
 
	assert(counter.count == 3);

	assert(counter.getCount().unless(true) == null);
	assert(counter.getCount().unless(false) == 3);

	/**********************************************
	 * assign
	 * 
	 * Assigns a value to a field.
	 * Useful when trying to keep chaining neat.
	 **********************************************/
	assert(baseInst.assign(one, 123).one == 123);
	assert(baseInst.assign(two, 321).two == 321);

	/**********************************************
	 * with
	 * 
	 * Executes expression with temporary variable
	 * used to reference "callee". 
	 * The resulting value is returned.
	 **********************************************/
	assert("ooo" == "123".length.with({
		assert(it == "123".length);

		var c = "o";
		var result = "";
		for(i in 0...it) {
			result += c;
		}
		result;
	}));

	assert(5 == "12345".with(myStr, {
		assert(myStr == "12345");

		myStr.length;
	}));

	/**********************************************
	 * also
	 * 
	 * Same as "with", but the returned value
	 * is always the callee.
	 **********************************************/
	var str = "123";
	var containsTwo = false;

	assert(str == str.also({
		assert(it == str);

		var index = 0;
		while(index++ < str.length) {
			if(str.charAt(index) == "2") {
				containsTwo = true;
			}
		}
	}));

	assert(containsTwo);

	assert(str == str.also(myStr, {
		assert(myStr == str);
	}));

	/**********************************************
	 * as/retype
	 * 
	 * Postfix alternatives for "cast".
	 * obj.as(Class)  => cast(obj, Class);
	 * obj.retype()   => cast obj;
	 **********************************************/
	var getChild = function(): Base { return new Child(); };
	var child = getChild().as(Child);
	var child2: Child = getChild().retype();

	assert(child.four == 400);
	assert(child2.four == 400);

	// ---

	trace("[Extra Features] Test Successful!");
}

class Base {
	public var one = 100;
	public var two = 200;
	public var three = 300;

	public function new() {}
}

class Child extends Base {
	public var four = 400;
}

class Counter {
	public var count = 0;

	public function new() {}

	public function inc() {
		count++;
	}

	public function getCount() {
		return count;
	}
}
