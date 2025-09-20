## Rune's C2Beef Binding Generator
a flexible C binding generator for the Beef Programming Language

### Features
- macro constants
- using fields
- bitfields
- out parameters
- function pointers with parameter names

### Library
For an Example, see [this file](src/GenerateClang.bf) that generates the clang bindings used by this library
```beef
using Rune.CBindingGenerator;

// allows you to customize the output
CBindings.LibraryInfo libraryInfo = scope .()
{
    customFunctionAttributes = "CallingConvention(.StdCall)",
    modifyEnumCaseSpelling = scope (spelling, parentSpelling, strBuffer) =>
    {
        // strBuffer can be used to change the character data of `spelling`
        // without overriding its contents
        //strBuffer = new .(spelling);
        strBuffer = null;

        if (spelling.StartsWith(parentSpelling))
            spelling.RemoveFromStart(parentSpelling.Length);
    },
    // ...
};

// set args that will be passed to clang
CBindings.args = char8*[?]("--language=c", "-I/some/path", "-DSOME_MACRO");

// generate a binding from a header
CBindings.Generate("/path/to/header.h", "Output.bf", "OutputNamespace", libraryInfo);
```

### CLI
Example: `CBindingGenerator -n Example -o src/Example.bf include/example.h -A -I../otherlib/include`
```
Usage: CBindingGenerator [OPTIONS...] <input header file> [--clang-args|-A CLANG_ARGS...]

Options with 1 argument:
 --output, -o		beef output file
 --name, -n			output namespace
 --function-attrs	custom function attributes
 --custom-linkage	custom linkage
 --using-dep, -d	using dependency
 --black-list, -b	type or function with this name will be excluded

Other options:
 --help				prints this message
 --clang-args, -A	all arguments passed after this flag will be passed to clang

Flags:
 --vulkan-like		marks the the library as vulkan like
 ```

