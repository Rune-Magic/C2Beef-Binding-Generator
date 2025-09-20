#if CLANG_BACKUP_BINDINGS

using System;
using System.Interop;

namespace LibClang;

public typealias CXIndex = void*;
public struct CXTranslationUnitImpl;
public typealias CXTranslationUnit = CXTranslationUnitImpl*;

[CRepr]
struct CXUnsavedFile
{
	public c_char* Filename;
	public c_char* Contents;
	public c_ulong Length;
}

[CRepr]
public struct CXCursor
{
	public CXCursorKind kind;
	c_int xdata;
	void*[3] data;
}

[CRepr]
public struct CXString
{
	readonly void* data;
	c_uint flags;
}

[CRepr]
public struct CXType
{
	public CXTypeKind kind;
	void*[2] data;
}

[CRepr]
public struct CXToken
{
	c_uint[4] int_data;
	void* ptr_data;
}

[CRepr]
public enum CXChildVisitResult : c_int
{
	Break,
	Continue,
	Recurse
}

public typealias CXClientData = void*;
public typealias CXCursorVisitor = function CXChildVisitResult (CXCursor cursor, CXCursor parent, CXClientData data);

[CRepr]
public struct CXSourceLocation
{
	void*[2] ptr_data;
	c_uint int_data;
}

[CRepr]
public struct CXSourceRange
{
	void*[2] ptr_data;
	public c_uint begin_int_data;
	public c_uint end_int_data;
}

[CRepr]
public struct CXComment
{
	public void* ASTNode;
	public CXTranslationUnit TranslationUnit;
}

static class Clang
{
	const String libclang = "libclang" + 
#if BF_PLATFORM_WINDOWS
		".dll";
#elif BF_PLATFORM_MACOS
		".dylib";
#else
		".so";
#endif

	// string
	[Import(libclang), LinkName("clang_getEnumConstantDeclValue")]
	public static extern c_longlong GetEnumConstantDeclValue(CXCursor cursor);
	
	[Import(libclang), LinkName("clang_getEnumDeclIntegerType")]
	public static extern CXType GetEnumDeclIntegerType(CXCursor cursor);

	[Import(libclang), LinkName("clang_getCursorSpelling")]
	public static extern CXString GetCursorSpelling(CXCursor cursor);

	[Import(libclang), LinkName("clang_getCString")]
	public static extern c_char* GetCString(CXString str);

	[Import(libclang), LinkName("clang_disposeString")]
	public static extern void DisposeString(CXString str);

	//index
	[Import(libclang), LinkName("clang_createIndex")]
	public static extern CXIndex CreateIndex(c_int excludeDeclarationsFromPCH, c_int displayDiagnostics);

	[Import(libclang), LinkName("clang_disposeIndex")]
	public static extern void DisposeIndex(CXIndex index);


	// translation unit
	[Import(libclang), LinkName("clang_parseTranslationUnit")]
	public static extern CXTranslationUnit ParseTranslationUnit(CXIndex index, c_char* path, c_char** argv, c_int argc, CXUnsavedFile* unsavedFiles, c_uint unsavedFilesCount, c_int options);

	[Import(libclang), LinkName("clang_disposeTranslationUnit")]
	public static extern void DisposeTranslationUnit(CXTranslationUnit unit);

	// cursor
	[Import(libclang), LinkName("clang_getTranslationUnitCursor")]
	public static extern CXCursor GetTranslationUnitCursor(CXTranslationUnit unit);

	[Import(libclang), LinkName("clang_Cursor_getTranslationUnit")]
	public static extern CXTranslationUnit Cursor_GetTranslationUnit(CXCursor cursor);

	[Import(libclang), LinkName("clang_Cursor_isAnonymous")]
	public static extern c_uint Cursor_IsAnonymous(CXCursor);

	[Import(libclang), LinkName("clang_visitChildren")]
	public static extern c_uint VisitChildren(CXCursor cursor, CXCursorVisitor visitor, CXClientData client_data);

	[Import(libclang), LinkName("clang_getCursorKind")]
	public static extern CXCursorKind GetCursorKind(CXCursor cursor);

	[Import(libclang), LinkName("clang_Cursor_getRawCommentText")]
	public static extern CXString Cursor_GetRawCommentText(CXCursor cursor);

	[Import(libclang), LinkName("clang_Cursor_isMacroFunctionLike")]
	public static extern c_uint Cursor_IsMacroFunctionLike(CXCursor cursor);

	[Import(libclang), LinkName("clang_Cursor_isBitField")]
	public static extern c_uint Cursor_IsBitField(CXCursor);

	[Import(libclang), LinkName("clang_getFieldDeclBitWidth")]
	public static extern c_int GetFieldDeclBitWidth(CXCursor);

	[Import(libclang), LinkName("clang_Cursor_getParsedComment")]
	public static extern CXComment Cursor_GetParsedComment(CXCursor C);

	// type
	[Import(libclang), LinkName("clang_getCursorType")]
	public static extern CXType GetCursorType(CXCursor cursor);

	[Import(libclang), LinkName("clang_getTypeSpelling")]
	public static extern CXString GetTypeSpelling(CXType type);

	[Import(libclang), LinkName("clang_getTypeDeclaration")]
	public static extern CXCursor GetTypeDeclaration(CXType type);

	[Import(libclang), LinkName("clang_getPointeeType")]
	public static extern CXType GetPointeeType(CXType type);

	[Import(libclang), LinkName("clang_getTypedefDeclUnderlyingType")]
	public static extern CXType GetTypedefDeclUnderlyingType(CXCursor cursor);

	[Import(libclang), LinkName("clang_isConstQualifiedType")]
	public static extern c_uint IsConstQualifiedType(CXType type);

	[Import(libclang), LinkName("clang_getArrayElementType")]
	public static extern CXType GetArrayElementType(CXType type);

	[Import(libclang), LinkName("clang_getArraySize")]
	public static extern c_longlong GetArraySize(CXType type);

	[Import(libclang), LinkName("clang_Type_getNamedType")]
	public static extern CXType Type_GetNamedType(CXType type);

	[Import(libclang), LinkName("clang_Type_getSizeOf")]
	public static extern c_longlong Type_GetSizeOf(CXType type);

	// function
	[Import(libclang), LinkName("clang_getCursorResultType")]
	public static extern CXType GetCursorResultType(CXCursor cursor); 

	[Import(libclang), LinkName("clang_getFunctionTypeCallingConv")]
	public static extern CXCallingConv GetCursorCallingConv(CXType cursor);

	[Import(libclang), LinkName("clang_Cursor_getNumArguments")]
	public static extern c_int Cursor_GetNumArguments(CXCursor cursor);

	[Import(libclang), LinkName("clang_Cursor_getArgument")]
	public static extern CXCursor Cursor_GetArgument(CXCursor cursor, c_uint i);

	[Import(libclang), LinkName("clang_Cursor_isVariadic")]
	public static extern c_uint Cursor_IsVariadic(CXCursor cursor);

	[Import(libclang), LinkName("clang_getCursorLinkage")]
	public static extern CXLinkageKind GetCursorLinkage(CXCursor cursor);

	[Import(libclang), LinkName("clang_getResultType")]
	public static extern CXType GetResultType(CXType type);

	[Import(libclang), LinkName("clang_getNumArgTypes")]
	public static extern c_uint GetNumArgTypes(CXType type);

	[Import(libclang), LinkName("clang_getArgType")]
	public static extern CXType GetArgType(CXType type, c_uint index);

	// file
	public typealias CXFile = void*;

	[Import(libclang), LinkName("clang_getIncludedFile")]
	public static extern CXFile GetIncludedFile(CXCursor cursor);

	[Import(libclang), LinkName("clang_getFileName")]
	public static extern CXString GetFileName(CXFile file);

	// Method
	[Import(libclang), LinkName("clang_CXXMethod_isStatic")]
	public static extern c_uint CXXMethod_isStatic(CXCursor cursor);
	
	[Import(libclang), LinkName("clang_CXXMethod_isPureVirtual")]
	public static extern c_uint CXXMethod_isPureVirtual(CXCursor cursor);
	
	[Import(libclang), LinkName("clang_CXXMethod_isVirtual")]
	public static extern c_uint CXXMethod_isVirtual(CXCursor cursor);

	[Import(libclang), LinkName("clang_CXXMethod_isConst")]
	public static extern c_uint CXXMethod_isConst(CXCursor cursor);

	// struct
	[Import(libclang), LinkName("clang_CXXRecord_isAbstract")]
	public static extern c_uint CXXRecord_isAbstract(CXCursor cursor);

	// source location
	[Import(libclang), LinkName("clang_getRangeStart")]
	public static extern CXSourceLocation GetRangeStart(CXSourceRange);

	[Import(libclang), LinkName("clang_getRangeEnd")]
	public static extern CXSourceLocation GetRangeEnd(CXSourceRange);

	[Import(libclang), LinkName("clang_getCursorLocation")]
	public static extern CXSourceLocation GetCursorLocation(CXCursor cursor);

	[Import(libclang), LinkName("clang_getCursorExtent")]
	public static extern CXSourceRange GetCursorExtent(CXCursor cursor);

	[Import(libclang), LinkName("clang_getCursor")]
	public static extern CXCursor GetCursor(CXTranslationUnit, CXSourceLocation);
	
	[Import(libclang), LinkName("clang_getSpellingLocation")]
	public static extern void GetSpellingLocation(
		CXSourceLocation location, out CXFile file,
		out c_uint line, out c_uint column, out c_uint offset
	);

	// token
	[Import(libclang), LinkName("clang_getToken")]
	public static extern CXToken* GetToken(CXTranslationUnit TU, CXSourceLocation Location);

	[Import(libclang), LinkName("clang_tokenize")]
	public static extern void Tokenize(CXTranslationUnit TU, CXSourceRange Range,
									   CXToken** Tokens, c_uint* NumTokens);

	[Import(libclang), LinkName("clang_getTokenSpelling")]
	public static extern CXString GetTokenSpelling(CXTranslationUnit, CXToken);

	[Import(libclang), LinkName("clang_getTokenKind")]
	public static extern CXTokenKind GetTokenKind(CXToken);

	[Import(libclang), LinkName("clang_getTokenLocation")]
	public static extern CXSourceLocation GetTokenLocation(CXTranslationUnit, CXToken);

	[Import(libclang), LinkName("clang_getTokenExtent")]
	public static extern CXSourceRange GetTokenExtent(CXTranslationUnit, CXToken);

	[Import(libclang), LinkName("clang_disposeTokens")]
	public static extern void DisposeTokens(CXTranslationUnit TU, CXToken* Tokens,
											c_uint NumTokens);
}

/////////////////////////////////////////////////////////////////////////////////

[CRepr]
public enum CXTranslationUnit_Flags : c_uint
{
	None = 0x0,
	DetailedPreprocessingRecord = 0x01,
	Incomplete = 0x02,
	PrecompiledPreamble = 0x04,
	CacheCompletionResults = 0x08,
	ForSerialization = 0x10,
	CXXChainedPCH = 0x20,
	SkipFunctionBodies = 0x40,
	IncludeBriefCommentsInCodeCompletion = 0x80,
	CreatePreambleOnFirstParse = 0x100,
	KeepGoing = 0x200,
	SingleFileParse = 0x400,
	LimitSkipFunctionBodiesToPreamble = 0x800,
	IncludeAttributedTypes = 0x1000,
	VisitImplicitAttributes = 0x2000,
	IgnoreNonErrorsFromIncludedFiles = 0x4000,
	RetainExcludedConditionalBlocks = 0x8000
}

[CRepr]
public enum CXLinkageKind {
  /** This value indicates that no linkage information is available
   * for a provided CXCursor. */
  Invalid,
  /**
   * This is the linkage for variables, parameters, and so on that
   *  have automatic storage.  This covers normal (non-extern) local variables.
   */
  NoLinkage,
  /** This is the linkage for static variables and static functions. */
  Internal,
  /** This is the linkage for entities with external linkage that live
   * in C++ anonymous namespaces.*/
  UniqueExternal,
  /** This is the linkage for entities with true, external linkage. */
  External
}

[CRepr, AllowDuplicates]
public enum CXTypeKind {
  /**
   * Represents an invalid type (e.g., where no type is available).
   */
  Invalid = 0,

  /**
   * A type whose specific kind is not exposed via this
   * interface.
   */
  Unexposed = 1,

  /* Builtin types */
  Void = 2,
  Bool = 3,
  Char_U = 4,
  UChar = 5,
  Char16 = 6,
  Char32 = 7,
  UShort = 8,
  UInt = 9,
  ULong = 10,
  ULongLong = 11,
  UInt128 = 12,
  Char_S = 13,
  SChar = 14,
  WChar = 15,
  Short = 16,
  Int = 17,
  Long = 18,
  LongLong = 19,
  Int128 = 20,
  Float = 21,
  Double = 22,
  LongDouble = 23,
  NullPtr = 24,
  Overload = 25,
  Dependent = 26,
  ObjCId = 27,
  ObjCClass = 28,
  ObjCSel = 29,
  Float128 = 30,
  Half = 31,
  Float16 = 32,
  ShortAccum = 33,
  Accum = 34,
  LongAccum = 35,
  UShortAccum = 36,
  UAccum = 37,
  ULongAccum = 38,
  BFloat16 = 39,
  Ibm128 = 40,
  FirstBuiltin = Void,
  LastBuiltin = Ibm128,

  Complex = 100,
  Pointer = 101,
  BlockPointer = 102,
  LValueReference = 103,
  RValueReference = 104,
  Record = 105,
  Enum = 106,
  Typedef = 107,
  ObjCInterface = 108,
  ObjCObjectPointer = 109,
  FunctionNoProto = 110,
  FunctionProto = 111,
  ConstantArray = 112,
  Vector = 113,
  IncompleteArray = 114,
  VariableArray = 115,
  DependentSizedArray = 116,
  MemberPointer = 117,
  Auto = 118,

  /**
   * Represents a type that was referred to using an elaborated type keyword.
   *
   * E.g., struct S, or via a qualified name, e.g., N::M::type, or both.
   */
  Elaborated = 119,

  /* OpenCL PipeType. */
  Pipe = 120,

  /* OpenCL builtin types. */
  OCLImage1dRO = 121,
  OCLImage1dArrayRO = 122,
  OCLImage1dBufferRO = 123,
  OCLImage2dRO = 124,
  OCLImage2dArrayRO = 125,
  OCLImage2dDepthRO = 126,
  OCLImage2dArrayDepthRO = 127,
  OCLImage2dMSAARO = 128,
  OCLImage2dArrayMSAARO = 129,
  OCLImage2dMSAADepthRO = 130,
  OCLImage2dArrayMSAADepthRO = 131,
  OCLImage3dRO = 132,
  OCLImage1dWO = 133,
  OCLImage1dArrayWO = 134,
  OCLImage1dBufferWO = 135,
  OCLImage2dWO = 136,
  OCLImage2dArrayWO = 137,
  OCLImage2dDepthWO = 138,
  OCLImage2dArrayDepthWO = 139,
  OCLImage2dMSAAWO = 140,
  OCLImage2dArrayMSAAWO = 141,
  OCLImage2dMSAADepthWO = 142,
  OCLImage2dArrayMSAADepthWO = 143,
  OCLImage3dWO = 144,
  OCLImage1dRW = 145,
  OCLImage1dArrayRW = 146,
  OCLImage1dBufferRW = 147,
  OCLImage2dRW = 148,
  OCLImage2dArrayRW = 149,
  OCLImage2dDepthRW = 150,
  OCLImage2dArrayDepthRW = 151,
  OCLImage2dMSAARW = 152,
  OCLImage2dArrayMSAARW = 153,
  OCLImage2dMSAADepthRW = 154,
  OCLImage2dArrayMSAADepthRW = 155,
  OCLImage3dRW = 156,
  OCLSampler = 157,
  OCLEvent = 158,
  OCLQueue = 159,
  OCLReserveID = 160,

  ObjCObject = 161,
  ObjCTypeParam = 162,
  Attributed = 163,

  OCLIntelSubgroupAVCMcePayload = 164,
  OCLIntelSubgroupAVCImePayload = 165,
  OCLIntelSubgroupAVCRefPayload = 166,
  OCLIntelSubgroupAVCSicPayload = 167,
  OCLIntelSubgroupAVCMceResult = 168,
  OCLIntelSubgroupAVCImeResult = 169,
  OCLIntelSubgroupAVCRefResult = 170,
  OCLIntelSubgroupAVCSicResult = 171,
  OCLIntelSubgroupAVCImeResultSingleRefStreamout = 172,
  OCLIntelSubgroupAVCImeResultDualRefStreamout = 173,
  OCLIntelSubgroupAVCImeSingleRefStreamin = 174,

  OCLIntelSubgroupAVCImeDualRefStreamin = 175,

  ExtVector = 176,
  Atomic = 177,
  BTFTagAttributed = 178
}

/**
 * Describes the calling convention of a function type
 */
[CRepr, AllowDuplicates]
public enum CXCallingConv {
  Default = 0,
  C = 1,
  X86StdCall = 2,
  X86FastCall = 3,
  X86ThisCall = 4,
  X86Pascal = 5,
  AAPCS = 6,
  AAPCS_VFP = 7,
  X86RegCall = 8,
  IntelOclBicc = 9,
  Win64 = 10,
  /* Alias for compatibility with older versions of API. */
  X86_64Win64 = Win64,
  X86_64SysV = 11,
  X86VectorCall = 12,
  Swift = 13,
  PreserveMost = 14,
  PreserveAll = 15,
  AArch64VectorCall = 16,
  SwiftAsync = 17,
  AArch64SVEPCS = 18,

  Invalid = 100,
  Unexposed = 200
}

[CRepr, AllowDuplicates]
public enum CXCursorKind : c_int
{
	/**
	 * A declaration whose specific kind is not exposed via this
	 * interface.
	 *
	 * Unexposed declarations have the same operations as any other kind
	 * of declaration; one can extract their location information,
	 * spelling, find their definitions, etc. However, the specific kind
	 * of the declaration is not reported.
	 */
	UnexposedDecl = 1,
	/** A C or C++ struct. */
	StructDecl = 2,
	/** A C or C++ union. */
	UnionDecl = 3,
	/** A C++ class. */
	ClassDecl = 4,
	/** An enumeration. */
	EnumDecl = 5,
	/**
	 * A field (in C) or non-static data member (in C++) in a
	 * struct, union, or C++ class.
	 */
	FieldDecl = 6,
	/** An enumerator constant. */
	EnumConstantDecl = 7,
	/** A function. */
	FunctionDecl = 8,
	/** A variable. */
	VarDecl = 9,
	/** A function or method parameter. */
	ParmDecl = 10,
	/** An Objective-C \@interface. */
	ObjCInterfaceDecl = 11,
	/** An Objective-C \@interface for a category. */
	ObjCCategoryDecl = 12,
	/** An Objective-C \@protocol declaration. */
	ObjCProtocolDecl = 13,
	/** An Objective-C \@property declaration. */
	ObjCPropertyDecl = 14,
	/** An Objective-C instance variable. */
	ObjCIvarDecl = 15,
	/** An Objective-C instance method. */
	ObjCInstanceMethodDecl = 16,
	/** An Objective-C class method. */
	ObjCClassMethodDecl = 17,
	/** An Objective-C \@implementation. */
	ObjCImplementationDecl = 18,
	/** An Objective-C \@implementation for a category. */
	ObjCCategoryImplDecl = 19,
	/** A typedef. */
	TypedefDecl = 20,
	/** A C++ class method. */
	CXXMethod = 21,
	/** A C++ namespace. */
	Namespace = 22,
	/** A linkage specification, e.g. 'extern "C"'. */
	LinkageSpec = 23,
	/** A C++ constructor. */
	Constructor = 24,
	/** A C++ destructor. */
	Destructor = 25,
	/** A C++ conversion function. */
	ConversionFunction = 26,
	/** A C++ template type parameter. */
	TemplateTypeParameter = 27,
	/** A C++ non-type template parameter. */
	NonTypeTemplateParameter = 28,
	/** A C++ template template parameter. */
	TemplateTemplateParameter = 29,
	/** A C++ function template. */
	FunctionTemplate = 30,
	/** A C++ class template. */
	ClassTemplate = 31,
	/** A C++ class template partial specialization. */
	ClassTemplatePartialSpecialization = 32,
	/** A C++ namespace alias declaration. */
	NamespaceAlias = 33,
	/** A C++ using directive. */
	UsingDirective = 34,
	/** A C++ using declaration. */
	UsingDeclaration = 35,
	/** A C++ alias declaration */
	TypeAliasDecl = 36,
	/** An Objective-C \@synthesize definition. */
	ObjCSynthesizeDecl = 37,
	/** An Objective-C \@dynamic definition. */
	ObjCDynamicDecl = 38,
	/** An access specifier. */
	CXXAccessSpecifier = 39,

	FirstDecl = UnexposedDecl,
	LastDecl = CXXAccessSpecifier,

	/* References */
	FirstRef = 40, /* Decl references */
	ObjCSuperClassRef = 40,
	ObjCProtocolRef = 41,
	ObjCClassRef = 42,
	/**
	 * A reference to a type declaration.
	 *
	 * A type reference occurs anywhere where a type is named but not
	 * declared. For example, given:
	 *
	 * \code
	 * typedef unsigned size_type;
	 * size_type size;
	 * \endcode
	 *
	 * The typedef is a declaration of size_type (TypedefDecl),
	 * while the type of the variable "size" is referenced. The cursor
	 * referenced by the type of size is the typedef for size_type.
	 */
	TypeRef = 43,
	CXXBaseSpecifier = 44,
	/**
	 * A reference to a class template, function template, template
	 * template parameter, or class template partial specialization.
	 */
	TemplateRef = 45,
	/**
	 * A reference to a namespace or namespace alias.
	 */
	NamespaceRef = 46,
	/**
	 * A reference to a member of a struct, union, or class that occurs in
	 * some non-expression context, e.g., a designated initializer.
	 */
	MemberRef = 47,
	/**
	 * A reference to a labeled statement.
	 *
	 * This cursor kind is used to describe the jump to "start_over" in the
	 * goto statement in the following example:
	 *
	 * \code
	 *   start_over:
	 *     ++counter;
	 *
	 *     goto start_over;
	 * \endcode
	 *
	 * A label reference cursor refers to a label statement.
	 */
	LabelRef = 48,

	/**
	 * A reference to a set of overloaded functions or function templates
	 * that has not yet been resolved to a specific function or function template.
	 *
	 * An overloaded declaration reference cursor occurs in C++ templates where
	 * a dependent name refers to a function. For example:
	 *
	 * \code
	 * template<typename T> void swap(T&, T&);
	 *
	 * struct X { ... };
	 * void swap(X&, X&);
	 *
	 * template<typename T>
	 * void reverse(T* first, T* last) {
	 *   while (first < last - 1) {
	 *     swap(*first, *--last);
	 *     ++first;
	 *   }
	 * }
	 *
	 * struct Y { };
	 * void swap(Y&, Y&);
	 * \endcode
	 *
	 * Here, the identifier "swap" is associated with an overloaded declaration
	 * reference. In the template definition, "swap" refers to either of the two
	 * "swap" functions declared above, so both results will be available. At
	 * instantiation time, "swap" may also refer to other functions found via
	 * argument-dependent lookup (e.g., the "swap" function at the end of the
	 * example).
	 *
	 * The functions \c clang_getNumOverloadedDecls() and
	 * \c clang_getOverloadedDecl() can be used to retrieve the definitions
	 * referenced by this cursor.
	 */
	OverloadedDeclRef = 49,

	/**
	 * A reference to a variable that occurs in some non-expression
	 * context, e.g., a C++ lambda capture list.
	 */
	VariableRef = 50,

	LastRef = VariableRef,

	/* Error conditions */
	FirstInvalid = 70,
	InvalidFile = 70,
	NoDeclFound = 71,
	NotImplemented = 72,
	InvalidCode = 73,LastInvalid = InvalidCode,

	/* Expressions */
	FirstExpr = 100,

	/**
	 * An expression whose specific kind is not exposed via this
	 * interface.
	 *
	 * Unexposed expressions have the same operations as any other kind
	 * of expression; one can extract their location information,
	 * spelling, children, etc. However, the specific kind of the
	 * expression is not reported.
	 */
	UnexposedExpr = 100,

	/**
	 * An expression that refers to some value declaration, such
	 * as a function, variable, or enumerator.
	 */
	DeclRefExpr = 101,

	/**
	 * An expression that refers to a member of a struct, union,
	 * class, Objective-C class, etc.
	 */
	MemberRefExpr = 102,

	/** An expression that calls a function. */
	CallExpr = 103,

	/** An expression that sends a message to an Objective-C
	 object or class. */
	ObjCMessageExpr = 104,

	/** An expression that represents a block literal. */
	BlockExpr = 105,

	/** An integer literal.
	 */
	IntegerLiteral = 106,

	/** A floating point number literal.
	 */
	FloatingLiteral = 107,

	/** An imaginary number literal.
	 */
	ImaginaryLiteral = 108,

	/** A string literal.
	 */
	StringLiteral = 109,

	/** A character literal.
	 */
	CharacterLiteral = 110,

	/** A parenthesized expression, e.g. "(1)".
	 *
	 * This AST node is only formed if full location information is requested.
	 */
	ParenExpr = 111,

	/** This represents the unary-expression's (except sizeof and
	 * alignof).
	 */
	UnaryOperator = 112,

	/** [C99 6.5.2.1] Array Subscripting.
	 */
	ArraySubscriptExpr = 113,

	/** A builtin binary operation expression such as "x + y" or
	 * "x <= y".
	 */
	BinaryOperator = 114,

	/** Compound assignment such as "+=".
	 */
	CompoundAssignOperator = 115,

	/** The ?: ternary operator.
	 */
	ConditionalOperator = 116,

	/** An explicit cast in C (C99 6.5.4) or a C-style cast in C++
	 * (C++ [expr.cast]), which uses the syntax (Type)expr.
	 *
	 * For example: (int)f.
	 */
	CStyleCastExpr = 117,

	/** [C99 6.5.2.5]
	 */
	CompoundLiteralExpr = 118,

	/** Describes an C or C++ initializer list.
	 */
	InitListExpr = 119,

	/** The GNU address of label extension, representing &&label.
	 */
	AddrLabelExpr = 120,

	/** This is the GNU Statement Expression extension: ({int X=4; X;})
	 */
	StmtExpr = 121,

	/** Represents a C11 generic selection.
	 */
	GenericSelectionExpr = 122,

	/** Implements the GNU __null extension, which is a name for a null
	 * pointer constant that has integral type (e.g., int or long) and is the same
	 * size and alignment as a pointer.
	 *
	 * The __null extension is typically only used by system headers, which define
	 * NULL as __null in C++ rather than using 0 (which is an integer that may not
	 * match the size of a pointer).
	 */
	GNUNullExpr = 123,

	/** C++'s static_cast<> expression.
	 */
	CXXStaticCastExpr = 124,

	/** C++'s dynamic_cast<> expression.
	 */
	CXXDynamicCastExpr = 125,

	/** C++'s reinterpret_cast<> expression.
	 */
	CXXReinterpretCastExpr = 126,

	/** C++'s const_cast<> expression.
	 */
	CXXConstCastExpr = 127,

	/** Represents an explicit C++ type conversion that uses "functional"
	 * notion (C++ [expr.type.conv]).
	 *
	 * Example:
	 * \code
	 *   x = int(0.5);
	 * \endcode
	 */
	CXXFunctionalCastExpr = 128,

	/** A C++ typeid expression (C++ [expr.typeid]).
	 */
	CXXTypeidExpr = 129,

	/** [C++ 2.13.5] C++ Boolean Literal.
	 */
	CXXBoolLiteralExpr = 130,

	/** [C++0x 2.14.7] C++ Pointer Literal.
	 */
	CXXNullPtrLiteralExpr = 131,

	/** Represents the "this" expression in C++
	 */
	CXXThisExpr = 132,

	/** [C++ 15] C++ Throw Expression.
	 *
	 * This handles 'throw' and 'throw' assignment-expression. When
	 * assignment-expression isn't present, Op will be null.
	 */
	CXXThrowExpr = 133,

	/** A new expression for memory allocation and constructor calls, e.g:
	 * "new CXXNewExpr(foo)".
	 */
	CXXNewExpr = 134,

	/** A delete expression for memory deallocation and destructor calls,
	 * e.g. "delete[] pArray".
	 */
	CXXDeleteExpr = 135,

	/** A unary expression. (noexcept, sizeof, or other traits)
	 */
	UnaryExpr = 136,

	/** An Objective-C string literal i.e. @"foo".
	 */
	ObjCStringLiteral = 137,

	/** An Objective-C \@encode expression.
	 */
	ObjCEncodeExpr = 138,

	/** An Objective-C \@selector expression.
	 */
	ObjCSelectorExpr = 139,

	/** An Objective-C \@protocol expression.
	 */
	ObjCProtocolExpr = 140,

	/** An Objective-C "bridged" cast expression, which casts between
	 * Objective-C pointers and C pointers, transferring ownership in the process.
	 *
	 * \code
	 *   NSString *str = (__bridge_transfer NSString *)CFCreateString();
	 * \endcode
	 */
	ObjCBridgedCastExpr = 141,

	/** Represents a C++0x pack expansion that produces a sequence of
	 * expressions.
	 *
	 * A pack expansion expression contains a pattern (which itself is an
	 * expression) followed by an ellipsis. For example:
	 *
	 * \code
	 * template<typename F, typename ...Types>
	 * void forward(F f, Types &&...args) {
	 *  f(static_cast<Types&&>(args)...);
	 * }
	 * \endcode
	 */
	PackExpansionExpr = 142,

	/** Represents an expression that computes the length of a parameter
	 * pack.
	 *
	 * \code
	 * template<typename ...Types>
	 * struct count {
	 *   static const unsigned value = sizeof...(Types);
	 * };
	 * \endcode
	 */
	SizeOfPackExpr = 143,

	/* Represents a C++ lambda expression that produces a local function
	 * object.
	 *
	 * \code
	 * void abssort(float *x, unsigned N) {
	 *   std::sort(x, x + N,
	 *             [](float a, float b) {
	 *               return std::abs(a) < std::abs(b);
	 *             });
	 * }
	 * \endcode
	 */
	LambdaExpr = 144,

	/** Objective-c Boolean Literal.
	 */
	ObjCBoolLiteralExpr = 145,

	/** Represents the "self" expression in an Objective-C method.
	 */
	ObjCSelfExpr = 146,

	/** OpenMP 5.0 [2.1.5, Array Section].
	 */
	OMPArraySectionExpr = 147,

	/** Represents an @available(...) check.
	 */
	ObjCAvailabilityCheckExpr = 148,

	/**
	 * Fixed point literal
	 */
	FixedPointLiteral = 149,

	/** OpenMP 5.0 [2.1.4, Array Shaping].
	 */
	OMPArrayShapingExpr = 150,

	/**
	 * OpenMP 5.0 [2.1.6 Iterators]
	 */
	OMPIteratorExpr = 151,

	/** OpenCL's addrspace_cast<> expression.
	 */
	CXXAddrspaceCastExpr = 152,

	/**
	 * Expression that references a C++20 concept.
	 */
	ConceptSpecializationExpr = 153,

	/**
	 * Expression that references a C++20 concept.
	 */
	RequiresExpr = 154,

	LastExpr = RequiresExpr,

	/* Statements */
	FirstStmt = 200,
	/**
	 * A statement whose specific kind is not exposed via this
	 * interface.
	 *
	 * Unexposed statements have the same operations as any other kind of
	 * statement; one can extract their location information, spelling,
	 * children, etc. However, the specific kind of the statement is not
	 * reported.
	 */
	UnexposedStmt = 200,

	/** A labelled statement in a function.
	*
	 * This cursor kind is used to describe the "start_over:" label statement in
	 * the following example:
	 *
	 * \code
	 *   start_over:
	 *     ++counter;
	 * \endcode
	 *
	 */
	LabelStmt = 201,

	/** A group of statements like { stmt stmt }.
	 *
	 * This cursor kind is used to describe compound statements, e.g. function
	 * bodies.
	 */
	CompoundStmt = 202,

	/** A case statement.
	 */
	CaseStmt = 203,

	/** A default statement.
	 */
	DefaultStmt = 204,

	/** An if statement
	 */
	IfStmt = 205,

	/** A switch statement.
	 */
	SwitchStmt = 206,

	/** A while statement.
	 */
	WhileStmt = 207,

	/** A do statement.
	 */
	DoStmt = 208,

	/** A for statement.
	 */
	ForStmt = 209,

	/** A goto statement.
	 */
	GotoStmt = 210,

	/** An indirect goto statement.
	 */
	IndirectGotoStmt = 211,

	/** A continue statement.
	 */
	ContinueStmt = 212,

	/** A break statement.
	 */
	BreakStmt = 213,

	/** A return statement.
	 */
	ReturnStmt = 214,

	/** A GCC inline assembly statement extension.
	 */
	GCCAsmStmt = 215,
	AsmStmt = GCCAsmStmt,

	/** Objective-C's overall \@try-\@catch-\@finally statement.
	 */
	ObjCAtTryStmt = 216,

	/** Objective-C's \@catch statement.
	 */
	ObjCAtCatchStmt = 217,

	/** Objective-C's \@finally statement.
	 */
	ObjCAtFinallyStmt = 218,

	/** Objective-C's \@throw statement.
	 */
	ObjCAtThrowStmt = 219,

	/** Objective-C's \@synchronized statement.
	 */
	ObjCAtSynchronizedStmt = 220,

	/** Objective-C's autorelease pool statement.
	 */
	ObjCAutoreleasePoolStmt = 221,

	/** Objective-C's collection statement.
	 */
	ObjCForCollectionStmt = 222,

	/** C++'s catch statement.
	 */
	CXXCatchStmt = 223,

	/** C++'s try statement.
	 */
	CXXTryStmt = 224,

	/** C++'s for (* : *) statement.
	 */
	CXXForRangeStmt = 225,

	/** Windows Structured Exception Handling's try statement.
	 */
	SEHTryStmt = 226,

	/** Windows Structured Exception Handling's except statement.
	 */
	SEHExceptStmt = 227,

	/** Windows Structured Exception Handling's finally statement.
	 */
	SEHFinallyStmt = 228,

	/** A MS inline assembly statement extension.
	 */
	MSAsmStmt = 229,

	/** The null statement ";": C99 6.8.3p3.
	 *
	 * This cursor kind is used to describe the null statement.*/
	NullStmt = 230,

	/** Adaptor class for mixing declarations with statements and
	 * expressions.
	 */
	DeclStmt = 231,

	/** OpenMP parallel directive.
	 */
	OMPParallelDirective = 232,

	/** OpenMP SIMD directive.
	 */
	OMPSimdDirective = 233,

	/** OpenMP for directive.
	 */
	OMPForDirective = 234,

	/** OpenMP sections directive.
	 */
	OMPSectionsDirective = 235,

	/** OpenMP section directive.
	 */
	OMPSectionDirective = 236,

	/** OpenMP single directive.
	 */
	OMPSingleDirective = 237,

	/** OpenMP parallel for directive.
	 */
	OMPParallelForDirective = 238,

	/** OpenMP parallel sections directive.
	 */
	OMPParallelSectionsDirective = 239,

	/** OpenMP task directive.
	 */
	OMPTaskDirective = 240,

	/** OpenMP master directive.
	 */
	OMPMasterDirective = 241,

	/** OpenMP critical directive.
	 */
	OMPCriticalDirective = 242,

	/** OpenMP taskyield directive.
	 */
	OMPTaskyieldDirective = 243,

	/** OpenMP barrier directive.
	 */
	OMPBarrierDirective = 244,

	/** OpenMP taskwait directive.
	 */
	OMPTaskwaitDirective = 245,

	/** OpenMP flush directive.
	 */
	OMPFlushDirective = 246,

	/** Windows Structured Exception Handling's leave statement.
	 */
	SEHLeaveStmt = 247,

	/** OpenMP ordered directive.
	 */
	OMPOrderedDirective = 248,

	/** OpenMP atomic directive.
	 */
	OMPAtomicDirective = 249,

	/** OpenMP for SIMD directive.
	 */
	OMPForSimdDirective = 250,

	/** OpenMP parallel for SIMD directive.
	 */
	OMPParallelForSimdDirective = 251,

	/** OpenMP target directive.
	 */
	OMPTargetDirective = 252,

	/** OpenMP teams directive.
	 */
	OMPTeamsDirective = 253,

	/** OpenMP taskgroup directive.
	 */
	OMPTaskgroupDirective = 254,

	/** OpenMP cancellation point directive.
	 */
	OMPCancellationPointDirective = 255,

	/** OpenMP cancel directive.
	 */
	OMPCancelDirective = 256,

	/** OpenMP target data directive.
	 */
	OMPTargetDataDirective = 257,

	/** OpenMP taskloop directive.
	 */
	OMPTaskLoopDirective = 258,

	/** OpenMP taskloop simd directive.
	 */
	OMPTaskLoopSimdDirective = 259,

	/** OpenMP distribute directive.
	 */
	OMPDistributeDirective = 260,

	/** OpenMP target enter data directive.
	 */
	OMPTargetEnterDataDirective = 261,

	/** OpenMP target exit data directive.
	 */
	OMPTargetExitDataDirective = 262,

	/** OpenMP target parallel directive.
	 */
	OMPTargetParallelDirective = 263,

	/** OpenMP target parallel for directive.
	 */
	OMPTargetParallelForDirective = 264,

	/** OpenMP target update directive.
	 */
	OMPTargetUpdateDirective = 265,

	/** OpenMP distribute parallel for directive.
	 */
	OMPDistributeParallelForDirective = 266,

	/** OpenMP distribute parallel for simd directive.
	 */
	OMPDistributeParallelForSimdDirective = 267,

	/** OpenMP distribute simd directive.
	 */
	OMPDistributeSimdDirective = 268,

	/** OpenMP target parallel for simd directive.
	 */
	OMPTargetParallelForSimdDirective = 269,

	/** OpenMP target simd directive.
	 */
	OMPTargetSimdDirective = 270,

	/** OpenMP teams distribute directive.
	 */
	OMPTeamsDistributeDirective = 271,

	/** OpenMP teams distribute simd directive.
	 */
	OMPTeamsDistributeSimdDirective = 272,

	/** OpenMP teams distribute parallel for simd directive.
	 */
	OMPTeamsDistributeParallelForSimdDirective = 273,

	/** OpenMP teams distribute parallel for directive.
	 */
	OMPTeamsDistributeParallelForDirective = 274,

	/** OpenMP target teams directive.
	 */
	OMPTargetTeamsDirective = 275,

	/** OpenMP target teams distribute directive.
	 */
	OMPTargetTeamsDistributeDirective = 276,

	/** OpenMP target teams distribute parallel for directive.
	 */
	OMPTargetTeamsDistributeParallelForDirective = 277,

	/** OpenMP target teams distribute parallel for simd directive.
	 */
	OMPTargetTeamsDistributeParallelForSimdDirective = 278,

	/** OpenMP target teams distribute simd directive.
	 */
	OMPTargetTeamsDistributeSimdDirective = 279,

	/** C++2a std::bit_cast expression.
	 */
	BuiltinBitCastExpr = 280,

	/** OpenMP master taskloop directive.
	 */
	OMPMasterTaskLoopDirective = 281,

	/** OpenMP parallel master taskloop directive.
	 */
	OMPParallelMasterTaskLoopDirective = 282,

	/** OpenMP master taskloop simd directive.
	 */
	OMPMasterTaskLoopSimdDirective = 283,

	/** OpenMP parallel master taskloop simd directive.
	 */
	OMPParallelMasterTaskLoopSimdDirective = 284,

	/** OpenMP parallel master directive.
	 */
	OMPParallelMasterDirective = 285,

	/** OpenMP depobj directive.
	 */
	OMPDepobjDirective = 286,

	/** OpenMP scan directive.
	 */
	OMPScanDirective = 287,

	/** OpenMP tile directive.
	 */
	OMPTileDirective = 288,

	/** OpenMP canonical loop.
	 */
	OMPCanonicalLoop = 289,

	/** OpenMP interop directive.
	 */
	OMPInteropDirective = 290,

	/** OpenMP dispatch directive.
	*/
	OMPDispatchDirective = 291,

	/** OpenMP masked directive.
	 */
	OMPMaskedDirective = 292,

	/** OpenMP unroll directive.
	 */
	OMPUnrollDirective = 293,

	/** OpenMP metadirective directive.
	 */
	OMPMetaDirective = 294,

	/** OpenMP loop directive.
	 */
	OMPGenericLoopDirective = 295,

	/** OpenMP teams loop directive.
	 */
	OMPTeamsGenericLoopDirective = 296,

	/** OpenMP target teams loop directive.
	 */
	OMPTargetTeamsGenericLoopDirective = 297,

	/** OpenMP parallel loop directive.
	 */
	OMPParallelGenericLoopDirective = 298,

	/** OpenMP target parallel loop directive.
	 */
	OMPTargetParallelGenericLoopDirective = 299,

	/** OpenMP parallel masked directive.
	 */
	OMPParallelMaskedDirective = 300,

	/** OpenMP masked taskloop directive.
	 */
	OMPMaskedTaskLoopDirective = 301,

	/** OpenMP masked taskloop simd directive.
	 */
	OMPMaskedTaskLoopSimdDirective = 302,

	/** OpenMP parallel masked taskloop directive.
	 */
	OMPParallelMaskedTaskLoopDirective = 303,

	/** OpenMP parallel masked taskloop simd directive.
	 */
	OMPParallelMaskedTaskLoopSimdDirective = 304,

	LastStmt = OMPParallelMaskedTaskLoopSimdDirective,

	/**
	 * Cursor that represents the translation unit itself.
	 *
	 * The translation unit cursor exists primarily to act as the root
	 * cursor for traversing the contents of a translation unit.
	 */
	TranslationUnit = 350,

	/* Attributes */
	FirstAttr = 400,
	/**
	 * An attribute whose specific kind is not exposed via this
	 * interface.
	 */
	UnexposedAttr = 400,

	IBActionAttr = 401,
	IBOutletAttr = 402,
	IBOutletCollectionAttr = 403,
	CXXFinalAttr = 404,
	CXXOverrideAttr = 405,
	AnnotateAttr = 406,
	AsmLabelAttr = 407,
	PackedAttr = 408,
	PureAttr = 409,
	ConstAttr = 410,
	NoDuplicateAttr = 411,
	CUDAConstantAttr = 412,
	CUDADeviceAttr = 413,
	CUDAGlobalAttr = 414,
	CUDAHostAttr = 415,
	CUDASharedAttr = 416,
	VisibilityAttr = 417,
	DLLExport = 418,
	DLLImport = 419,
	NSReturnsRetained = 420,
	NSReturnsNotRetained = 421,
	NSReturnsAutoreleased = 422,
	NSConsumesSelf = 423,
	NSConsumed = 424,
	ObjCException = 425,
	ObjCNSObject = 426,
	ObjCIndependentClass = 427,
	ObjCPreciseLifetime = 428,
	ObjCReturnsInnerPointer = 429,
	ObjCRequiresSuper = 430,
	ObjCRootClass = 431,
	ObjCSubclassingRestricted = 432,
	ObjCExplicitProtocolImpl = 433,
	ObjCDesignatedInitializer = 434,
	ObjCRuntimeVisible = 435,
	ObjCBoxable = 436,
	FlagEnum = 437,
	ConvergentAttr = 438,
	WarnUnusedAttr = 439,
	WarnUnusedResultAttr = 440,
	AlignedAttr = 441,
	LastAttr = AlignedAttr,

	/* Preprocessing */
	PreprocessingDirective = 500,
	MacroDefinition = 501,
	MacroExpansion = 502,
	MacroInstantiation = MacroExpansion,
	InclusionDirective = 503,
	FirstPreprocessing = PreprocessingDirective,
	LastPreprocessing = InclusionDirective,

	/* Extra Declarations */
	/**
	 * A module import declaration.
	 */
	ModuleImportDecl = 600,
	TypeAliasTemplateDecl = 601,
	/**
	 * A static_assert or _Static_assert node
	 */
	StaticAssert = 602,
	/**
	 * a friend declaration.
	 */
	FriendDecl = 603,
	/**
	 * a concept declaration.
	 */
	ConceptDecl = 604,

	FirstExtraDecl = ModuleImportDecl,
	LastExtraDecl = ConceptDecl,

	/**
	 * A code completion overload candidate.
	 */
	OverloadCandidate = 700
}

[CRepr]
public enum CXTokenKind {
	/**
	* A token that contains some kind of punctuation.
	*/
	Punctuation,
	
	/**
	* A language keyword.
	*/
	Keyword,
	
	/**
	* An identifier (that is not a keyword).
	*/
	Identifier,
	
	/**
	* A numeric, string, or character literal.
	*/
	Literal,
	
	/**
	* A comment.
	*/
	Comment
}

// Documentation.bf
/* Auto generated by https://github.com/Rune-Magic/c-to-beef-binding-generator
 * DO NOT EDIT
 */

using System;
using System.Interop;

namespace LibClang;

/** A parsed comment.
 */
[CRepr] struct CXComment
{
	public void* ASTNode;
	public CXTranslationUnit TranslationUnit;
}

extension Clang
{
	/** Given a cursor that represents a documentable entity (e.g.,
	 *  declaration), return the associated parsed comment as a
	 *  @c CXComment_FullComment AST node. 
	 */
	[Import(Clang.dll), LinkName("clang_Cursor_getParsedComment")] public static extern CXComment Cursor_GetParsedComment(CXCursor C);

}

/** Describes the type of the comment AST node (@c CXComment). A comment node can be considered block content (e. g., paragraph), inline content
 *  (plain text) or neither (the root AST node).
 */
[CRepr, AllowDuplicates] enum CXCommentKind : c_int
{
	/** Null comment.  No AST node is constructed at the requested location
	 *  because there is no text or a syntax error.
	 */
	Null = 0,

	/** Plain text.  Inline content.
	 */
	Text = 1,

	/** A command with word-like arguments that is considered inline content.
	 *  For example: @c command. 
	 */
	InlineCommand = 2,

	/** HTML start tag with attributes (name-value pairs).  Considered
	 *  inline content.
	 *  For example:
	 *  
	 *  ```
	 *  <br> <br /> <a href="http://example.org/">
	 *  ```
	 *  
	 */
	HTMLStartTag = 3,

	/** HTML end tag.  Considered inline content.
	 *  For example:
	 *  
	 *  ```
	 *  </a>
	 *  ```
	 *  
	 */
	HTMLEndTag = 4,

	/** A paragraph, contains inline comment.  The paragraph itself is
	 *  block content.
	 */
	Paragraph = 5,

	/** A command that has zero or more word-like arguments (number of
	 *  word-like arguments depends on command name) and a paragraph as an
	 *  argument.  Block command is block content.
	 *  Paragraph argument is also a child of the block command.
	 *  For example: @has 0 word-like arguments and a paragraph argument. 
	 *  AST nodes of special kinds that parser knows about (e. g., @param command) have their own node kinds.
	 */
	BlockCommand = 6,

	/** A @param or  @arg command that describes the function parameter (name, passing direction, description).
	 *  For example: @param [in] ParamName description. 
	 */
	ParamCommand = 7,

	/** A @tparam command that describes a template parameter (name and description).
	 *  For example: @tparam T description. 
	 */
	TParamCommand = 8,

	/** A verbatim block command (e. g., preformatted code).  Verbatim
	 *  block has an opening and a closing command and contains multiple lines of
	 *  text (@c CXComment_VerbatimBlockLine child nodes). 
	 *  For example:
	 *  @verbatim aaa
	 *  @endverbatim 
	 */
	VerbatimBlockCommand = 9,

	/** A line of text that is contained within a
	 *  CXComment_VerbatimBlockCommand node.
	 */
	VerbatimBlockLine = 10,

	/** A verbatim line command.  Verbatim line has an opening command,
	 *  a single line of text (up to the newline after the opening command) and
	 *  has no closing command.
	 */
	VerbatimLine = 11,

	/** A full comment attached to a declaration, contains block content.
	 */
	FullComment = 12,

}

/** The most appropriate rendering mode for an inline command, chosen on
 *  command semantics in Doxygen.
 */
[CRepr, AllowDuplicates] enum CXCommentInlineCommandRenderKind : c_int
{
	/** Command argument should be rendered in a normal font.
	 */
	Normal = 0,

	/** Command argument should be rendered in a bold font.
	 */
	Bold = 1,

	/** Command argument should be rendered in a monospaced font.
	 */
	Monospaced = 2,

	/** Command argument should be rendered emphasized (typically italic
	 *  font).
	 */
	Emphasized = 3,

	/** Command argument should not be rendered (since it only defines an anchor).
	 */
	Anchor = 4,

}

/** Describes parameter passing direction for @param or  @arg command. 
 */
[CRepr, AllowDuplicates] enum CXCommentParamPassDirection : c_int
{
	/** The parameter is an input parameter.
	 */
	In = 0,

	/** The parameter is an output parameter.
	 */
	Out = 1,

	/** The parameter is an input and output parameter.
	 */
	InOut = 2,

}

extension Clang
{
	/** 
	 *  @param Comment AST node of any kind.
	 *  
	 *  @returns the type of the AST node.
	 */
	[Import(Clang.dll), LinkName("clang_Comment_getKind")] public static extern CXCommentKind Comment_GetKind(CXComment Comment);

	/** 
	 *  @param Comment AST node of any kind.
	 *  
	 *  @returns number of children of the AST node.
	 */
	[Import(Clang.dll), LinkName("clang_Comment_getNumChildren")] public static extern c_uint Comment_GetNumChildren(CXComment Comment);

	/** 
	 *  @param Comment AST node of any kind.
	 *  
	 *  @param ChildIdx child index (zero-based).
	 *  
	 *  @returns the specified child of the AST node.
	 */
	[Import(Clang.dll), LinkName("clang_Comment_getChild")] public static extern CXComment Comment_GetChild(CXComment Comment, c_uint ChildIdx);

	/** A @c CXComment_Paragraph node is considered whitespace if it contains only @c CXComment_Text nodes that are empty or whitespace. 
	 *  Other AST nodes (except @c CXComment_Paragraph and  @c CXComment_Text) are never considered whitespace.
	 *  
	 *  @returns non-zero if @c Comment is whitespace. 
	 */
	[Import(Clang.dll), LinkName("clang_Comment_isWhitespace")] public static extern c_uint Comment_IsWhitespace(CXComment Comment);

	/** 
	 *  @returns non-zero if @c Comment is inline content and has a newline immediately following it in the comment text.  Newlines between paragraphs
	 *  do not count.
	 */
	[Import(Clang.dll), LinkName("clang_InlineContentComment_hasTrailingNewline")] public static extern c_uint InlineContentComment_HasTrailingNewline(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_Text AST node. 
	 *  
	 *  @returns text contained in the AST node.
	 */
	[Import(Clang.dll), LinkName("clang_TextComment_getText")] public static extern CXString TextComment_GetText(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_InlineCommand AST node. 
	 *  
	 *  @returns name of the inline command.
	 */
	[Import(Clang.dll), LinkName("clang_InlineCommandComment_getCommandName")] public static extern CXString InlineCommandComment_GetCommandName(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_InlineCommand AST node. 
	 *  
	 *  @returns the most appropriate rendering mode, chosen on command
	 *  semantics in Doxygen.
	 */
	[Import(Clang.dll), LinkName("clang_InlineCommandComment_getRenderKind")] public static extern CXCommentInlineCommandRenderKind InlineCommandComment_GetRenderKind(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_InlineCommand AST node. 
	 *  
	 *  @returns number of command arguments.
	 */
	[Import(Clang.dll), LinkName("clang_InlineCommandComment_getNumArgs")] public static extern c_uint InlineCommandComment_GetNumArgs(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_InlineCommand AST node. 
	 *  
	 *  @param ArgIdx argument index (zero-based).
	 *  
	 *  @returns text of the specified argument.
	 */
	[Import(Clang.dll), LinkName("clang_InlineCommandComment_getArgText")] public static extern CXString InlineCommandComment_GetArgText(CXComment Comment, c_uint ArgIdx);

	/** 
	 *  @param Comment a @c CXComment_HTMLStartTag or  @c CXComment_HTMLEndTag AST node.
	 *  
	 *  @returns HTML tag name.
	 */
	[Import(Clang.dll), LinkName("clang_HTMLTagComment_getTagName")] public static extern CXString HTMLTagComment_GetTagName(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_HTMLStartTag AST node. 
	 *  
	 *  @returns non-zero if tag is self-closing (for example, 
	 *  <
	 *  br /
	 *  >
	 *  ).
	 */
	[Import(Clang.dll), LinkName("clang_HTMLStartTagComment_isSelfClosing")] public static extern c_uint HTMLStartTagComment_IsSelfClosing(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_HTMLStartTag AST node. 
	 *  
	 *  @returns number of attributes (name-value pairs) attached to the start tag.
	 */
	[Import(Clang.dll), LinkName("clang_HTMLStartTag_getNumAttrs")] public static extern c_uint HTMLStartTag_GetNumAttrs(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_HTMLStartTag AST node. 
	 *  
	 *  @param AttrIdx attribute index (zero-based).
	 *  
	 *  @returns name of the specified attribute.
	 */
	[Import(Clang.dll), LinkName("clang_HTMLStartTag_getAttrName")] public static extern CXString HTMLStartTag_GetAttrName(CXComment Comment, c_uint AttrIdx);

	/** 
	 *  @param Comment a @c CXComment_HTMLStartTag AST node. 
	 *  
	 *  @param AttrIdx attribute index (zero-based).
	 *  
	 *  @returns value of the specified attribute.
	 */
	[Import(Clang.dll), LinkName("clang_HTMLStartTag_getAttrValue")] public static extern CXString HTMLStartTag_GetAttrValue(CXComment Comment, c_uint AttrIdx);

	/** 
	 *  @param Comment a @c CXComment_BlockCommand AST node. 
	 *  
	 *  @returns name of the block command.
	 */
	[Import(Clang.dll), LinkName("clang_BlockCommandComment_getCommandName")] public static extern CXString BlockCommandComment_GetCommandName(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_BlockCommand AST node. 
	 *  
	 *  @returns number of word-like arguments.
	 */
	[Import(Clang.dll), LinkName("clang_BlockCommandComment_getNumArgs")] public static extern c_uint BlockCommandComment_GetNumArgs(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_BlockCommand AST node. 
	 *  
	 *  @param ArgIdx argument index (zero-based).
	 *  
	 *  @returns text of the specified word-like argument.
	 */
	[Import(Clang.dll), LinkName("clang_BlockCommandComment_getArgText")] public static extern CXString BlockCommandComment_GetArgText(CXComment Comment, c_uint ArgIdx);

	/** 
	 *  @param Comment a @c CXComment_BlockCommand or @c CXComment_VerbatimBlockCommand AST node. 
	 *  
	 *  @returns paragraph argument of the block command.
	 */
	[Import(Clang.dll), LinkName("clang_BlockCommandComment_getParagraph")] public static extern CXComment BlockCommandComment_GetParagraph(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_ParamCommand AST node. 
	 *  
	 *  @returns parameter name.
	 */
	[Import(Clang.dll), LinkName("clang_ParamCommandComment_getParamName")] public static extern CXString ParamCommandComment_GetParamName(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_ParamCommand AST node. 
	 *  
	 *  @returns non-zero if the parameter that this AST node represents was found
	 *  in the function prototype and @c clang_ParamCommandComment_getParamIndex function will return a meaningful value. 
	 */
	[Import(Clang.dll), LinkName("clang_ParamCommandComment_isParamIndexValid")] public static extern c_uint ParamCommandComment_IsParamIndexValid(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_ParamCommand AST node. 
	 *  
	 *  @returns zero-based parameter index in function prototype.
	 */
	[Import(Clang.dll), LinkName("clang_ParamCommandComment_getParamIndex")] public static extern c_uint ParamCommandComment_GetParamIndex(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_ParamCommand AST node. 
	 *  
	 *  @returns non-zero if parameter passing direction was specified explicitly in
	 *  the comment.
	 */
	[Import(Clang.dll), LinkName("clang_ParamCommandComment_isDirectionExplicit")] public static extern c_uint ParamCommandComment_IsDirectionExplicit(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_ParamCommand AST node. 
	 *  
	 *  @returns parameter passing direction.
	 */
	[Import(Clang.dll), LinkName("clang_ParamCommandComment_getDirection")] public static extern CXCommentParamPassDirection ParamCommandComment_GetDirection(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_TParamCommand AST node. 
	 *  
	 *  @returns template parameter name.
	 */
	[Import(Clang.dll), LinkName("clang_TParamCommandComment_getParamName")] public static extern CXString TParamCommandComment_GetParamName(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_TParamCommand AST node. 
	 *  
	 *  @returns non-zero if the parameter that this AST node represents was found
	 *  in the template parameter list and
	 *  @c clang_TParamCommandComment_getDepth and @c clang_TParamCommandComment_getIndex functions will return a meaningful value.
	 */
	[Import(Clang.dll), LinkName("clang_TParamCommandComment_isParamPositionValid")] public static extern c_uint TParamCommandComment_IsParamPositionValid(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_TParamCommand AST node. 
	 *  
	 *  @returns zero-based nesting depth of this parameter in the template parameter list.
	 *  For example,
	 *  
	 *  ```
	 *    template<typename C, template<typename T> class TT>
	 *    void test(TT<int> aaa);
	 *  ```
	 *  for C and TT nesting depth is 0,
	 *  for T nesting depth is 1.
	 */
	[Import(Clang.dll), LinkName("clang_TParamCommandComment_getDepth")] public static extern c_uint TParamCommandComment_GetDepth(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_TParamCommand AST node. 
	 *  
	 *  @returns zero-based parameter index in the template parameter list at a
	 *  given nesting depth.
	 *  For example,
	 *  
	 *  ```
	 *    template<typename C, template<typename T> class TT>
	 *    void test(TT<int> aaa);
	 *  ```
	 *  for C and TT nesting depth is 0, so we can ask for index at depth 0:
	 *  at depth 0 C's index is 0, TT's index is 1.
	 *  For T nesting depth is 1, so we can ask for index at depth 0 and 1:
	 *  at depth 0 T's index is 1 (same as TT's),
	 *  at depth 1 T's index is 0.
	 */
	[Import(Clang.dll), LinkName("clang_TParamCommandComment_getIndex")] public static extern c_uint TParamCommandComment_GetIndex(CXComment Comment, c_uint Depth);

	/** 
	 *  @param Comment a @c CXComment_VerbatimBlockLine AST node. 
	 *  
	 *  @returns text contained in the AST node.
	 */
	[Import(Clang.dll), LinkName("clang_VerbatimBlockLineComment_getText")] public static extern CXString VerbatimBlockLineComment_GetText(CXComment Comment);

	/** 
	 *  @param Comment a @c CXComment_VerbatimLine AST node. 
	 *  
	 *  @returns text contained in the AST node.
	 */
	[Import(Clang.dll), LinkName("clang_VerbatimLineComment_getText")] public static extern CXString VerbatimLineComment_GetText(CXComment Comment);

	/** Convert an HTML tag AST node to string.
	 *  
	 *  @param Comment a @c CXComment_HTMLStartTag or  @c CXComment_HTMLEndTag AST node.
	 *  
	 *  @returns string containing an HTML tag.
	 */
	[Import(Clang.dll), LinkName("clang_HTMLTagComment_getAsString")] public static extern CXString HTMLTagComment_GetAsString(CXComment Comment);

	/** Convert a given full parsed comment to an HTML fragment.
	 *  Specific details of HTML layout are subject to change.  Don't try to parse
	 *  this HTML back into an AST, use other APIs instead.
	 *  Currently the following CSS classes are used:
	 *  
	 *  @li "para-brief" for 
	 *   and equivalent commands;
	 *  
	 *  @li "para-returns" for @returns paragraph and equivalent commands; 
	 *  @li "word-returns" for the "Returns" word in @returns paragraph. 
	 *  Function argument documentation is rendered as a 
	 *  <
	 *  dl
	 *  >
	 *  list with arguments
	 *  sorted in function prototype order.  CSS classes used:
	 *  
	 *  @li "param-name-index-NUMBER" for parameter name (
	 *  <
	 *  dt
	 *  >
	 *  );
	 *  
	 *  @li "param-descr-index-NUMBER" for parameter description (
	 *  <
	 *  dd
	 *  >
	 *  );
	 *  
	 *  @li "param-name-index-invalid" and "param-descr-index-invalid" are used if
	 *  parameter index is invalid.
	 *  Template parameter documentation is rendered as a 
	 *  <
	 *  dl
	 *  >
	 *  list with
	 *  parameters sorted in template parameter list order.  CSS classes used:
	 *  
	 *  @li "tparam-name-index-NUMBER" for parameter name (
	 *  <
	 *  dt
	 *  >
	 *  );
	 *  
	 *  @li "tparam-descr-index-NUMBER" for parameter description (
	 *  <
	 *  dd
	 *  >
	 *  );
	 *  
	 *  @li "tparam-name-index-other" and "tparam-descr-index-other" are used for
	 *  names inside template template parameters;
	 *  
	 *  @li "tparam-name-index-invalid" and "tparam-descr-index-invalid" are used if
	 *  parameter position is invalid.
	 *  
	 *  @param Comment a @c CXComment_FullComment AST node. 
	 *  
	 *  @returns string containing an HTML fragment.
	 */
	[Import(Clang.dll), LinkName("clang_FullComment_getAsHTML")] public static extern CXString FullComment_GetAsHTML(CXComment Comment);

	/** Convert a given full parsed comment to an XML document.
	 *  A Relax NG schema for the XML can be found in comment-xml-schema.rng file
	 *  inside clang source tree.
	 *  
	 *  @param Comment a @c CXComment_FullComment AST node. 
	 *  
	 *  @returns string containing an XML document.
	 */
	[Import(Clang.dll), LinkName("clang_FullComment_getAsXML")] public static extern CXString FullComment_GetAsXML(CXComment Comment);

}

/** CXAPISet is an opaque type that represents a data structure containing all
 *  the API information for a given translation unit. This can be used for a
 *  single symbol symbol graph for a given symbol.
 */
class CXAPISet { private this() {} }

extension Clang
{
	/** Traverses the translation unit to create a @c CXAPISet. 
	 *   
	 *  @param tu is the @c CXTranslationUnit to build the  @c CXAPISet for. 
	 *  
	 *  @param out_api is a pointer to the output of this function. It is needs to be
	 *  disposed of by calling clang_disposeAPISet.
	 *  
	 *  @returns Error code indicating success or failure of the APISet creation.
	 */
	[Import(Clang.dll), LinkName("clang_createAPISet")] public static extern CXErrorCode CreateAPISet(CXTranslationUnit tu, CXAPISet* out_api);

	/** Dispose of an APISet.
	 *  The provided @c CXAPISet can not be used after this function is called. 
	 */
	[Import(Clang.dll), LinkName("clang_disposeAPISet")] public static extern void DisposeAPISet(CXAPISet api);

	/** Generate a single symbol symbol graph for the given USR. Returns a null
	 *  string if the associated symbol can not be found in the provided @c CXAPISet. 
	 *  The output contains the symbol graph as well as some additional information about related symbols.
	 *  
	 *  @param usr is a string containing the USR of the symbol to generate the
	 *  symbol graph for.
	 *  
	 *  @param api the @c CXAPISet to look for the symbol in. 
	 *  
	 *  @returns a string containing the serialized symbol graph representation for
	 *  the symbol being queried or a null string if it can not be found in the
	 *  APISet.
	 */
	[Import(Clang.dll), LinkName("clang_getSymbolGraphForUSR")] public static extern CXString GetSymbolGraphForUSR(c_char* usr, CXAPISet api);

	/** Generate a single symbol symbol graph for the declaration at the given
	 *  cursor. Returns a null string if the AST node for the cursor isn't a
	 *  declaration.
	 *  The output contains the symbol graph as well as some additional information
	 *  about related symbols.
	 *  
	 *  @param cursor the declaration for which to generate the single symbol symbol
	 *  graph.
	 *  
	 *  @returns a string containing the serialized symbol graph representation for
	 *  the symbol being queried or a null string if it can not be found in the
	 *  APISet.
	 */
	[Import(Clang.dll), LinkName("clang_getSymbolGraphForCursor")] public static extern CXString GetSymbolGraphForCursor(CXCursor cursor);

}

#endif