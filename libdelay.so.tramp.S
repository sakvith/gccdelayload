  .data

  .globl _libdelay_so_tramp_table
  .hidden _libdelay_so_tramp_table
_libdelay_so_tramp_table:
  .zero 16

  .text

  .globl _libdelay_so_tramp_resolve
  .hidden _libdelay_so_tramp_resolve

  .globl _libdelay_so_save_regs_and_resolve
  .hidden _libdelay_so_save_regs_and_resolve
_libdelay_so_save_regs_and_resolve:
  .cfi_startproc

#define PUSH_REG(reg) pushq %reg ; .cfi_adjust_cfa_offset 8; .cfi_rel_offset reg, 0
#define POP_REG(reg) popq %reg ; .cfi_adjust_cfa_offset -8; .cfi_restore reg

  // Slow path which calls dlsym, taken only on first call.
  // We store all registers to handle arbitrary calling conventions.
  // We don't save XMM regs, hopefully compiler isn't crazy enough to use them in resolving code.
  // For Dwarf directives, read https://www.imperialviolet.org/2017/01/18/cfi.html.

  PUSH_REG(rdi)
  mov 0x10(%rsp), %rdi
  PUSH_REG(rax)
  PUSH_REG(rbx)
  PUSH_REG(rcx)
  PUSH_REG(rdx)
  PUSH_REG(rbp)
  PUSH_REG(rsi)
  PUSH_REG(r8)
  PUSH_REG(r9)
  PUSH_REG(r10)
  PUSH_REG(r11)
  PUSH_REG(r12)
  PUSH_REG(r13)
  PUSH_REG(r14)
  PUSH_REG(r15)

  call _libdelay_so_tramp_resolve  // Stack will be aligned at 16 in call

  POP_REG(r15)
  POP_REG(r14)
  POP_REG(r13)
  POP_REG(r12)
  POP_REG(r11)
  POP_REG(r10)
  POP_REG(r9)
  POP_REG(r8)
  POP_REG(rsi)
  POP_REG(rbp)
  POP_REG(rdx)
  POP_REG(rcx)
  POP_REG(rbx)
  POP_REG(rax)
  POP_REG(rdi)

  ret

  .cfi_endproc

  .globl test
  .p2align 4
test:
  .cfi_startproc
  // Intel opt. manual says to
  // "make the fall-through code following a conditional branch be the likely target for a branch with a forward target"
  // to hint static predictor.
  cmp $0, _libdelay_so_tramp_table+0(%rip)
  je 2f
1:
  jmp *_libdelay_so_tramp_table+0(%rip)
2:
  pushq $0
  .cfi_adjust_cfa_offset 8
  call _libdelay_so_save_regs_and_resolve
  addq $8, %rsp
  .cfi_adjust_cfa_offset -8
  jmp 1b
  .cfi_endproc

