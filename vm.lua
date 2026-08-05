-- 🦤 DodoVM: Extinct, but somehow still running

local DodoVM = {}

function DodoVM.new(bytecode)
    local vm = {}

    -- Registers
    vm.D0 = 0          -- Dodo Accumulator
    vm.PC = 1          -- Perch Counter (Lua arrays start at 1)
    vm.SP = 256        -- Stumble Pointer (top of RAM)
    vm.F = { E = false, T = false, L = false } -- Fossil Flags

    -- Memory (256 bytes)
    vm.ram = {}
    for i = 1, 256 do
        vm.ram[i] = 0
    end

    -- Config / chaos knobs
    vm.EXTINCT_LEVEL = 100
    vm.SOUND_GLITCH = 5

    vm.bytecode = bytecode or {}

    -- Helpers
    local function read(addr)
        if addr < 1 or addr > 256 then
            vm.F.L = true
            if vm.EXTINCT_LEVEL > 200 then
                vm.F.E = true
            end
            return 0
        end
        return vm.ram[addr]
    end

    local function write(addr, value)
        if addr < 1 or addr > 256 then
            vm.F.L = true
            if vm.EXTINCT_LEVEL > 200 then
                vm.F.E = true
            end
            return
        end
        vm.ram[addr] = value & 0xFF
    end

    -- Execution
    function vm:step()
        if self.F.E then return false end
        local opcode = self.bytecode[self.PC]
        if not opcode then
            self.F.E = true
            return false
        end

        -- advance PC by default
        self.PC = self.PC + 1

        if opcode == 0x00 then
            -- NAP: do nothing

        elseif opcode == 0x01 then
            -- BONK imm: D0 += imm
            local imm = self.bytecode[self.PC] or 0
            self.PC = self.PC + 1
            self.D0 = (self.D0 + imm) & 0xFF

        elseif opcode == 0x02 then
            -- WOBBLE addr: D0 = ram[addr] ± 1
            local addr = self.bytecode[self.PC] or 1
            self.PC = self.PC + 1
            local val = read(addr)
            local drift = (math.random(0, 2) - 1) -- -1, 0, +1
            self.D0 = (val + drift) & 0xFF

        elseif opcode == 0x03 then
            -- DROP addr: ram[addr] = D0, set T flag
            local addr = self.bytecode[self.PC] or 1
            self.PC = self.PC + 1
            write(addr, self.D0)
            self.F.T = true

        elseif opcode == 0x04 then
            -- HOP rel: PC += rel (+ possible chaos)
            local rel = self.bytecode[self.PC] or 0
            self.PC = self.PC + 1
            if self.F.L then
                rel = rel + 1 -- overshoot if lost
            end
            self.PC = self.PC + rel

        elseif opcode == 0x05 then
            -- SQUAWK id: play sound (simulated)
            local id = self.bytecode[self.PC] or 0
            self.PC = self.PC + 1
            print(("🦤 SQUAWK sound %d (glitch %d)"):format(id, self.SOUND_GLITCH))

        elseif opcode == 0x06 then
            -- FOSSIL: halt
            self.F.E = true
            print("🦤 DodoVM went EXTINCT.")
            return false

        elseif opcode == 0x07 then
            -- PECK addr: ++ram[addr]
            local addr = self.bytecode[self.PC] or 1
            self.PC = self.PC + 1
            local val = read(addr)
            write(addr, (val + 1) & 0xFF)

        elseif opcode == 0x08 then
            -- TRIP cond, rel: if T then jump badly
            local cond = self.bytecode[self.PC] or 0
            local rel = self.bytecode[self.PC + 1] or 0
            self.PC = self.PC + 2
            if self.F.T and cond == 1 then
                self.PC = self.PC + rel + 1 -- “bad” jump
            end

        else
            print(("🦤 Unknown opcode %02X, going fossil."):format(opcode))
            self.F.E = true
            return false
        end

        return true
    end

    function vm:run(max_steps)
        max_steps = max_steps or 1000
        local steps = 0
        while steps < max_steps and not self.F.E do
            if not self:step() then break end
            steps = steps + 1
        end
    end

    return vm
end

-- Example: tiny Dodo program
local program = {
    0x01, 10,      -- BONK 10 -> D0 = 10
    0x03, 20,      -- DROP to addr 20
    0x07, 20,      -- PECK addr 20 (now 11)
    0x05, 1,       -- SQUAWK sound 1
    0x06           -- FOSSIL (halt)
}

local vm = DodoVM.new(program)
vm:run()
print("🦤 Final D0:", vm.D0)
print("🦤 ram[20]:", vm.ram[20])
