namespace LibClang;

static class Clang
{
	protected const let dll = "libclang" +
#if BF_PLATFORM_WINDOWS
		".dll";
#elif BF_PLATFORM_MACOS
		".dylib";
#else
		".so";
#endif

	protected typealias time_t = uint32;
}
