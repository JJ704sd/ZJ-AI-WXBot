
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001809eacf0 <.text+0x9e9cf0>:
   1809eacf0:	55                   	push   rbp
   1809eacf1:	41 56                	push   r14
   1809eacf3:	56                   	push   rsi
   1809eacf4:	57                   	push   rdi
   1809eacf5:	53                   	push   rbx
   1809eacf6:	48 81 ec 20 01 00 00 	sub    rsp,0x120
   1809eacfd:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1809ead04:	00 
   1809ead05:	48 c7 85 98 00 00 00 	mov    QWORD PTR [rbp+0x98],0xfffffffffffffffe
   1809ead0c:	fe ff ff ff 
   1809ead10:	4c 89 cf             	mov    rdi,r9
   1809ead13:	4c 89 c3             	mov    rbx,r8
   1809ead16:	49 89 d6             	mov    r14,rdx
   1809ead19:	48 89 ce             	mov    rsi,rcx
   1809ead1c:	0f 57 c0             	xorps  xmm0,xmm0
   1809ead1f:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   1809ead23:	48 c7 45 e8 00 00 00 	mov    QWORD PTR [rbp-0x18],0x0
   1809ead2a:	00 
   1809ead2b:	49 8b 49 38          	mov    rcx,QWORD PTR [r9+0x38]
   1809ead2f:	48 85 c9             	test   rcx,rcx
   1809ead32:	74 36                	je     0x1809ead6a
   1809ead34:	48 39 f9             	cmp    rcx,rdi
   1809ead37:	74 06                	je     0x1809ead3f
   1809ead39:	48 89 4d e8          	mov    QWORD PTR [rbp-0x18],rcx
   1809ead3d:	eb 23                	jmp    0x1809ead62
   1809ead3f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809ead42:	48 8d 55 b0          	lea    rdx,[rbp-0x50]
   1809ead46:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1809ead49:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   1809ead4d:	48 8b 4f 38          	mov    rcx,QWORD PTR [rdi+0x38]
   1809ead51:	48 85 c9             	test   rcx,rcx
   1809ead54:	74 14                	je     0x1809ead6a
   1809ead56:	48 39 f9             	cmp    rcx,rdi
   1809ead59:	0f 95 c2             	setne  dl
   1809ead5c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809ead5f:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1809ead62:	48 c7 47 38 00 00 00 	mov    QWORD PTR [rdi+0x38],0x0
   1809ead69:	00 
   1809ead6a:	48 c7 45 28 00 00 00 	mov    QWORD PTR [rbp+0x28],0x0
   1809ead71:	00 
   1809ead72:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   1809ead76:	48 85 c9             	test   rcx,rcx
   1809ead79:	74 36                	je     0x1809eadb1
   1809ead7b:	48 39 d9             	cmp    rcx,rbx
   1809ead7e:	74 06                	je     0x1809ead86
   1809ead80:	48 89 4d 28          	mov    QWORD PTR [rbp+0x28],rcx
   1809ead84:	eb 23                	jmp    0x1809eada9
   1809ead86:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809ead89:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1809ead8d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1809ead90:	48 89 45 28          	mov    QWORD PTR [rbp+0x28],rax
   1809ead94:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   1809ead98:	48 85 c9             	test   rcx,rcx
   1809ead9b:	74 14                	je     0x1809eadb1
   1809ead9d:	48 39 d9             	cmp    rcx,rbx
   1809eada0:	0f 95 c2             	setne  dl
   1809eada3:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809eada6:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1809eada9:	48 c7 43 38 00 00 00 	mov    QWORD PTR [rbx+0x38],0x0
   1809eadb0:	00 
   1809eadb1:	48 c7 45 68 00 00 00 	mov    QWORD PTR [rbp+0x68],0x0
   1809eadb8:	00 
   1809eadb9:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   1809eadbd:	48 85 c9             	test   rcx,rcx
   1809eadc0:	74 36                	je     0x1809eadf8
   1809eadc2:	4c 39 f1             	cmp    rcx,r14
   1809eadc5:	74 06                	je     0x1809eadcd
   1809eadc7:	48 89 4d 68          	mov    QWORD PTR [rbp+0x68],rcx
   1809eadcb:	eb 23                	jmp    0x1809eadf0
   1809eadcd:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809eadd0:	48 8d 55 30          	lea    rdx,[rbp+0x30]
   1809eadd4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1809eadd7:	48 89 45 68          	mov    QWORD PTR [rbp+0x68],rax
   1809eaddb:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   1809eaddf:	48 85 c9             	test   rcx,rcx
   1809eade2:	74 14                	je     0x1809eadf8
   1809eade4:	4c 39 f1             	cmp    rcx,r14
   1809eade7:	0f 95 c2             	setne  dl
   1809eadea:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809eaded:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1809eadf0:	49 c7 46 38 00 00 00 	mov    QWORD PTR [r14+0x38],0x0
   1809eadf7:	00 
   1809eadf8:	4c 89 b5 90 00 00 00 	mov    QWORD PTR [rbp+0x90],r14
   1809eadff:	48 89 9d 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rbx
   1809eae06:	48 89 bd 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rdi
   1809eae0d:	48 8d 45 70          	lea    rax,[rbp+0x70]
   1809eae11:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1809eae16:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
   1809eae1d:	00 00 
   1809eae1f:	48 8d 55 30          	lea    rdx,[rbp+0x30]
   1809eae23:	4c 8d 45 f0          	lea    r8,[rbp-0x10]
   1809eae27:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1809eae2b:	48 89 f1             	mov    rcx,rsi
   1809eae2e:	e8 dd 4a 62 ff       	call   0x18000f910
   1809eae33:	90                   	nop
   1809eae34:	48 8b 7d 78          	mov    rdi,QWORD PTR [rbp+0x78]
   1809eae38:	48 85 ff             	test   rdi,rdi
   1809eae3b:	74 1d                	je     0x1809eae5a
   1809eae3d:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1809eae41:	75 17                	jne    0x1809eae5a
   1809eae43:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1809eae46:	48 89 f9             	mov    rcx,rdi
   1809eae49:	ff 10                	call   QWORD PTR [rax]
   1809eae4b:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1809eae4f:	75 09                	jne    0x1809eae5a
   1809eae51:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1809eae54:	48 89 f9             	mov    rcx,rdi
   1809eae57:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1809eae5a:	48 8b 85 90 00 00 00 	mov    rax,QWORD PTR [rbp+0x90]
   1809eae61:	48 8b 48 38          	mov    rcx,QWORD PTR [rax+0x38]
   1809eae65:	48 85 c9             	test   rcx,rcx
   1809eae68:	48 8b 9d 88 00 00 00 	mov    rbx,QWORD PTR [rbp+0x88]
   1809eae6f:	74 0c                	je     0x1809eae7d
   1809eae71:	48 39 c1             	cmp    rcx,rax
   1809eae74:	0f 95 c2             	setne  dl
   1809eae77:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809eae7a:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1809eae7d:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   1809eae81:	48 85 c9             	test   rcx,rcx
   1809eae84:	48 8b bd 80 00 00 00 	mov    rdi,QWORD PTR [rbp+0x80]
   1809eae8b:	74 0c                	je     0x1809eae99
   1809eae8d:	48 39 d9             	cmp    rcx,rbx
   1809eae90:	0f 95 c2             	setne  dl
   1809eae93:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809eae96:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1809eae99:	48 8b 4f 38          	mov    rcx,QWORD PTR [rdi+0x38]
   1809eae9d:	48 85 c9             	test   rcx,rcx
   1809eaea0:	74 0c                	je     0x1809eaeae
   1809eaea2:	48 39 f9             	cmp    rcx,rdi
   1809eaea5:	0f 95 c2             	setne  dl
   1809eaea8:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1809eaeab:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1809eaeae:	48 89 f0             	mov    rax,rsi
   1809eaeb1:	48 81 c4 20 01 00 00 	add    rsp,0x120
   1809eaeb8:	5b                   	pop    rbx
   1809eaeb9:	5f                   	pop    rdi
   1809eaeba:	5e                   	pop    rsi
   1809eaebb:	41 5e                	pop    r14
   1809eaebd:	5d                   	pop    rbp
   1809eaebe:	c3                   	ret
