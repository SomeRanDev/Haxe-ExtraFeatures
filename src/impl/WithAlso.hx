package impl;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ExprTools;
using haxe.macro.PositionTools;
using haxe.macro.TypeTools;

function withImpl(input: Expr, blockOrIdent: Expr, block: Null<Expr> = null) {
	if(!isNull(block)) {
		var ident = getIdentFromExpr(blockOrIdent);
		if(ident == null) {
			Context.error('With field input \'${blockOrIdent.toString()}\' is not a valid identifier', blockOrIdent.pos);
		}
		return macro {
			final $ident = $input;
			$block;
		}
	}
	return macro {
		final it = $input;
		$blockOrIdent;
	}
}

function alsoImpl(input: Expr, blockOrIdent: Expr, block: Null<Expr> = null) {
	if(!isNull(block)) {
		var ident = getIdentFromExpr(blockOrIdent);
		if(ident == null) {
			Context.error('Also field input \'${blockOrIdent.toString()}\' is not a valid identifier', blockOrIdent.pos);
		}
		return macro {
			final $ident = $input;
			$block;
			$i{ident};
		}
	}
	return macro {
		final it = $input;
		$blockOrIdent;
		it;
	}
}

function isNull(e: Null<Expr>) {
	if(e != null) {
		return switch(e.expr) {
			case EConst(c): {
				switch(c) {
					case CIdent(id): id == "null";
					case _: false;
				}
			}
			case _: false;
		}
	}
	return false;
}

function getIdentFromExpr(e: Expr) {
	var fieldName: Null<String> = null;

	switch(e.expr) {
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
	
	return fieldName;
}

#end
