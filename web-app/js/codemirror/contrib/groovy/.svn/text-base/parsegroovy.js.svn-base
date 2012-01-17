/**
 * Copyright (C) 2010 eXo Platform SAS.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 *
 */

/* Parse function for Groovy. Makes use of the tokenizer from
 * tokenizegroovy.js. Note that your parsers do not have to be
 * this complicated -- if you don't want to recognize local variables,
 * in many languages it is enough to just look for braces, semicolons,
 * parentheses, etc, and know when you are inside a string or comment.
 *
 * See manual.html for more info about the parser interface.
 */

var GroovyParser = Editor.Parser = ( function() {
	function GroovyLexical(startColumn, currentToken, align, previousToken,
			encloseLevel) {
		// column at which this scope was opened
		this.startColumn = startColumn;
		// type of scope ('stat' (statement), 'form' (special form), '[', '{', or
		// '(')
		this.currentToken = currentToken;
		// '[', '{', or '(' blocks that have any text after their opening
		// character are said to be 'aligned' -- any lines below are
		// indented all the way to the opening character.
		if (align != null)
			this.align = align;
		// Parent scope, if any.
		this.previousToken = previousToken;
		this.encloseLevel = encloseLevel;
	}
	// Groovy indentation rules.
	function indentGroovy(lexical) {
		return function(firstChars, curIndent, direction) {
			// test if this is next row after the open brace
			if (lexical.encloseLevel !== 0 && firstChars === "}") {
				return lexical.startColumn - indentUnit;
			}

			return lexical.startColumn;
		};
	}

	function parseGroovy(source) {
		source = tokenizeGroovy(source);

		var column = 0; // tells the first non-whitespace symbol from the
		// start of row.
		var previousToken = null;
		var align = false; // tells if the text after the open brace
		var encloseLevel = 0; // tells current opened braces quantity
		var iter = {
			next : function() {
				var token = source.next();

				if (token.type == "whitespace") {
					if (token.value == "\n") { // test if this is end of line
				if (previousToken !== null) {
					if (previousToken.type === "{") { // test if there is open brace at the end of line
						align = true;
						column += indentUnit;
						encloseLevel++;
					} else {
						if (previousToken.type === "}") { // test if there is close brace at the end of line
							align = false;
							if (encloseLevel > 0) {
								encloseLevel--;
							} else {
								encloseLevel = 0;
							}
						}
					}
					var lexical = new GroovyLexical(column, token, align,
							previousToken, encloseLevel);
					token.indentation = indentGroovy(lexical);
				} else {
					token.indentation = function(nextChars, current) {
					}; // to fix javascript error which occures just after the pressing Enter key at the start of the first line                         
				}
			} else
				column = token.value.length;
		}

		previousToken = token;
		return token;
	},

	copy : function() {
		var _column = column;
		return function(_source) {
			column = indented = _column;
			source = tokenizeGroovy(_source);
			return iter;
		};
	}
		};
		return iter;
	}
	return {
		make : parseGroovy,
        electricChars: "}"
	};
})();