const anyNamedStruct = union(enum) {
    inst: NamedStruct,
    ptr: *NamedStruct,

    pub fn getName(self: anyNamedStruct) []const u8 {
        return switch (self) {
            anyNamedStruct.inst => |inst| inst.name,
            anyNamedStruct.ptr => |ptr| ptr.*.name,
        };
    }
    pub fn setName(self: anyNamedStruct) @TypeOf(self) {
        switch (self) {
            anyNamedStruct.inst => |inst| {
                // inst.name = "hello"; // cant, is const!
                return inst;
            },
            anyNamedStruct.ptr => |ptr| {
                ptr.*.name = "hello";
                return ptr.*;
            },
        }
    }
    // pub fn setName(self: *NamedSt) anyNamedSt {
    //     self.*.name = "hello";
    //     return self.*;
    // }
};

const NamedStruct = struct {
    name: []const u8 = "hi",

    pub fn getName(self: *const NamedStruct) []const u8 {
        return self.name;
    }
    pub fn setName(self: *NamedStruct) NamedStruct {
        self.name = "hello";
        return self.*;
    }

    pub const Static = struct {
        pub fn getName(instOrPtr: anyNamedStruct) []const u8 {
            return instOrPtr.getName();
            // return switch (@TypeOf(instOrPtr)) {
            //     anyNamedSt.inst => |inst| inst.name,
            //     anyNamedSt.ptr => |ptr| ptr.*.name,
            // };
        }
    };
};
