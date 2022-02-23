package;

import haxe.macro.Expr;

using haxe.macro.ExprTools;
using haxe.macro.MacroStringTools;

macro function unpack(input: Expr, exprs: Array<Expr>) {
	return impl.Unpack.unpackImpl(input, exprs);
}

macro function assign(input: Expr, field: Expr, value: Expr) {
	return impl.Assign.assignImpl(input, field, value);
}

macro function with(input: Expr, blockOrIdent: Expr, block: Null<Expr> = null) {
	return impl.WithAlso.withImpl(input, blockOrIdent, block);
}

macro function also(input: Expr, blockOrIdent: Expr, block: Null<Expr> = null) {
	return impl.WithAlso.alsoImpl(input, blockOrIdent, block);
}

macro function as(input: Expr, type: Expr) {
	var complexType = type.toString().toComplex();
	return macro cast($input, $complexType);
}

macro function retype(input: Expr) {
	return macro cast $input;
}
