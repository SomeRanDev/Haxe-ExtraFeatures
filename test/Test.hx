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
	 * unpack
	 * 
	 * Unpacks (destructures) any type with fields
	 * into a new or existing variable.
	 * Declaring with "final" is not supported.
	 **********************************************/
	// unpack anonymous structure
	var two = 123;
	var data = { one: 1, two: 2 };

	// "one" is declared as a new variable
	// "two" is reassigned
	data.unpack(var one, two);

	assert(one == 1);
	assert(two == 2);

	// ---

	// unpack class
	var baseInst = new Base();
	assert(baseInst.unpack(var three, two, one) == baseInst);

	assert(one == 999);
	assert(two == 1000);
	assert(three == 1001);

	/**********************************************
	 * setfield
	 * 
	 * Unpacks (destructures) any type with fields
	 * into a new or existing variable.
	 * Declaring with "final" is not supported.
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

	assert(child.four == 9999);
	assert(child2.four == 9999);

	// ---

	trace("[Extra Features] Test Successful!");
}

class Base {
	public var one = 999;
	public var two = 1000;
	public var three = 1001;

	public function new() {}
}

class Child extends Base {
	public var four = 9999;
}
