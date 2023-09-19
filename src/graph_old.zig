// generics
const std = @import("std");
const c = @import("c.zig");
const TT = @import("TT.zig").TT;

// aliases
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;

// NOT sure if this is supposed to be in here?
const GPA = @import("adhoc/memory_allocations.zig").GPA;

const OldGraph = struct {
    name: ?[]const u8,
    allocator: ?Allocator,
    elementsArray: error{OutOfMemory}!?[]*OldGraph.Element,
    elementsSlice: ?[]*OldGraph.Element,
    elementsCount: ?usize,
    elementsCapacity: ?usize,

    const Element = union(enum) {
        Node: Node,
        Edge: Edge,

        // many in, mayny out
        const Node = struct {
            props: ?Props = null,
            inEdges: ?[]*Edge = null,
            outEdges: ?[]*Edge = null,

            const Props = struct {
                name: ?[]u8 = null,
            };

            fn edgeTo(self: *Node, target: *?Node, edgeName: ?[]const u8) void {

                // create edge
                const edge = OldGraph.newGraph.Edge(.{
                    .name = edgeName,
                    .start = self,
                    .end = target,
                });

                // add edge to self
                if (self.outEdges) |outEdges| {
                    outEdges.append(edge);
                } else {
                    self.outEdges = []*Edge{edge};
                }

                // add edge to targetNode
                if (target.inEdges) |inEdges| {
                    inEdges.append(edge);
                } else {
                    target.inEdges = []*Edge{edge};
                }
            }
        };

        // from 1 node to 1 other node
        const Edge = struct {
            props: ?Props = null,
            directionality: ?Directionality = null,
            start: ?*Node = null,
            end: ?*Node = null,

            const Props = struct {
                name: ?[]u8 = null,
            };

            const Directionality = enum(u8) {
                Undirected = 0,
                Directed = 1,
                Bidirectional = 2,
            };
        };
    };

    // const arrayTracker = [64]*Graph.Element;

    // const _self = @This();

    // fail silently
    fn initGraph(self: *OldGraph, initialAllocationCount: ?usize) OldGraph {
        const initialCount = initialAllocationCount orelse 2; // 2 is the minimum & used for testing
        self.allocator = GPA.getAllocator(); //catch unreachable;
        const _alloc = self.allocator orelse unreachable;

        if (_alloc.alloc(*OldGraph.Element, initialCount)) |array| {
            self.elementsArray = array;
        } else |err| {
            std.debug.print("Failed to allocate: {}\n", .{err});
        }

        // self.elementsArray = _alloc.alloc(*Graph.Element, initialCount) catch unreachable;
        // if (self.elementsArray) |slice| {
        //     self.elementsSlice = slice;
        //     self.elementsCapacity = self.elementsSlice.?.len;
        //     self.elementsCount = 0;
        // } else |err| {
        //     std.debug.print("[GRAPH] ✘ Failed to allocate memory for Graph.elementList.\n{}\n", .{err});
        // }

        return self.*;
    }

    fn deinitGraph(self: *OldGraph) OldGraph {
        if (self.allocator) |_allocator| {
            std.debug.print("[GRAPH] ✅ Graph.allocator exists.\n", .{});
            if (self.elementsSlice) |_elements| {
                std.debug.print("[GRAPH] ✅ Graph.allocator exists.\n", .{});

                // free array elements 1 by 1
                if (_elements.len > 0) {
                    std.debug.print("[GRAPH] ✅ Freeing Graph.elements 1 by 1.\n", .{});
                    for (_elements) |element| {
                        _allocator.free(element);
                        self.elementsCount = self.elementsCount.? - 1;
                    }
                } else {
                    std.debug.print("[GRAPH] ✘ No Graph.elements to free 1 by 1.\n", .{});
                }

                // double check, then free array
                if (_elements.len > 0) {
                    std.debug.print("[GRAPH] ✅ Freeing Graph.elements list.\n", .{});
                    _allocator.free(self.elementsArray);
                    self.elementsSlice = null;
                    self.elementsCount = null;
                } else {
                    std.debug.print("[GRAPH] ✘ Can't free Graph.elements list, it's not empty.\n", .{});
                }
            } else {
                std.debug.print("[GRAPH] ✘ No Graph.elements list to free.\n", .{});
            }
        } else {
            std.debug.print("[GRAPH] ✘ Can't deinitGraph(), no allocator.\n", .{});
        }

        if (self.elementsCount.? > 0) { // if there are elements

            // Iterate over all elements and free them
            // for (self.elementList.?) |element| {
            //     self.allocator.?.free(element);
            // }

            // Free the elementList array
            if (self.elementsCount.? == 0) { // double check
                self.allocator.?.free(self.elementsArray);
                self.elementsSlice = null;
                self.elementsCount = null;
            } else {
                std.debug.print("[GRAPH] ✘ Can't free Graph.elementList, it's not empty.\n", .{});
            }
        }
        return self.*;
    }

    fn emptyGraph() OldGraph {
        std.debug.print("[GRAPH] ✅ Created empty Graph.\n", .{});
        return OldGraph{
            .name = null,
            .allocator = null,
            .elementsArray = undefined,
            .elementsSlice = null,
            .elementsCount = null,
            .elementsCapacity = null,
        };
    }

    fn newGraph(graphName: []const u8) OldGraph {
        std.debug.print("[GRAPH] ✅ Creating new Graph '{s}'\n", .{graphName});
        var graph = OldGraph.emptyGraph();
        graph.name = graphName;
        return graph;
    }

    fn NewEdge(edgeName: []const u8) OldGraph.Element.Edge {
        std.debug.print("[GRAPH] ✅ Creating new Edge   '{s}'\n", .{edgeName});
        return OldGraph.Element.Edge{
            .name = edgeName,
        };
    }

    fn NewNode(nodeName: []const u8) OldGraph.Element.Node {
        std.debug.print("[GRAPH] ✅ Creating new Node   '{s}'\n", .{nodeName});
        return OldGraph.Element.Node{
            .name = nodeName,
        };
    }
};

test "Old Graph" {
    var g = OldGraph.newGraph("graph");
    // _ = g;
    g = g.initGraph(null);
    // g = g.deinitGraph();

}
