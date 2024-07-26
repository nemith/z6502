pub const Memory = struct {
    read: fn(self: *Self, addr: u16) u8,
    write: fn(self: *Self, addr: u16, value: u8) void,
};

pub const Inst = struct {
    addr: fn(self, *Self) u16,
    op: fn(self: *Self) void,
    cycles: u8,
};

const InstTable = [256]Inst{
    // 0x00
    Inst{
        .addr = Self.addr_imp,
        .op = Self.addr_illegal,
    },
};

const Self = @This();

a: u8,
x: u8,
y: u8,
sp: u8,
pc: u16,

mem: Memory,

pub fn init(mem: Memory) Self {
    return Self{ .a = 0, .x = 0, .y = 0, .sp = 0, .pc = 0, .mem = mem };
}

pub fn reset(
    self: *Self,
) void {
    self.a = 0;
    self.x = 0;
    self.y = 0;
    self.sp = 0xFF;
    self.pc = self.mem.read(0xFFFC) + (self.mem.read(0xFFFD) << 8);
}

pub fn step(self: *Self) {
    const opcode = self.mem.read(self.pc);
    self.pc += 1;
}