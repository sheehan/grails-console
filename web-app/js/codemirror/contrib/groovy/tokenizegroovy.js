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

/* Tokenizer for Groovy code */

var tokenizeGroovy = (function() {
  // Advance the stream until the given character (not preceded by a
  // backslash) is encountered, or the end of the line is reached.
  function nextUntilUnescaped(source, end) {
    var escaped = false;
    var next;
    while(!source.endOfLine()){
      var next = source.next();
      if (next == end && !escaped)
        return false;
        escaped = !escaped && next == "\\";
    }
    return escaped;
  }

  // A map of Groovy's keywords. The a/b/c keyword distinction is
  // very rough, but it gives the parser enough information to parse
  // correct code correctly (we don't care that much how we parse
  // incorrect code). The style information included in these objects
  // is used by the highlighter to pick the correct CSS style for a
  // token.
  var keywords = function(){
    function result(type, style){
      return {type: type, style: style};
    }

    var allKeywords = {};
    
    // ------------------- java keywords
    var keywordsList = {};
    
    // keywords that take a parenthised expression, and then a statement (if)
    keywordsList['javaKeywordA'] = new Array('if', 'switch', 'while');
    
    // keywords that take just a statement (else)
    keywordsList['javaKeywordB'] = new Array('else', 'do', 'try', 'finally');

    // keywords that optionally take an expression, and form a statement (return)
    keywordsList['javaKeywordC'] = new Array('break', 'continue', 'extends', 'implements', 'import', 'new', 'package', 'return', 'super', 'this', 'throws');

    for (var keywordType in keywordsList) {
        for (var i = 0; i < keywordsList[keywordType].length; i++) {
            allKeywords[keywordsList[keywordType][i]] = result(keywordType, "javaKeyword");
        }
    }

    keywordsList = {};
    
    // java atom
    keywordsList['javaAtom'] = new Array('null', 'true', 'false');
    for (var keywordType in keywordsList) {
        for (var i = 0; i < keywordsList[keywordType].length; i++) {
            allKeywords[keywordsList[keywordType][i]] = result(keywordType, keywordType);
        }
    }

    keywordsList = {};

    // java modifiers - according to http://docs.codehaus.org/display/GROOVY/Reserved+Words
    keywordsList['javaModifier'] = new Array('abstract', 'final', 'native', 'private', 'protected', 'public', 'static', 'strictfp', 'synchronized', 'threadsafe', 'transient', 'volatile');

    // java types
    keywordsList['javaType'] = new Array('boolean', 'byte', 'char', 'enum', 'double', 'float', 'int', 'interface', 'long', 'short', 'void', 'class');
    for (var keywordType in keywordsList) {
        for (var i = 0; i < keywordsList[keywordType].length; i++) {
            allKeywords[keywordsList[keywordType][i]] = result('function', keywordType);
        }
    }

    // other java keywords
    allKeywords = objectConcat(allKeywords, {
        "catch": result("catch", "javaKeyword"),
        "for": result("for", "javaKeyword"),
        "case": result("case", "javaKeyword"),
        "default": result("default", "javaKeyword"),
        "instanceof": result("operator", "javaKeyword")         
    });

    // ------------------- groovy keywords
    var keywordsList = {};

    // GJDK methods
    keywordsList['groovyGsdkMethod'] = new Array('abs','any','append','asList','asWritable','collect','compareTo','count','div','dump','each','eachByte','eachFile','eachLine','every','find','findAll','getAt','getErr','getIn','getOut','getText','grep','inject','inspect','intersect','isCase','join','leftShift','minus','multiply','mixin','newInputStream','newOutputStream','newPrintWriter','newReader','newWriter','next','plus','pop','power','previous','print','println','push','putAt','readBytes','readLines','reverse','reverseEach','round','size','sort','splitEachLine','step','subMap','times','toInteger','toList','tokenize','upto','waitForOrKill','withPrintWriter','withReader','withStream','withWriterAppend','write','writeLine');
    for (var i = 0; i < keywordsList['groovyGsdkMethod'].length; i++) {
        allKeywords[keywordsList['groovyGsdkMethod'][i]] = result("groovyGsdkMethod", "groovyGsdkMethod");
    }

    // keywords that optionally take an expression, and form a statement (return)
    keywordsList['groovyKeywordC'] = new Array('assert', 'property');
    for (var i = 0; i < keywordsList['groovyKeywordC'].length; i++) {
        allKeywords[keywordsList['groovyKeywordC'][i]] = result("groovyKeywordC", "groovyKeyword");
    }
    
    // other groovy keywords
    allKeywords = objectConcat(allKeywords, {
        "as": result("operator", "groovyKeyword"),
        "in": result("operator", "groovyKeyword"),
        "def": result("function", "groovyKeyword")
    });

    return allKeywords;
  }();

  // Some helper regexp matchers.
  var isOperatorChar = /[+\-*&%\/=<>!?|]/;
  var isDigit = /[0-9]/;
  var isHexDigit = /^[0-9A-Fa-f]$/;
  var isWordChar = /[\w\$_]/;
  var isGroovyVariableChar = /[\w\.()\[\]{}]/;
  var isPunctuation = /[\[\]{}\(\),;\:\.]/;
  var isStringDelimeter = /^[\/'"]$/;
  var isRegexpDelimeter = /^[\/'$]/;

  // Wrapper around groovyToken that helps maintain parser state (whether
  // we are inside of a multi-line comment and whether the next token
  // could be a regular expression).
  function groovyTokenState(inside, regexp) {
    return function(source, setState) {
      var newInside = inside;
      var type = groovyToken(inside, regexp, source, function(c) {newInside = c;});
      var newRegexp = type.type == "operator" || type.type == "javaKeywordC" || type.type == "groovyKeywordC" || type.type.match(/^[\[{}\(,;:]$/);
      if (newRegexp != regexp || newInside != inside)
        setState(groovyTokenState(newInside, newRegexp));
      return type;
    };
  }

  // The token reader, inteded to be used by the tokenizer from
  // tokenize.js (through groovyTokenState). Advances the source stream
  // over a token, and returns an object containing the type and style
  // of that token.
  function groovyToken(inside, regexp, source, setInside) {
    function readHexNumber(){
      setInside(null);
      source.next(); // skip the 'x'
      source.nextWhileMatches(isHexDigit);
      return {type: "number", style: "groovyNumber"};
    }

    function readNumber() {
      setInside(null);
      source.nextWhileMatches(isDigit);
      if (source.equals(".")){
        source.next();
        
        // read ranges
        if (source.equals("."))
          source.next();
          
        source.nextWhileMatches(isDigit);
      }
      if (source.equals("e") || source.equals("E")){
        source.next();
        if (source.equals("-"))
          source.next();
        source.nextWhileMatches(isDigit);
      }
      return {type: "number", style: "groovyNumber"};
    }
    // Read a word, look it up in keywords. If not found, it is a
    // variable, otherwise it is a keyword of the type found.
    function readWord() {
      setInside(null);      
      source.nextWhileMatches(isWordChar);
      var word = source.get();
      var known = keywords.hasOwnProperty(word) && keywords.propertyIsEnumerable(word) && keywords[word];
      return known ? {type: known.type, style: known.style, content: word} :
      {type: "variable", style: "groovyVariable", content: word};
    }
    
    // Read a varibale inside the GString like this: variant1: "$word", variant2: "${word.isPalindrome()}". If not found, returns null.
    function readGVariable() {
      source.nextWhileMatches(isGroovyVariableChar);
      var word = source.get();
      return {type: "variable", style: "groovyVariable", content: word};
    }
    
    // read regexp like /\w{1}:\\.+\\.+/
    function readRegexp() {
      // go to the end / not \/
      nextUntilUnescaped(source, "/");
      
      return {type: "regexp", style: "groovyRegexp"};
    }
    
    // Mutli-line comments are tricky. We want to return the newlines
    // embedded in them as regular newline tokens, and then continue
    // returning a comment token for every line of the comment. So
    // some state has to be saved (inside) to indicate whether we are
    // inside a /* */ sequence.
    function readMultilineComment(start){
      var newInside = "/*";
      var maybeEnd = (start == "*");
      while (true) {
        if (source.endOfLine())
          break;
        var next = source.next();
        if (next == "/" && maybeEnd){
          newInside = null;
          break;
        }
        maybeEnd = (next == "*");
      }
      setInside(newInside);
      return {type: "comment", style: "groovyComment"};
    }

    function readAnnotation(){
      source.nextWhileMatches(isWordChar);
      var word = source.get();
      return {type: "annotation", style: "javaAnnotation", content: word};
    }
    
    function readOperator() {
      if (ch == "=") 
        setInside("=")
      else if (ch == "~")
        setInside("~")
      else setInside(null);

      return {type: "operator", style: "groovyOperator"};
    }
    function readString(quote) {           
      var newInside = quote;
      if (source.endOfLine()) {  // finish String coloring after the end of the line
        newInside = null;
      } else {     
        var next = source.next();
        
        // Read a varibale inside the GString like this: variant1: "$word", variant2: "${word.isPalindrome()}", "${word[1]}", /${word[1]}/, not "$ word".
        if (quote != "'"  
              && next == "$" 
              && !source.equals(" ")) {
          source.next();
          return readGVariable();
        }
        
        // test if this is  \", \' or \/ inside the String 
        if (next == "\\" && source.equals(quote)) {
          newInside = "\\" + quote;
          source.next();
        } else if (next == quote) {  // finish String coloring after the ', " or /, not \', \", \/
          newInside = null;
        }
      }

      setInside(newInside);
      return {type: "string", style: "groovyString"};
    }
    
    function inMultilineGString(delimeter) {           
      if (source.lookAhead(delimeter, true)){         
        setInside(null);
        return {type: "string", style: "groovyString"};        
      }
      
      var next = source.next();

       // Read a variable inside the GString like this: variant1: "$word", variant2: "${word.isPalindrome()}", not "$ word".
      if (delimeter == '"""' && next == "$" && ! source.equals(" ")) {
        source.next();
        return readGVariable();
      }
      
      return {type: "string", style: "groovyString"};      
    }

    // Fetch the next token. Dispatches on first character in the
    // stream, or first two characters when the first is a slash.        

    // to avoid the considering of \", \', \/ as the end of String inside the String
    if (inside == '\\"' || inside == "\\'" || inside == "\\/") {
      setInside(inside[1]);  // set 'inside' = ', ", /
      return {type: "string", style: "groovyString"};      
    }

    // test if we within the String
    if (isStringDelimeter.test(inside))
      return readString(inside);

    // test if we within the Multiline String
    if (inside == "'''" || inside == '"""')
      return inMultilineGString(inside);

    // test if this is the start of Multiline String
    if ( source.lookAhead(delimeter = "'''", true) || source.lookAhead(delimeter = '"""', true) ) {      
      setInside(delimeter);
      return {type: "string", style: "groovyString"};
    }
      
    var ch = source.next();
        
    if (inside == "/*")  // test if this is the start of Multiline Comment
      return readMultilineComment(ch);
      
    else if (ch == "'" || ch == '"') {   // test if this is the start of String
      setInside(ch);
      return {type: "string", style: "groovyString"};
    }

    // test if this is range 
    else if ( ch == "." && source.equals(".")) {
      source.next();
      return {type: "..", style: "groovyOperator"};      
    }
    
    // with punctuation, the type of the token is the symbol itself
    else if (isPunctuation.test(ch))
      return {type: ch, style: "groovyPunctuation"};
    else if (ch == "0" && (source.equals("x") || source.equals("X")))
      return readHexNumber();
    else if (isDigit.test(ch))
      return readNumber();
    else if (ch == "@")
      return readAnnotation();      
    else if (ch == "/"){
      if (source.equals("*"))
      { source.next(); return readMultilineComment(ch); }
      else if (source.equals("/"))
      { nextUntilUnescaped(source, null); return {type: "comment", style: "groovyComment"};}
      else if (inside == "=" || inside == "~" )   // read slashy string like (def winpathSlashy=/C:\windows\system32/) not def c = a / 5;
        return readRegexp();  
      else return readOperator();
    }

    else if (ch == "~") { 
      setInside("~");  // prepare to read slashy string like ~ /\w{1}:\\.+\\.+/ 
      return readOperator(ch);
    }       
    else if (isOperatorChar.test(ch))
      return readOperator(ch);
    else
      return readWord();
  }

  // returns new object = object1 + object2
  function objectConcat(object1, object2) {
    for(var name in object2) {
        if (!object2.hasOwnProperty(name)) continue;
        if (object1.hasOwnProperty(name)) continue;
        object1[name] = object2[name];
    }
    return object1;
  }

  // The external interface to the tokenizer.
  return function(source, startState) {
    return tokenizer(source, startState || groovyTokenState(false, true));
  };
})();
