.text
.align	  2
.global  main

.equ  next,0
.equ  payload, 8

InitRegs:
		stp		x29, x30, [sp, -16]!
		stp     x20, x21, [sp, -16] !
		mov		x0, xzr

		mov 	x1, 1
		mov		x2, 2
		mov		x3, 3
		mov		x4, 4
		mov		x5, 5
		mov		x6, 6
		mov		x7, 7
		mov		x8, 8
		mov		x9, 9
		mov		x10, 10
		mov		x11, 11
		mov		x12, 12
		mov		x13, 13
		mov		x14, 14
		mov		x15, 15
		mov		x16, 16
		mov		x17, 17
		mov		x18, 18
		mov		x19, 19
		mov		x20, 20
		mov		x21, 21
		mov		x22, 22
		mov		x23, 23
		mov		x24, 24
		mov		x25, 25
		mov		x26, 26
		mov		x27, 27
		mov		x28, 28
		ldp		x29, x30, [sp], 16
		ret
		

main:	stp		x29, x30, [sp, -16]!
		bl		InitRegs
		mov		x0, 16			// suggest inf reg
		bl		malloc			// suggest inf reg
		ldr		x1, =index
		str		x0, [x1]
		str		x0, [sp, -16]!
		bl		InitRegs
		ldr		x1, [sp], 16
		ldr		x0, =s
		bl		printf
		ldp		x29, x30, [sp], 16
		mov		x0, xzr 
		ret

head:   		ldr		x0, [x3, +next]
				ldr 	w1, [x3, payload] 
				mov		x3, x1 		//x1 holds "next"
				mov 	w1, 8 		//w1 holds unsigned int
		

loop:  	 		mov		x3, 0 		// if ref is NULL, return:
				ldr 	x2, [x3] 	// load reference pointer into unsigned int value, add it to x0
				add		x0, x0, x2  
				ldr 	x3, [x3, 4]  //this updates ref->next
				b 		loop

front:  
				stmdb 	sp!, {x20, x21, lr} // push x20, x21, lr onto stack
				mov 	x0, 8 			// call malloc(8)
				bl 		malloc 
				ldmia   sp!, {x22, x23, lr}  //pop stack into x22, x23, lr
				str 	x23, [x20] 			//n->value = val (I pushed x21 popped into x23)
				str 	x22, [x20, 4] 		//n->next = head (pushed x20 popped into x22)
				ret 	x20 		
				ldr 	x0, =answer
				bl 		printf		

remove: 
				stmdb 	sp!, {xo, x4, lr} 	// Saved "head", x4, lr onto stack
				mov 	x2, x0 				// use x2 for "ref"
				mov 	x3, x0 				// use x3 for "prev"
				tst 	x2, x2 				// test if ref == null, returns x0 unchanged 

removloop:
				ldmia	sp!, {x0, x4, pc} 	// Loading muiltiple increments after
				ldr 	X4, [X2]  			// load ref->value
				cmp 	x4, x1 				// compare to value 
				beq 	remove_find			// if they match go to remove_find if they match
				mov 	x3, x2 				// if they don't match prev = cur
				ldr 	x2, [x2, 4] 		// ref = ref->next
				b 		removloop 			// repeats loop

remove_find:
				ldr 	x4,[x2, 4] 			//load ref->next into x4
				cmp 	x2, x0 				// Compares if ref ==  head
				streq 	x4, [sp] 			// if it does, replaces head on stack with x2
				strne 	x4,	[x3, 4] 		// if not, it saves x4 into prev->next
				mov 	x0, x2 				// frees(ref)
				bl 		free
				ldmia 	sp!, {x0, x4, pc} 	// ret head to stack
				bl 		printf
				
bottom: 		ldp     x20, x21, [sp], 16
                ldp     x29, x30, [sp], 16
                mov     x0, xzr
                ret


                .data

answer: 		.asciz 			"%d"

				.end
		