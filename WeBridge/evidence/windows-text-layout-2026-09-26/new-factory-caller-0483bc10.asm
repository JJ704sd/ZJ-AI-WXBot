
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018483bc10 <.text+0x483ac10>:
   18483bc10:	55                   	push   rbp
   18483bc11:	41 56                	push   r14
   18483bc13:	56                   	push   rsi
   18483bc14:	57                   	push   rdi
   18483bc15:	53                   	push   rbx
   18483bc16:	48 83 ec 40          	sub    rsp,0x40
   18483bc1a:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   18483bc1f:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   18483bc26:	ff 
   18483bc27:	89 d7                	mov    edi,edx
   18483bc29:	48 89 ce             	mov    rsi,rcx
   18483bc2c:	0f 28 05 7d 9f 50 04 	movaps xmm0,XMMWORD PTR [rip+0x4509f7d]        # 0x188d45bb0
   18483bc33:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   18483bc37:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   18483bc3b:	e8 30 90 eb fb       	call   0x1806f4c70
   18483bc40:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   18483bc44:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   18483bc4b:	00 00 00 
   18483bc4e:	83 ff 2b             	cmp    edi,0x2b
   18483bc51:	74 45                	je     0x18483bc98
   18483bc53:	83 ff 03             	cmp    edi,0x3
   18483bc56:	75 79                	jne    0x18483bcd1
   18483bc58:	e8 43 4a 88 fb       	call   0x1800c06a0
   18483bc5d:	90                   	nop
   18483bc5e:	48 89 c7             	mov    rdi,rax
   18483bc61:	4c 8b 75 e0          	mov    r14,QWORD PTR [rbp-0x20]
   18483bc65:	49 8d 9e 58 07 00 00 	lea    rbx,[r14+0x758]
   18483bc6c:	48 89 c1             	mov    rcx,rax
   18483bc6f:	e8 2c 89 ce 02       	call   0x1875245a0
   18483bc74:	49 8b 8e 70 07 00 00 	mov    rcx,QWORD PTR [r14+0x770]
   18483bc7b:	48 39 c8             	cmp    rax,rcx
   18483bc7e:	0f 86 86 00 00 00    	jbe    0x18483bd0a
   18483bc84:	48 89 d9             	mov    rcx,rbx
   18483bc87:	48 89 c2             	mov    rdx,rax
   18483bc8a:	49 89 f9             	mov    r9,rdi
   18483bc8d:	e8 be 24 80 fb       	call   0x18003e150
   18483bc92:	90                   	nop
   18483bc93:	e9 97 00 00 00       	jmp    0x18483bd2f
   18483bc98:	e8 23 51 88 fb       	call   0x1800c0dc0
   18483bc9d:	90                   	nop
   18483bc9e:	48 89 c7             	mov    rdi,rax
   18483bca1:	4c 8b 75 e0          	mov    r14,QWORD PTR [rbp-0x20]
   18483bca5:	49 8d 9e 58 07 00 00 	lea    rbx,[r14+0x758]
   18483bcac:	48 89 c1             	mov    rcx,rax
   18483bcaf:	e8 ec 88 ce 02       	call   0x1875245a0
   18483bcb4:	49 8b 8e 70 07 00 00 	mov    rcx,QWORD PTR [r14+0x770]
   18483bcbb:	48 39 c8             	cmp    rax,rcx
   18483bcbe:	76 4a                	jbe    0x18483bd0a
   18483bcc0:	48 89 d9             	mov    rcx,rbx
   18483bcc3:	48 89 c2             	mov    rdx,rax
   18483bcc6:	49 89 f9             	mov    r9,rdi
   18483bcc9:	e8 82 24 80 fb       	call   0x18003e150
   18483bcce:	90                   	nop
   18483bccf:	eb 5e                	jmp    0x18483bd2f
   18483bcd1:	e8 0a 20 8a fb       	call   0x1800ddce0
   18483bcd6:	90                   	nop
   18483bcd7:	48 89 c7             	mov    rdi,rax
   18483bcda:	4c 8b 75 e0          	mov    r14,QWORD PTR [rbp-0x20]
   18483bcde:	49 8d 9e 58 07 00 00 	lea    rbx,[r14+0x758]
   18483bce5:	48 89 c1             	mov    rcx,rax
   18483bce8:	e8 b3 88 ce 02       	call   0x1875245a0
   18483bced:	49 8b 8e 70 07 00 00 	mov    rcx,QWORD PTR [r14+0x770]
   18483bcf4:	48 39 c8             	cmp    rax,rcx
   18483bcf7:	76 11                	jbe    0x18483bd0a
   18483bcf9:	48 89 d9             	mov    rcx,rbx
   18483bcfc:	48 89 c2             	mov    rdx,rax
   18483bcff:	49 89 f9             	mov    r9,rdi
   18483bd02:	e8 49 24 80 fb       	call   0x18003e150
   18483bd07:	90                   	nop
   18483bd08:	eb 25                	jmp    0x18483bd2f
   18483bd0a:	48 83 f9 10          	cmp    rcx,0x10
   18483bd0e:	72 03                	jb     0x18483bd13
   18483bd10:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   18483bd13:	49 89 86 68 07 00 00 	mov    QWORD PTR [r14+0x768],rax
   18483bd1a:	48 89 d9             	mov    rcx,rbx
   18483bd1d:	48 89 fa             	mov    rdx,rdi
   18483bd20:	49 89 c0             	mov    r8,rax
   18483bd23:	48 89 c7             	mov    rdi,rax
   18483bd26:	e8 25 83 d0 02       	call   0x187544050
   18483bd2b:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   18483bd2f:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   18483bd33:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   18483bd37:	48 8b 88 68 07 00 00 	mov    rcx,QWORD PTR [rax+0x768]
   18483bd3e:	48 89 88 c8 01 00 00 	mov    QWORD PTR [rax+0x1c8],rcx
   18483bd45:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   18483bd48:	48 89 f0             	mov    rax,rsi
   18483bd4b:	48 83 c4 40          	add    rsp,0x40
   18483bd4f:	5b                   	pop    rbx
   18483bd50:	5f                   	pop    rdi
   18483bd51:	5e                   	pop    rsi
   18483bd52:	41 5e                	pop    r14
   18483bd54:	5d                   	pop    rbp
   18483bd55:	c3                   	ret
