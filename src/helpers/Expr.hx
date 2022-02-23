package helpers;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;

function isVoid(e: Expr): Bool {
	var type = Context.typeExpr(e).t;
	return haxe.macro.TypeTools.toString(type) == "Void";
}

#end
