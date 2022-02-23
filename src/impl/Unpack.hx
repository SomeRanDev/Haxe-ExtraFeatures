package impl;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.ExprTools;
using haxe.macro.PositionTools;
using haxe.macro.TypeTools;

function unpackImpl(input: Expr, exprs: Array<Expr>) {
	var pos = Context.currentPos();

	var assignmentNames = [];
	var declaredVariables = [];
	var namePositions: Map<String, Position> = [];

	var addAssignmentName = function(name) {
		if(!assignmentNames.contains(name)) {
			assignmentNames.push(name);
		} else {
			Context.error('Multiple instances of \'${name}\' are attemping to be unpacked', pos);
		}
	};

	var index = 1;
	for(expr in exprs) {
		switch(expr.expr) {
			case EVars(vars): {
				declaredVariables.push(expr);
				for(v in vars) {
					addAssignmentName(v.name);
					namePositions[v.name] = expr.pos;
				}
			}
			case EConst(c): {
				switch(c) {
					case CIdent(s): {
						addAssignmentName(s);
						namePositions[s] = expr.pos;
					}
					case _: {
						Context.error('Unpack parameter #$index \'${expr.toString()}\' is not a valid identifier', expr.pos);
					}
				}
			}
			case _: {
				Context.error('Unpack parameter #$index \'${expr.toString()}\' is neither an EVars or EConst(CIdent)', expr.pos);
			}
		}
		index++;
	}

	var typeExpr = Context.typeExpr(input);
	var resultExprs = [];

	//var validNames = findValidFields(typeExpr.t, assignmentNames);
	//for(key in validNames.keys()) {
	//	if(!validNames[key]) {
	//		Context.error('\'$key\' does not match a field on the expression. Aborting macro.', namePositions[key]);
	//	}
	//}

	for(declared in declaredVariables) {
		resultExprs.push(macro @:pos(pos) $declared);
	}

	var assignExpr = [];
	for(name in assignmentNames) {
		// do not explicitly check for field's existance since Haxe will print robust error.
		var exprPos = namePositions[name];
		assignExpr.push(macro @:pos(exprPos) $i{name} = temp.$name);
	}

	resultExprs.push(macro @:pos(pos) {
		var temp = $input;
		$b{assignExpr};
		temp;
	});

	return macro @:mergeBlock $b{resultExprs};
}

function findValidFields(type: Type, fieldNames: Array<String>): Map<String, Bool> {
	var result: Map<String, Bool> = [];
	for(name in fieldNames) {
		result[name] = false;
	}

	switch(type) {
		case TMono(t): {
			var newType = t.get();
			if(newType != null) {
				return findValidFields(newType, fieldNames);
			}
		}
		case TInst(clsTypeRef, _): {
			var clsType = clsTypeRef.get();
			for(f in fieldNames) {
				if(clsType.findField(f) != null) {
					result[f] = true;
				}
			}
		}
		case TType(defTypeRef, _): {
			return findValidFields(defTypeRef.get().type, fieldNames);
		}
		case TAnonymous(anonTypeRef): {
			var fields = anonTypeRef.get().fields;
			for(f in fields) {
				result[f.name] = true;
			}
		}
		case TDynamic(_): {
			for(name in fieldNames) {
				result[name] = true;
			}
		}
		case TLazy(func): {
			return findValidFields(func(), fieldNames);
		}
		case TAbstract(abstractTypeRef, _): {
			return findValidFields(abstractTypeRef.get().type, fieldNames);
		}
		case _:
	}

	return result;
}

#end
