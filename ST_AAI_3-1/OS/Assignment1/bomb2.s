.globl main

.data
# -----------------------------------------------------------------------------
# Write your student id and password to defuse phase 1 ~ 3
# -----------------------------------------------------------------------------
your_id:
    .word   0x0141FF3E                  # Write your student id
your_password:
    .word   0x0141FF3E                  # Write your phase1 password
    .word   0xAF803040                  # Write your phase2 password
    .word   0x0D050201                  # Write your phase3 password

# -----------------------------------------------------------------------------
# Data section to execute this program
# -----------------------------------------------------------------------------
bye:
    .string "You are not my student, bye bye!\n"
bomb:
    .string "#### Bomb disposal is failed\n"
end:
    .string "The end\n"
phase1_intro:
    .string "[Phase1] Start defusing the first bomb\n"
phase1_outro:
    .string "[Phase1] You have successfully defused the first bomb!\n"
phase2_intro:
    .string "[Phase2] Start defusing the second bomb\n"
phase2_outro:
    .string "[Phase2] You have successfully defused the second bomb!\n"
phase3_intro:
    .string "[Phase3] Start defusing the thrid bomb\n"
phase3_outro:
    .string "[Phase3] You have successfully defused the thrid bomb!\n"
phase3_data:
    .word   0x00000000
    .word   0x00000000
    .word   0x00000000
    .word   0x00000000
    .word   0x00000000
    .word   0x00000000
    .word   0x00000000
    .word   0x00000000
phase3_parameter:
    .word   0x00000008
phase3_mask:
    .word   0x000000FF
phase4_intro:
    .string "[Phase4] Start defusing the final bomb.\n"
phase4_outro:
    .string "[Phase4] Congratulation! You have successfully defused all bombs\n"
phase4_data:
    .word   0x0151414C
    .word   0x0141FF17
    .word   0x0141FF36
    .word   0x0141FF24
    .word   0x01142F86
    .word   0x0141FC7C
    .word   0x0141FF1D
    .word   0x0141FF21
    .word   0x0141FF28    
    .word   0x0141FF19
    .word   0x0141FF3E
    .word   0x01237782
    .word   0x0141FF26
    .word   0x0141FD96
    .word   0x0141FF3F
    .word   0x0141FF12
    .word   0x01237443
    .word   0x0141FF38
    .word   0x0141FF11
    .word   0x0141FF34
    .word   0x0141FF20
    .word   0x0141FF2A
    .word   0x0141FF41    
    .word   0x0141FF29
    .word   0x0141FF2C
    .word   0x0141FF31
    .word   0x0141FF3A    
    .word   0x0141FF08
    .word   0x01514127
    .word   0x0141FF39
    .word   0x0141FF0F
    .word   0x0141FF15
    .word   0x0141FF22
    .word   0x0141FF40
    .word   0x0141FF23
    .word   0x0141FF0A

.text
# -------------------------------------------------------------------------
# Write your phase4 unlock code
# - The argument register a0 stores the address of phase4_data
# - You can use temporary registers t0 ~ t6
# - You can use saved registers s1 ~ s4
# -------------------------------------------------------------------------
phase4_unlock_code:
    addi sp, sp, -20                    # adjust stack pointer
    sw s1, 16(sp)                       # save s1 to stack
    sw s2, 12(sp)                       # save s2 to stack
    sw s3, 8(sp)                        # save s3 to stack
    sw s4, 4(sp)                        # save s4 to stack
    sw ra, 0(sp)                        # save ra to stack

    # Fill this
    add t6, a0, x0
    addi t0, x0, 0                      # t0 = i
    addi t1, x0, 0                      # t1 = j
    addi t5, x0, 35

phase4_bubble_loop:
    bge t1, t4, phase4_bubble_exit
    sub t4, t5, t0
    slli t2, t1, 2
    add t3, t6, t2
    lw s5, 0(t3)
    lw s6, 4(t3)
    jal ra, discriminate
    addi t1, t1, 1
    jal x0, phase4_bubble_loop

discriminate:
    addi sp, sp, -4
    sw ra, 0(sp)

    blt s5, s6, swap
    
    lw ra, 0(sp)
    addi sp, sp, 4
    jalr x0, ra, 0

swap:
    sw s6, 0(t3)
    sw s5, 4(t3)

    lw ra, 0(sp)
    addi sp, sp, 4
    jalr x0, ra, 0

phase4_bubble_exit:
    addi t0, t0, 1
    addi t1, x0, 0
    blt t0, t5, phase4_bubble_loop 
    
phase4_unlock_code_exit:
    lw s1, 16(sp)                       # restore s1 from stack
    lw s2, 12(sp)                       # restore s2 from stack
    lw s3, 8(sp)                        # restore s3 from stack
    lw s4, 4(sp)                        # restore s4 from stack
    lw ra, 0(sp)                        # restore ra from stack
    addi sp, sp, 20                     # adjust stack pointer
    jalr x0, ra, 0                      # return to caller

# -------------------------------------------------------------------------
# Main
# -------------------------------------------------------------------------
main:
    # Check student id
    la s0, your_id                      # load address of your student_id
    lw s0, 0(s0)                        # load your student_id
    add a0, s0, x0                      # a0 stores check_id parameter
    jal ra, check_id                    # call check_id
    blt a0, x0, main_bye                # a0 stores check_id return value

    # Load address of student password
    la s1, your_password                # load address of your password
                            
    # Phase 1
    addi a0, x0, 4                      # system call: print_string
    la a1, phase1_intro                 # load address of phase1_intro
    ecall                               # call print_string
    add a0, s0, x0                      # a0 stores phase1 parameter   
    lw a1, 0(s1)                        # a1 stores phase1 parameter
    jal ra, phase1                      # call phase1
    blt a0, x0, main_bomb               # a0 stores phase1 return value
    addi a0, x0, 4                      # system call: print_string
    la a1, phase1_outro                 # load address of phase1_outro
    ecall                               # call print_string

    # Phase 2
    addi a0, x0, 4                      # system call: print_string
    la a1, phase2_intro                 # load address of phase2_intro
    ecall                               # call print_string
    add a0, s0, x0                      # a0 stores phase2 parameter 
    lw a1, 4(s1)                        # a1 stores phase2 parameter
    jal ra, phase2                      # call phase2
    blt a0, x0, main_bomb               # a0 stores phase2 return value
    addi a0, x0, 4                      # system call: print_string
    la a1, phase2_outro                 # load address of phase2_outro
    ecall                               # call print_string

    # Phase 3
    addi a0, x0, 4                      # system call: print_string
    la a1, phase3_intro                 # load address of phase3_intro
    ecall                               # call print_string
    lw a0, 8(s1)                        # a0 stores phase3 parameter
    la a1, phase3_parameter             # load address of phase3_parameter
    lw a1, 0(a1)                        # a1 stores pahse3 parameter
    jal ra, phase3                      # call phase3
    blt a0, x0, main_bomb               # a0 stores phase3 return value
    addi a0, x0, 4                      # system call: print_string
    la a1, phase3_outro                 # load address of phase3_outro
    ecall                               # call print_string

    # Phase 4
    addi a0, x0, 4                      # system call: print_string
    la a1, phase4_intro                 # load address of phase4_intro
    ecall                               # call print_string0
    la a0, phase4_unlock_code           # a0 stores phase4 parameter
    jal ra, phase4                      # call phase4
    blt a0, x0, main_bomb               # a0 stores phase4 return value
    addi a0, x0, 4                      # system call: print_string
    la a1, phase4_outro                 # load address of phase4_outro
    ecall                               # call print_string

main_exit:
    addi a0, x0, 4                      # system call: print_string
    la a1, end                          # load address of end
    ecall                               # call print_string
    addi a0, x0, 10                     # system call: exit
    ecall                               # call exit

main_bye:
    addi a0, x0, 4                      # system call: print_string
    la a1, bye                          # load address of bye
    ecall                               # call print_string
    addi a0, x0, 10                     # system call: exit
    ecall                               # call exit

main_bomb:
    addi a0, x0, 4                      # system call: print_string
    la a1, bomb                         # load address of bomb
    ecall                               # call print_string
    addi a0, x0, 10                     # system call: exit
    ecall                               # call exit

# -----------------------------------------------------------------------------
# Procedure: phase 1
# -----------------------------------------------------------------------------
phase1:
    addi sp, sp, -4
    sw ra, 0(sp)
    add t0, a0, x0
    add t1, a1, x0
    bne t0, t1, phase1_something_wrong
    addi a0, x0, 0
    jal x0, phase1_exit

phase1_something_wrong:
    addi a0, x0, -1

phase1_exit:
    lw ra, 0(sp)
    addi sp, sp, 4
    jalr x0, ra, 0

# -----------------------------------------------------------------------------
# Procedure: phase 2
# -----------------------------------------------------------------------------
phase2:
    addi sp, sp, -4
    sw ra, 0(sp)
    add t0, a0, x0
    add t1, a1, x0
    srai t1, t1, 6
    xor t2, t0, t1
    addi t2, t2, 1
    bne t2, x0, phase2_something_wrong
    addi a0, x0, 0
    jal x0, phase2_exit

phase2_something_wrong:
    addi a0, x0, -1

phase2_exit:
    lw ra, 0(sp)
    addi sp, sp, 4
    jalr x0, ra, 0

# -----------------------------------------------------------------------------
# Procedure: phase 3
# -----------------------------------------------------------------------------
phase3:
    addi sp, sp, -8
    sw s1, 4(sp)
    sw ra, 0(sp)
    add s1, a0, x0
    add a0, a1, x0
    jal ra, phase3_device
    la t0, phase3_data 
    la t5, phase3_mask
    lw t5, 0(t5)
    lw t1, 4(t0)
    and t2, s1, t5
    bne t2, t1, phase3_something_wrong
    lw t1, 12(t0)
    slli t5, t5, 8
    and t2, s1, t5
    srli t2, t2, 8
    bne t2, t1, phase3_something_wrong
    lw t1, 20(t0)
    slli t5, t5, 8
    and t2, s1, t5
    srli t2, t2, 16
    bne t2, t1, phase3_something_wrong
    lw t1, 28(t0)
    slli t5, t5, 8
    and t2, s1, t5
    srli t2, t2, 24
    bne t2, t1, phase3_something_wrong
    addi a0, x0, 0
    jal x0, phase3_exit

phase3_something_wrong:
    addi a0, x0, -1

phase3_exit:
    lw ra, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 8
    jalr x0, ra, 0

phase3_device:
    addi sp, sp, -16
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw ra, 0(sp)
    add s1, a0, x0
    addi t0, x0, 2
    beq s1, t0, phase3_device_branch1
    addi t0, x0, 1
    beq s1, t0, phase3_device_branch1
    addi t0, x0, 0
    beq s1, t0, phase3_device_branch2
    addi a0, s1, -1
    jal ra, phase3_device
    add s2, a0, x0
    addi a0, s1, -2
    jal ra, phase3_device
    add s3, a0, x0
    add a0, s2, s3
    la t1, phase3_data
    slli t2, s1, 2
    add t3, t1, t2
    sw a0, 0(t3)
    jal x0, phase3_device_exit

phase3_device_branch1:
    addi a0, x0, 1 
    la t1, phase3_data
    slli t2, s1, 2
    add t3, t1, t2
    sw a0, 0(t3)
    jal x0, phase3_device_exit

phase3_device_branch2:
    addi a0, x0, 0
    la t1, phase3_data
    slli t2, s1, 2
    add t3, t1, t2
    sw a0, 0(t3) 
    jal x0, phase3_device_exit

phase3_device_exit:
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 16
    jalr x0, ra, 0

# -----------------------------------------------------------------------------
# Procedure: phase 4
# -----------------------------------------------------------------------------
phase4:
    addi sp, sp, -16
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw ra, 0(sp)                            
    add s1, a0, x0                          # s1 : phase4_unlock_code
    la a0, phase4_data                      # a0 : phase4_data
    jal ra, phase4_device
    add s2, a0, x0                          # s2 : a0 : ~35번째 학번
    la a0, phase4_data                      # a0 : phase4_data
    jalr ra, s1, 0                          # goto phase4_unlock_code
    la t0, phase4_data                      # t0 : phase4_data
    addi t1, x0, 0                          # t1 : 0
    addi t6, x0, 35                         # t6 : 35

phase4_check1:
    bge t1, t6, phase4_check2               # if (t1 >= t6): goto phase4_check2
    slli t2, t1, 2                          # t2 : t1 * 4
    add t2, t0, t2                          # t2 : phase4_data + 4 * t1
    lw  t3, 0(t2)                           # t3 : t1번째 학생 : 34번째 학생
    addi t4, t1, 1                          # t4 : t1 + 1 
    slli t4, t4, 2                          # t4 : 4 * (t1 + 1)
    add t4, t0, t4                          # t4 : phase4_data + 4 * (t1 + 1)
    lw  t5, 0(t4)                           # t5 : (t1+1)번째 학생 : 35번째 학생
    blt t3, t5, phase4_something_wrong      # if (t3 < t5): goto phase4_something_wrong -> 앞 학생이 뒷 학생보다 커야함 (내림차순)
    addi t1, t1, 1                          # t1 : t1 + 1
    jal x0, phase4_check1                   # Loop

phase4_check2:
    la a0, phase4_data                      # a0 : phase4_data
    jal ra, phase4_device                   # goto phase4_device
    add s3, a0, x0                          # s3 : ~35번째 학생 
    bne s2, s3, phase4_something_wrong      # s2 == s3 이어야 함
    addi a0, x0, 0                          # a0 : 0
    jal x0, phase4_exit

phase4_something_wrong:
    addi a0, x0, -1

phase4_exit:
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 16
    jalr x0, ra, 0

phase4_device:
    addi sp, sp, -4
    sw ra, 0(sp)                              
    add t6, a0, x0                          # t6 : phase4_data
    addi t0, x0, -1                         # t0 : -1
    addi t1, x0, 0                          # t1 : 0
    addi t5, x0, 36                         # t5 : 36

phase4_device_loop:
    bge t1, t5, phase4_device_loop_exit     # if (t1 >= t5): goto phase4_device_loop_exit
    slli t2, t1, 2                          # t2 : 4 * t1
    add t3, t6, t2                          # t3 : t6 + t2 : phase4_data + 4 * t1
    lw  t4, 0(t3)                           # t4 : t1번째 학번
    xor t0, t0, t4                          # t0 : ~(t1번째 학번) -> 루프를 빠져나갈 때, 35번째 학번
    addi t1, t1, 1                          # t1 : t1 + 1
    jal x0, phase4_device_loop              # goto phase4_device_loop

phase4_device_loop_exit:
    addi a0, t0, 0                          # a0 : ~35번째 학번

phase4_device_exit:
    lw ra, 0(sp)
    addi sp, sp, 4
    jalr x0, ra, 0
    
# -----------------------------------------------------------------------------
# Procedure: check_id
# -----------------------------------------------------------------------------
check_id:
    addi sp, sp, -4
    sw ra, 0(sp)
    add t6, a0, x0
    addi a0, x0, -1
    la t0, phase4_data
    addi t1, x0, 0
    addi t5, x0, 36

check_id_loop:
    bge t1, t5, check_id_exit
    slli t2, t1, 2
    add t3, t0, t2
    lw  t3, 0(t3)
    beq t6, t3, check_id_matched
    addi t1, t1, 1
    jal x0, check_id_loop

check_id_matched:
    addi a0, x0, 0
    
check_id_exit:
    lw ra, 0(sp)
    addi sp, sp, 4
    jalr x0, ra, 0