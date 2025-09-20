using System;
using System.IO;
using System.Threading; //TODO
using System.Collections;
using System.Diagnostics;

namespace Rune.CBindingGenerator;

static class Program
{
	static void PrintUsage()
	{
		Console.WriteLine("""
			Usage: CBindingGenerator [OPTIONS...] <input header file> [--clang-args|-A CLANG_ARGS...]

			Options with 1 argument:
			 --output, -o		beef output file
			 --name, -n		output namespace
			 --function-attrs	custom function attributes
			 --custom-linkage	custom linkage
			 --using-dep, -d	using dependency
			 --black-list, -b	type or function with this name will be excluded

			Other options:
			 --help			prints this message
			 --clang-args, -A	all arguments passed after this flag will be passed to clang

			Flags:
			 --vulkan-like		marks the the library as vulkan like
			""");
	}

	public static int Main(String[] args)
	{
		if (args.Count <= 0)
		{
			PrintUsage();
			return -1;
		}
		if (args[0] == "--help")
		{
			PrintUsage();
			return 0;
		}
		
#if DEBUG
		if (args[0] == "__gen_clang")
		{
			Rune.CBindingGenerator.GenerateClang.GenerateClangBindings();
			return 0;
		}
#endif

		String
			inputFile = .Empty,
			outputFile = .Empty,
			name = .Empty,
			functionAttrs = .Empty,
			customLinkage = .Empty;
		CBindings.Flags flags = .None;
		List<char8*> clangArgs = scope .() { "--language=c" };
		List<StringView> usingDependencies = scope .(), blackList = scope .();

		mixin Assert(bool condition, StringView errMsg)
		{
			if (!condition)
			{
				Console.WriteLine(errMsg);
				return -1;
			}
		}
		mixin AssertF(bool condition, StringView errMsgFormat, var formatArg)
		{
			if (!condition)
			{
				Console.WriteLine(errMsgFormat, formatArg);
				return -1;
			}
		}

		parseArgs: for (int i < args.Count)
		{
			let arg = args[i];

			mixin NextArg(ref String outString)
			{
				AssertF!(++i < args.Count, "Error: Error: {} expects an argument", arg);
				AssertF!(outString.IsEmpty || outString == args[i], "Error: Duplicate option {} with different value", arg);
				outString = args[i];
			}

			mixin AddNextArg(List<StringView> list)
			{
				AssertF!(++i < args.Count, "Error: Error: {} expects an argument", arg);
				list.Add(args[i]);
			}

			switch (arg)
			{
			case "--output", "-o": NextArg!(ref outputFile);
			case "--name", "-n": NextArg!(ref name);
			case "--function-attrs": NextArg!(ref functionAttrs);
			case "--custom-linkage": NextArg!(ref customLinkage);
			case "--using-dep", "-d": AddNextArg!(usingDependencies);
			case "--black-list", "-b": AddNextArg!(blackList);
			case "--help": PrintUsage();
			case "--vulkan-like": flags |= .VulkanLike;
			case "--clang-args", "-A":
				clangArgs.Resize(clangArgs.Count + args.Count - i);
				while (i++ < args.Count)
					clangArgs.Add(args[i]);
				break parseArgs;
			default:
				AssertF!(!arg.StartsWith('-'), "Error: invalid flag {}", arg);
				Assert!(inputFile.IsEmpty, "Error: Duplicate input file");
				AssertF!(File.Exists(arg), "Error: Input file {} doesn't exist", arg);
				inputFile = arg;
			}
		}

		Assert!(!inputFile.IsEmpty, "Error: No input file");
		Assert!(!outputFile.IsEmpty, "Error: No output file (--output, -o)");
		Assert!(!name.IsEmpty, "Error: No output namespace specified (--name, -n)");

		CBindings.args = clangArgs;
		CBindings.Generate(inputFile, outputFile, name, scope .() { flags=flags, blackList=blackList,
			customFunctionAttributes=functionAttrs, customLinkage=customLinkage }, params usingDependencies);

		return 0;
	}
}
