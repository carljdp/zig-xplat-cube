//------------------------------------------------------------------------------
// Generic test helpers
// - e.g. to ensure a struct 'implements' an 'interface'

/// Assert struct has|implements init method.
pub fn expectFn_init(comptime T: type) void {
    _ = T.init; // Check for init method
}

/// Assert struct has|implements deinit method.
pub fn expectFn_deinit(comptime T: type) void {
    _ = T.deinit; // Check for deinit method
}

//------------------------------------------------------------------------------
