package impl;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ExprTools;
using haxe.macro.PositionTools;
using haxe.macro.TypeTools;

function onlyifImpl(input: Expr, cond: Expr) {
	return macro if($cond) {
		$input;
	} else {
		null;
	}
}

function onlyifImplVoid(input: Expr, cond: Expr) {
	return macro if($cond) {
		$input;
	}
}

#end