package;

import haxe.macro.Expr;

using haxe.macro.ExprTools;
using haxe.macro.MacroStringTools;

macro function decon(input: Expr, exprs: Array<Expr>) {
	return impl.Decon.deconImpl(input, exprs);
}

macro function onlyif<T>(input: ExprOf<T>, cond: Expr) {
	if(helpers.Expr.isVoid(input)) {
		return impl.OnlyifUnless.onlyifImplVoid(input, cond);
	}
	return impl.OnlyifUnless.onlyifImpl(input, cond);
}

macro function unless<T>(input: ExprOf<T>, cond: Expr) {
	var unlessCond = macro !($cond);
	if(helpers.Expr.isVoid(input)) {
		return impl.OnlyifUnless.onlyifImplVoid(input, unlessCond);
	}
	return impl.OnlyifUnless.onlyifImpl(input, unlessCond);
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
