using System;
using System.IO;

using Rune.CBindingGenerator;

namespace Rune.CBindingGenerator.GenerateClang;

static
{
	[CLink] public static extern int32 system(char8*);

	public static void GenerateClangBindings()
	{
		const StringView[?] clangFiles = .(
			"BuildSystem",
			"CXCompilationDatabase",
			"CXDiagnostic",
			"CXErrorCode",
			"CXFile",
			"CXSourceLocation",
			"CXString",
			"Documentation",
			"ExternC",
			"FatalErrorHandler",
			"Index",
			"Platform",
			"Rewrite",
		);

		Directory.CreateDirectory("Clang/clang-c");
		CBindings.args = char8*[?]("--language=c", "-IClang");
		CBindings.LibraryInfo libInfo = scope .()
		{
			customLinkage = "Import(Clang.dll)",

			isHandleUnderlyingOpaque = scope (type, spelling, typedefSpelling) =>
			{
				return (type.kind == .Void && typedefSpelling != "CXClientData") || spelling.EndsWith("Impl");
			},

			getBlock = scope (cursor, spelling) =>
			{
				if (cursor.kind == .FunctionDecl)
					return "Clang";
				return null;
			},

			modifySourceName = scope (cursor, spelling, strBuffer) =>
			{
				strBuffer = null;
				if (!spelling.StartsWith("clang_")) return;
				spelling.RemoveFromStart(6);
				strBuffer = new .(spelling.Length);
				bool underscore = true;
				for (let c in spelling)
				{
					if (underscore) strBuffer.Append(c.ToUpper);
					else strBuffer.Append(c);
					underscore = c == '_';
				}
				spelling = strBuffer;
			},

			modifyEnumCaseSpelling = scope (spelling, parentSpelling, strBuffer) =>
			{
				strBuffer = null;
				if (spelling.StartsWith(parentSpelling))
				{
					spelling.RemoveFromStart(parentSpelling.Length + 1);
				}
				else
				{
					let length = Math.Min(spelling.Length, parentSpelling.Length);
					for (let i < length)
					{
						if (spelling[i] == parentSpelling[i]) continue;
						spelling.RemoveFromStart(i);
						if (spelling.StartsWith('_'))
							spelling.RemoveFromStart(1);
						break;
					}
				}
			},
		};
		for (let file in clangFiles)
		{
			if (system(scope $"curl -o Clang/clang-c/{file}.h https://raw.githubusercontent.com/llvm/llvm-project/refs/heads/main/clang/include/clang-c/{file}.h") != 0)
				Runtime.FatalError(scope $"Failed to download clang-c/{file}");
			if (file == "ExternC" || file == "Platform") continue;
			CBindings.Generate(scope $"Clang/clang-c/{file}.h", scope $"Clang/src/{file}.bf", "LibClang", libInfo);
			Console.WriteLine(scope $"Generated Clang/src/{file}.bf");
		}
	}
}
