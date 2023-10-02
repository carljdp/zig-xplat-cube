pub usingnamespace @cImport({
    // I dont yet know what these are for .. ?
    @cInclude("stdio.h");
    @cInclude("math.h");
    @cInclude("time.h");

    // These I know
    @cDefine("GLFW_INCLUDE_NONE", "");
    // then doesn't matter what order we include these
    @cInclude("glad/gl.h");
    @cInclude("GLFW/glfw3.h");

    // I dont yet know what these are for .. ?
    @cDefine("STBI_ONLY_PNG", "");
    @cDefine("STBI_NO_STDIO", "");
    // @cInclude("stb_image.h");
});
