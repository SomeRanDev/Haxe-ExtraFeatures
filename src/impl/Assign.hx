package impl;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ExprTools;
using haxe.macro.PositionTools;
using haxe.macro.TypeTools;

function assignImpl(input: Expr, field: Expr, value: Expr) {
	var fieldName: Null<String> = null;

	switch(field.expr) {
		case EConst(c): {
			switch(c) {
				case CIdent(s): {
					fieldName = s;
				}
				case _:
			}
		}
		case _:
	}

	if(fieldName == null) {
		Context.error('Assign field input \'${field.toString()}\' is not a valid identifier', field.pos);
	}

	return macro @:pos(Context.currentPos()) {
		final it = $input;
		it.$fieldName = $value;
		it;
	}
}

#end
