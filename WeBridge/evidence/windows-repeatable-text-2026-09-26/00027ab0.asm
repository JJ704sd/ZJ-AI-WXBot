
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000180027a80 <.text+0x26a80>:
   180027a80:	55                   	push   rbp
   180027a81:	41 56                	push   r14
   180027a83:	56                   	push   rsi
   180027a84:	57                   	push   rdi
   180027a85:	53                   	push   rbx
   180027a86:	48 83 ec 30          	sub    rsp,0x30
   180027a8a:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   180027a8f:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   180027a96:	ff 
   180027a97:	48 89 d7             	mov    rdi,rdx
   180027a9a:	49 89 ce             	mov    r14,rcx
   180027a9d:	48 8b 1a             	mov    rbx,QWORD PTR [rdx]
   180027aa0:	85 db                	test   ebx,ebx
   180027aa2:	0f 8e f8 00 00 00    	jle    0x180027ba0
   180027aa8:	41 89 d8             	mov    r8d,ebx
   180027aab:	41 81 e0 ff ff ff 7f 	and    r8d,0x7fffffff
   180027ab2:	b9 04 00 00 00       	mov    ecx,0x4
   180027ab7:	ba 08 00 00 00       	mov    edx,0x8
   180027abc:	45 31 c9             	xor    r9d,r9d
   180027abf:	e8 3c 0c 01 00       	call   0x180038700
   180027ac4:	48 89 c6             	mov    rsi,rax
   180027ac7:	49 89 06             	mov    QWORD PTR [r14],rax
   180027aca:	48 85 c0             	test   rax,rax
   180027acd:	75 05                	jne    0x180027ad4
   180027acf:	e8 2c 42 12 00       	call   0x18014bd00
   180027ad4:	89 5e 04             	mov    DWORD PTR [rsi+0x4],ebx
   180027ad7:	81 e3 ff ff ff 7f    	and    ebx,0x7fffffff
   180027add:	48 c1 e3 02          	shl    rbx,0x2
   180027ae1:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   180027ae5:	48 01 f1             	add    rcx,rsi
   180027ae8:	31 d2                	xor    edx,edx
   180027aea:	49 89 d8             	mov    r8,rbx
   180027aed:	e8 fe cb 51 07       	call   0x1875446f0
   180027af2:	48 8b 1f             	mov    rbx,QWORD PTR [rdi]
   180027af5:	48 8b 56 10          	mov    rdx,QWORD PTR [rsi+0x10]
   180027af9:	48 01 f2             	add    rdx,rsi
   180027afc:	48 85 db             	test   rbx,rbx
   180027aff:	0f 8e b5 00 00 00    	jle    0x180027bba
   180027b05:	4c 8b 4f 08          	mov    r9,QWORD PTR [rdi+0x8]
   180027b09:	49 8d 04 59          	lea    rax,[r9+rbx*2]
   180027b0d:	48 89 d1             	mov    rcx,rdx
   180027b10:	eb 24                	jmp    0x180027b36
   180027b12:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   180027b19:	1f 84 00 00 00 00 00 
   180027b20:	45 89 d3             	mov    r11d,r10d
   180027b23:	44 89 19             	mov    DWORD PTR [rcx],r11d
   180027b26:	48 83 c1 04          	add    rcx,0x4
   180027b2a:	48 83 c2 04          	add    rdx,0x4
   180027b2e:	4d 89 c1             	mov    r9,r8
   180027b31:	49 39 c0             	cmp    r8,rax
   180027b34:	73 64                	jae    0x180027b9a
   180027b36:	4d 8d 41 02          	lea    r8,[r9+0x2]
   180027b3a:	41 0f b7 39          	movzx  edi,WORD PTR [r9]
   180027b3e:	44 0f b7 d7          	movzx  r10d,di
   180027b42:	41 89 fb             	mov    r11d,edi
   180027b45:	41 81 e3 00 f8 00 00 	and    r11d,0xf800
   180027b4c:	41 81 fb 00 d8 00 00 	cmp    r11d,0xd800
   180027b53:	75 cb                	jne    0x180027b20
   180027b55:	81 e7 00 dc 00 00    	and    edi,0xdc00
   180027b5b:	41 bb fd ff 00 00    	mov    r11d,0xfffd
   180027b61:	81 ff 00 d8 00 00    	cmp    edi,0xd800
   180027b67:	75 ba                	jne    0x180027b23
   180027b69:	49 39 c0             	cmp    r8,rax
   180027b6c:	73 b5                	jae    0x180027b23
   180027b6e:	41 0f b7 38          	movzx  edi,WORD PTR [r8]
   180027b72:	89 fb                	mov    ebx,edi
   180027b74:	81 e3 00 fc 00 00    	and    ebx,0xfc00
   180027b7a:	81 fb 00 dc 00 00    	cmp    ebx,0xdc00
   180027b80:	75 a1                	jne    0x180027b23
   180027b82:	49 83 c1 04          	add    r9,0x4
   180027b86:	41 c1 e2 0a          	shl    r10d,0xa
   180027b8a:	45 8d 1c 3a          	lea    r11d,[r10+rdi*1]
   180027b8e:	41 81 c3 00 24 a0 fc 	add    r11d,0xfca02400
   180027b95:	4d 89 c8             	mov    r8,r9
   180027b98:	eb 89                	jmp    0x180027b23
   180027b9a:	48 03 76 10          	add    rsi,QWORD PTR [rsi+0x10]
   180027b9e:	eb 1d                	jmp    0x180027bbd
   180027ba0:	48 8d 35 a9 3f 01 0b 	lea    rsi,[rip+0xb013fa9]        # 0x18b03bb50
   180027ba7:	49 89 36             	mov    QWORD PTR [r14],rsi
   180027baa:	48 8b 56 10          	mov    rdx,QWORD PTR [rsi+0x10]
   180027bae:	48 01 f2             	add    rdx,rsi
   180027bb1:	48 85 db             	test   rbx,rbx
   180027bb4:	0f 8f 4b ff ff ff    	jg     0x180027b05
   180027bba:	48 89 d6             	mov    rsi,rdx
   180027bbd:	48 29 f2             	sub    rdx,rsi
   180027bc0:	48 c1 ea 02          	shr    rdx,0x2
   180027bc4:	4c 89 f1             	mov    rcx,r14
   180027bc7:	4c 89 75 f0          	mov    QWORD PTR [rbp-0x10],r14
   180027bcb:	e8 e0 fd 00 00       	call   0x1800379b0
   180027bd0:	90                   	nop
   180027bd1:	48 83 c4 30          	add    rsp,0x30
   180027bd5:	5b                   	pop    rbx
   180027bd6:	5f                   	pop    rdi
   180027bd7:	5e                   	pop    rsi
   180027bd8:	41 5e                	pop    r14
   180027bda:	5d                   	pop    rbp
   180027bdb:	c3                   	ret
