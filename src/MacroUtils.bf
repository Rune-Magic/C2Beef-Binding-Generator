using System;
using System.Collections;
using System.Diagnostics;

using LibClang;

namespace Rune.CBindingGenerator;

static class MacroUtils
{
	private static void GetTokenSpansHelper(CXTranslationUnit unit, bool functionLike, Span<CXToken> tokens, out Span<CXToken> definition, out Span<CXToken> parameters)
	{
		if (tokens.Length <= 1)
		{
			definition = .();
			parameters = .();
			return;
		}

		int i = 1;
		parameters = .();
		if (functionLike)
		{
			Runtime.Assert(Clang.GetTokenKind(tokens[i++]) == .Punctuation, "Expected '('");
			while (true)
			{
				CXToken token = tokens[i++];
				StringView spelling = .(CBindings.GetString!(Clang.GetTokenSpelling(unit, token)));
				if (spelling == ")") break;
			}
			if (i != 3) parameters = tokens[2...i-2];
		}
		definition = tokens[i...];
	}

	private static void DisposeCXStrings(CXString[] strings)
	{
		for (let string in strings)
			Clang.DisposeString(string);
	}

	public static mixin GetTokenSpans(CXCursor macroDef, CXTranslationUnit unit, out Span<CXToken> definition, out Span<StringView> parameters)
	{
		CXToken* tokens = null; uint32 tokenCount = 0;
		Clang.Tokenize(unit, Clang.GetCursorExtent(macroDef), &tokens, &tokenCount);
		defer:mixin Clang.DisposeTokens(unit, tokens, tokenCount);

		GetTokenSpansHelper(unit, Clang.Cursor_IsMacroFunctionLike(macroDef) != 0, .(tokens, tokenCount), out definition, let paramRange);

		List<CXToken> parameterList = scope:mixin .();
		bool comma = false;
		for (let param in paramRange)
		{
			if (!comma) parameterList.Add(param);
			comma = !comma;
		}
		StringView[] paramSpellingBeef = scope:mixin .[parameterList.Count];
		CXString[] paramSpellingCX = scope:mixin .[parameterList.Count];
		defer:mixin DisposeCXStrings(paramSpellingCX);
		for (let i < parameterList.Count)
		{
			paramSpellingCX[i] = Clang.GetTokenSpelling(unit, parameterList[i]);
			paramSpellingBeef[i] = .(Clang.GetCString(paramSpellingCX[i]));
		}
		parameters = paramSpellingBeef;
	}

	public enum ExprTypeGuess
	{
		Unknown,
		Numeric, // contains number literal
		UnsignedInt, // contains number literal that contains 'U'
		Floating, // contains number literal that contains a '.'
		Float, // contains number literal that ends with 'f' and is not hex
		Char, // contains char literal
		String, // contains string literal
		ProbalePointerCast, // contains a '*' followed by a ')'

		UnuseableKeywords, // contains keywords that begin with '__'
	}

	public static ExprTypeGuess WriteTokens(Span<CXToken> tokens, CXTranslationUnit unit, String output)
	{
		bool hasLhs = false, lastStar = false;
		ExprTypeGuess guess = .Unknown;
		mixin SetGuess(ExprTypeGuess newGuess)
		{
			if (guess < newGuess) guess = newGuess;
		}
		for (let token in tokens)
		{
			char8* spelling = CBindings.GetString!(Clang.GetTokenSpelling(unit, token));
			switch (Clang.GetTokenKind(token))
			{
			case .Punctuation:
				switch (*spelling)
				{
				case '+', '-', '*', '/', '|', '&', '^', '>', '<', '=':
					if (hasLhs) output.Append(' ');
					output.Append(spelling);
					if (hasLhs) output.Append(' ');
					hasLhs = true;
				case ',':
					output.Append(", ");
					hasLhs = false;
				case ')':
					if (lastStar) SetGuess!(ExprTypeGuess.ProbalePointerCast);
					output.Append(')');
					hasLhs = true;
				default:
					output.Append(spelling);
					hasLhs = false;
				}
			case .Comment:
				StringView spellingStr = .(spelling);
				if (spellingStr.StartsWith("//"))
					output.Append("/*", spellingStr[2...], "*/");
				else
					output.Append(spellingStr);
			case .Literal:
				StringView spellingStr = .(spelling);
				bool number = false, hex = false;
				literalType: for (let c in spellingStr)
					switch (c)
					{
					case '\'': SetGuess!(ExprTypeGuess.Char  ); break literalType;
					case '\"': SetGuess!(ExprTypeGuess.String); break literalType;
					case 'f', 'F' when number && !hex: SetGuess!(ExprTypeGuess.Float);
					case '.' when number: SetGuess!(ExprTypeGuess.Floating);
					case 'u', 'U' when number: SetGuess!(ExprTypeGuess.UnsignedInt);
					case 'x', 'X' when number: hex = true;
					when _.IsDigit: SetGuess!(ExprTypeGuess.Numeric); number = true;
					case 'l', 'L' when number && (spellingStr.EndsWith('l') || spellingStr.EndsWith('L')):
						spellingStr.RemoveFromEnd(1);
					}
				output.Append(spellingStr);
				hasLhs = true;
			case .Keyword:
				if (StringView(spelling).StartsWith("__"))
					SetGuess!(ExprTypeGuess.UnuseableKeywords);
				fallthrough;
			case .Identifier:
				if (hasLhs) output.Append(' ');
				output.Append(spelling);
				hasLhs = true;
			}
			lastStar = *spelling == '*';
		}
		return guess;
	}
}
