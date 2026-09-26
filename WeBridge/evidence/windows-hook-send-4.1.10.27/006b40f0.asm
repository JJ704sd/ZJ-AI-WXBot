
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001806b40f0 <.text+0x6b30f0>:
   1806b40f0:	55                   	push   rbp
   1806b40f1:	41 56                	push   r14
   1806b40f3:	56                   	push   rsi
   1806b40f4:	57                   	push   rdi
   1806b40f5:	53                   	push   rbx
   1806b40f6:	48 83 ec 30          	sub    rsp,0x30
   1806b40fa:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   1806b40ff:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1806b4106:	ff 
   1806b4107:	48 89 d7             	mov    rdi,rdx
   1806b410a:	48 89 ce             	mov    rsi,rcx
   1806b410d:	b9 58 07 00 00       	mov    ecx,0x758
   1806b4112:	e8 e5 8f 15 06       	call   0x18680d0fc
   1806b4117:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   1806b411e:	00 00 00 
   1806b4121:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   1806b4125:	48 8d 0d 2c 52 bc 07 	lea    rcx,[rip+0x7bc522c]        # 0x188279358
   1806b412c:	48 89 08             	mov    QWORD PTR [rax],rcx
   1806b412f:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   1806b4133:	48 8d 58 10          	lea    rbx,[rax+0x10]
   1806b4137:	48 89 d9             	mov    rcx,rbx
   1806b413a:	48 89 fa             	mov    rdx,rdi
   1806b413d:	e8 be 00 00 00       	call   0x1806b4200
   1806b4142:	90                   	nop
   1806b4143:	48 89 1e             	mov    QWORD PTR [rsi],rbx
   1806b4146:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
   1806b414a:	48 89 56 08          	mov    QWORD PTR [rsi+0x8],rdx
   1806b414e:	48 8b 42 20          	mov    rax,QWORD PTR [rdx+0x20]
   1806b4152:	48 85 c0             	test   rax,rax
   1806b4155:	74 06                	je     0x1806b415d
   1806b4157:	83 78 08 00          	cmp    DWORD PTR [rax+0x8],0x0
   1806b415b:	75 61                	jne    0x1806b41be
   1806b415d:	41 b6 01             	mov    r14b,0x1
   1806b4160:	48 85 d2             	test   rdx,rdx
   1806b4163:	74 16                	je     0x1806b417b
   1806b4165:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   1806b4169:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   1806b416d:	48 85 ff             	test   rdi,rdi
   1806b4170:	74 09                	je     0x1806b417b
   1806b4172:	f0 ff 47 0c          	lock inc DWORD PTR [rdi+0xc]
   1806b4176:	45 31 f6             	xor    r14d,r14d
   1806b4179:	eb 04                	jmp    0x1806b417f
   1806b417b:	31 ff                	xor    edi,edi
   1806b417d:	31 db                	xor    ebx,ebx
   1806b417f:	48 89 5a 18          	mov    QWORD PTR [rdx+0x18],rbx
   1806b4183:	48 8b 4a 20          	mov    rcx,QWORD PTR [rdx+0x20]
   1806b4187:	48 89 7a 20          	mov    QWORD PTR [rdx+0x20],rdi
   1806b418b:	48 85 c9             	test   rcx,rcx
   1806b418e:	74 0c                	je     0x1806b419c
   1806b4190:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   1806b4194:	75 06                	jne    0x1806b419c
   1806b4196:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1806b4199:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806b419c:	45 84 f6             	test   r14b,r14b
   1806b419f:	75 1d                	jne    0x1806b41be
   1806b41a1:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1806b41a5:	75 17                	jne    0x1806b41be
   1806b41a7:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1806b41aa:	48 89 f9             	mov    rcx,rdi
   1806b41ad:	ff 10                	call   QWORD PTR [rax]
   1806b41af:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1806b41b3:	75 09                	jne    0x1806b41be
   1806b41b5:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1806b41b8:	48 89 f9             	mov    rcx,rdi
   1806b41bb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806b41be:	48 89 f0             	mov    rax,rsi
   1806b41c1:	48 83 c4 30          	add    rsp,0x30
   1806b41c5:	5b                   	pop    rbx
   1806b41c6:	5f                   	pop    rdi
   1806b41c7:	5e                   	pop    rsi
   1806b41c8:	41 5e                	pop    r14
   1806b41ca:	5d                   	pop    rbp
   1806b41cb:	c3                   	ret
