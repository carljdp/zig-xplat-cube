// cant use @embedFile from dir outside of src.
// no idea why, so exporting from here then.

pub const vertexShaderSource = @embedFile("shader.vert"); // returns *const [N:0]u8
pub const fragmentShaderSource = @embedFile("shader.frag"); // returns *const [N:0]u8
